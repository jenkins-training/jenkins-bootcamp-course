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

# Update from OS install
apt-get update -y

# Common utilities
apt-get install -y nano zip unzip wget curl git

# Install Java 11
echo "Installing Java 11 LTS (OpenJDK - headless)"
apt-get install -y openjdk-11-jre-headless openjdk-11-jdk-headless

# install Jenkins LTS
echo "Installing Jenkins server"
cd
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
cd /etc/apt/sources.list.d
echo "deb https://pkg.jenkins.io/debian-stable binary/" >> jenkins.list
apt-get update -y
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