#!/bin/bash

# Update from OS install
apt-get update -y

# Common utilities
apt-get install -y nano zip unzip wget curl git

# Install Java 8
apt-get install -y openjdk-8-jdk openjdk-8-jdk-headless

# install Jenkins
cd
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
cd /etc/apt/sources.list.d
echo "deb https://pkg.jenkins.io/debian-stable binary/" >> jenkins.list
apt-get update -y
apt-get install -y jenkins

systemctl start jenkins
systemctl enable jenkins
