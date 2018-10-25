#!/bin/bash

# Variables
MVN_VERSION="3.5.4"
ANT_VERSION="1.10.5"
GRADLE_VERSION="4.10.2"

# Update from OS install
apt-get update -y
sleep 10

# Common utilities
apt-get install -y nano wget curl git
apt-get install -y zip unzip
apt-get install -y build-essentials

# Install Java 8
apt-get install -y openjdk-8-jdk openjdk-8-jdk-headless

# Docker (official)
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

cd /etc/apt/sources.list.d
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" >> docker.list
apt-get update -y
apt-get install -y docker-ce
docker --version

# Install stuff in /usr/local
cd /usr/local

# Maven
wget https://www-us.apache.org/dist/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz
tar -xvzf apache-maven-$MVN_VERSION-bin.tar.gz
rm apache-maven-$MVN_VERSION-bin.tar.gz
chmod 755 apache-maven-$MVN_VERSION
ln -s apache-maven-$MVN_VERSION maven
ln -s maven/bin/mvn bin/mvn

# Ant
wget https://www-us.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz
tar -xvzf apache-ant-$ANT_VERSION-bin.tar.gz
rm apache-ant-$ANT_VERSION-bin.tar.gz
chmod 755 apache-ant-$ANT_VERSION
ln -s apache-ant-$ANT_VERSION ant
ln -s ant/bin/ant bin/ant

# Gradle
wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip
unzip gradle-$GRADLE_VERSION-bin.zip
rm gradle-$GRADLE_VERSION-bin.zip
chmod 755 gradle-$GRADLE_VERSION
ln -s gradle-$GRADLE_VERSION gradle
ln -s gradle/bin/gradle bin/gradle

# Node via NVM
cd /usr/local
mkdir -p /usr/local/nvm
chmod 755 nvm
export NVM_DIR="/usr/local/nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
sleep 10
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if [ -s "$NVM_DIR/nvm.sh" ]; then
    nvm install node
    nvm install --lts

    nvm exec --lts npm install -g karma grunt-cli webpack gulp-cli
    nvm exec npm install -g karma grunt-cli webpack gulp-cli
fi

# Setup Jenkins user
cd
adduser --disabled-password --gecos "" jenkins
adduser jenkins sudo

if [ -d /home/jenkins ]; then
    cd /home/jenkins
    mkdir .ssh
    chmod 700 .ssh
    chown jenkins.jenkins .ssh
    cd .ssh
    cp /home/ubuntu/.ssh/authorized_keys .
    chmod 600 authorized_keys
    chown jenkins.jenkins authorized_keys
fi
