#cloud-config
#Created by Damith Kothalawala 2017/08/15
package_upgrade: true
packages:
- vim
- mailx
runcmd:
- curl -s https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk
- su centos -c  "echo 'eval \"$(chef shell-init bash)\"' >> ~/.bash_profile"
- source ~/.bash_profile
- sudo yum install -y git yum-utils
- sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
- sudo yum makecache fast
- sudo yum -y install docker-ce
- sudo systemctl enable docker
- sudo systemctl start docker
- sudo usermod -aG docker centos
- sudo systemctl stop getty@tty1.service
- sudo systemctl mask getty@tty1.service
- su centos -c "docker network create --subnet=10.1.1.0/24 testnet"
- su centos -c "/opt/chefdk/embedded/bin/gem install kitchen-docker"
- su centos -c "git config --global user.name \"${gituser}\""
- su centos -c "git config --global user.email \"${email}\""
- su centos -c "git config --global core.editor vim"
- su centos -c "git config --global color.ui auto"
- echo "Your Chef Dev Env is Ready." | mail -s "Chef Development Server Ready" ${email}
