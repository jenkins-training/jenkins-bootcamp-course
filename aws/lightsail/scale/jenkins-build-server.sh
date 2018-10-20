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
