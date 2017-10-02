# Chef Development Environment Setup Automation for AWS EC2 using Terraform

##

#### Instructions
* git clone https://github.com/damithkothalawala/ChefDevSetup.git
* Download suitable terraform binary from https://www.terraform.io/downloads.html
* Copy terraform binary to cloned folder
* modify config.tfvars file to contain your AWS Credentials and other required info


## Testing 

#### ./terraform plan -var-file config.tfvars

## Apply 

#### ./terraform apply -var-file config.tfvars

## Destroy

#### ./terraform destroy -var-file config.tfvars

you will receive an email to your defined email address once bootstapping completed (Automation takes around 10 mins to complete on a t2.micro server.)
