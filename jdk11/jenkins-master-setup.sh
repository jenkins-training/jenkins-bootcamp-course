#!/bin/bash

# To setup a fresh EC2 or Lightsail Instance using Ubuntu 18.04 LTS
# Jenkins Master
# JDK 11 Based

## NOTE: NOT WORKING YET

JDK=11
JAVA_VERSION=11.0.2

export DEBIAN_FRONTEND=noninteractive

# Update from OS install
apt-get update -y
apt-get upgrade -y -o Dpkg::Options::='--force-confold'

sleep 10

# Common utilities
apt-get install -y nano zip unzip wget curl git

# Uninstall Java "11" (not really)
apt-get remove -y openjdk-11-jdk openjdk-11-jdk-headless

# Install Java 11 manually
if [ ! -d /usr/lib/jvm ]; then
  mkdir -p /usr/lib/jvm
fi

wget "https://download.java.net/java/GA/jdk${JDK}/9/GPL/openjdk-${JAVA_VERSION}_linux-x64_bin.tar.gz" -O /tmp/openjdk-bin.tar.gz
tar -xvzf /tmp/openjdk-bin.tar.gz --directory /usr/lib/jvm
for bin in /usr/lib/jvm/jdk-${JAVA_VERSION}/bin/*; do
  update-alternatives --install /usr/bin/$(basename $bin) $(basename $bin) $bin 5
  update-alternatives --set $(basename $bin) $bin
done
update-alternatives --config java

java -version

# install Jenkins
cd
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
cd /etc/apt/sources.list.d
echo "deb https://pkg.jenkins.io/debian-stable binary/" >> jenkins.list
apt-get update -y
apt-get install -y jenkins

systemctl start jenkins
systemctl enable jenkins
