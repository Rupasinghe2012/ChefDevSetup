#(c) Damith Rushika Kothalawala 8/15/2017 | admin@drklk.org
#Chef Development Environment Setup

#varibles (please change config.tfvars)

variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "public_key" {}
variable "instance_type" {}
variable "email" {}
variable "gituser" {}

variable "amis" {
  type = "map"
}

#Define Cloud Provider

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

#SSH Key
resource "aws_key_pair" "chef" {
  key_name   = "chef-key"
  public_key = "${var.public_key}"
}

data "template_file" "chef" {
  template = "${file("chef.tpl")}"

  vars {
    email = "${var.email}"
    gituser = "${var.gituser}"
  }
}

#Detect Default VPC

resource "aws_default_vpc" "default" {
    tags {
        Name = "Default VPC"
    }
}

#Get Default Subnets

data "aws_subnet_ids" "default" {
  vpc_id = "${aws_default_vpc.default.id}"
}

#Creating Security Groups

resource "aws_security_group" "chef" {
  name        = "Chef Security Group"
  description = "Allow SSH inbound traffic"
  vpc_id = "${aws_default_vpc.default.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "chef"
  }
}

#Creating Web Servers and add to public subnet + bootstrap to install/enable/start apache. Please see web.conf for cloudinit script

resource "aws_instance" "chef" {
  count 	= 1
  subnet_id 	= "${element(data.aws_subnet_ids.default.ids, count.index)}"
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_type}"
  user_data     = "${data.template_file.chef.rendered}"
  security_groups = [
  	"${aws_security_group.chef.id}"
  ]
  tags {
    Name = "Chef Admin"
  }
 key_name = "${aws_key_pair.chef.id}"
}
output "SSH String for new Server" {
  value = "ssh centos@${aws_instance.chef.public_ip}"
}
output "Bootstrap Automation" {
  value = "You will receive an email to ${var.email} once Bootrap process done"
}
