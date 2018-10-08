#!/bin/bash

# Update from OS install
apt-get update -y

# Common utilities
apt-get install -y nano zip unzip wget curl git

# Install Java 8
apt-get install -y openjdk-8-jdk openjdk-8-jdk-headless

# install Maven
MVN_VER=3.5.4

cd /usr/local
wget http://www-us.apache.org/dist/maven/maven-3/$MVN_VER/binaries/apache-maven-$MVN_VER-bin.tar.gz
tar -xvzf apache-maven-$MVN_VER-bin.tar.gz
ln -s apache-maven-$MVN_VER maven
chown -R root.root apache-maven-$MVN_VER
chmod 755 apache-maven-$MVN_VER
ln -s maven/bin/mvn bin/mvn

# install Jenkins
cd
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
cd /etc/apt/sources.list.d
echo "deb https://pkg.jenkins.io/debian-stable binary/" >> jenkins.list
apt-get update -y
apt-get install -y jenkins

systemctl start jenkins
systemctl enable jenkins

apt-get install -y nginx

# remove default symlink
cd /etc/nginx/sites-enabled
rm default

cd /etc/nginx/conf.d
wget https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/aws/lightsail/lightsail-jenkins.conf

systemctl restart nginx
systemctl enable nginx
