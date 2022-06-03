#!/bin/bash

if [ -f /etc/os-release ]; then
    source /etc/os-release
else
    echo "Not Ubuntu - bailing"
    exit 1
fi

OS_ARCH=$(uname -m)
echo "Detecting ${PRETTY_NAME} on ${OS_ARCH}"

echo "Jenkins Server install script for Ubuntu"
echo "Script has been prepared for and tested on Ubuntu 20.04.x LTS"

if [ -z "$SETUP_COMMON" ]; then
    echo "Common stuff - just in case"
    wget -qO - https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/main/local/ubuntu/common.sh | bash
fi

apt-get install -y openjdk-11-jre-headless openjdk-11-jdk-headless
# starting v2.353+: apt-get install -y openjdk-17-jre-headless openjdk-17-jdk-headless

# install Jenkins LTS
echo "Installing Jenkins server"

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

apt-get update
apt-get install -y jenkins

systemctl start jenkins
systemctl enable jenkins

echo "Let's take a 10 second break to let Jenkins startup"
sleep 10

echo "Installing Nginx to serve as reverse proxy"
apt-get install -y nginx

# remove default symlink
cd /etc/nginx/sites-enabled
if [ -e default ]; then
  rm default
fi

cd /etc/nginx/conf.d
if [ -f jenkins-server-proxy.conf ]; then
  rm jenkins-server-proxy.conf
fi
wget -O jenkins-server-proxy.conf https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/main/local/ubuntu/nginx-jenkins.conf

systemctl restart nginx
systemctl enable nginx

echo "Installation Complete."
echo "Configure your hosts file to point to the server using the hostname: jenkins.local"

cd