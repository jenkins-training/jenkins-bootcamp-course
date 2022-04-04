#!/bin/bash

### VARS

# Maven Version
MVN_VER=3.8.5

### END VARS

echo "Jenkins Server install script for Ubuntu"
echo "Script has been prepared for and tested on Ubuntu 20.04.x LTS"

# Update from OS install
apt-get update -y

# Common utilities
apt-get install -y nano zip unzip wget curl git

# Install Java 11
echo "Installing Java 11 LTS (OpenJDK - headless)"
apt-get install -y openjdk-11-jre-headless openjdk-11-jdk-headless

## Maven Install
echo "Installing Maven $MVN_VER"
cd /usr/local
wget http://www-us.apache.org/dist/maven/maven-3/$MVN_VER/binaries/apache-maven-$MVN_VER-bin.tar.gz

if [ -f apache-maven-$MVN_VER-bin.tar.gz ]; then
  tar -xvzf apache-maven-$MVN_VER-bin.tar.gz
  ln -s apache-maven-$MVN_VER maven
  chown -R root.root apache-maven-$MVN_VER
  chmod 755 apache-maven-$MVN_VER
  ln -s maven/bin/mvn bin/mvn
fi

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
rm default

cd /etc/nginx/conf.d
wget -O jenkins-server-proxy.conf https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/main/local/ubuntu/nginx-jenkins.conf


systemctl restart nginx
systemctl enable nginx

echo "Installation Complete."
echo "If running on Ubuntu Desktop - access http://localhost/"
echo "Otherwise: Update your hosts file to point to this IP address"

cd