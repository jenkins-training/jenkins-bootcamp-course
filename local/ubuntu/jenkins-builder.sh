#!/bin/bash

if [ -f /etc/os-release ]; then
    source /etc/os-release
else
    echo "Not Ubuntu - bailing"
    exit 1
fi

OS_ARCH=$(uname -m)
echo "Detecting ${PRETTY_NAME} on ${OS_ARCH}"

# all | dev | devops
SETUP=$1
echo "Build node setup ${SETUP}"

# Variables
MVN_VERSION="3.8.5"
ANT_VERSION="1.10.12"
GRADLE_VERSION="7.4.2"
GROOVY_VERION="4.0.1"

KOTLIN_VERSION="1.3.10"
GO_VERSION="1.11.2"
PACKER_VERSION="1.3.2"
TF_VERSION="0.11.10"
SASS_VERSION="1.15.1"

# Update from OS install
apt-get update -y
apt-get upgrade -y
sleep 10

# Common utilities
apt-get install -y nano wget curl git python3 python3-pip
apt-get install -y zip unzip
apt-get install -y build-essentials

# Install Java 11
apt-get install -y openjdk-11-jdk openjdk-11-jdk-headless

# Docker (official)
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update -y
apt-get install -y docker-ce
docker --version

# Python 3 and PIP
python3 --version
pip3 --version
# pip3 install awscli # v1

# Ruby
apt-get install -y ruby-full
gem install bundler

# Install stuff in /usr/local
cd /usr/local


## Maven Install
echo "Installing Maven $MVN_VERSION"
wget https://dlcdn.apache.org/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz
if [ -f apache-maven-$MVN_VERSION-bin.tar.gz ]; then
  echo "Installing Maven 3"
  tar -xvzf apache-maven-$MVN_VERSION-bin.tar.gz
  ln -s apache-maven-$MVN_VERSION maven
  chown -R root.root apache-maven-$MVN_VERSION
  chmod 755 apache-maven-$MVN_VERSION
  ln -s /usr/local/maven/bin/mvn /usr/local/bin/mvn
else
  echo "Unable to find Maven installer"
fi

# Ant
echo "Installing Apache Ant $ANT_VERSION"
wget https://dlcdn.apache.org/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz
if [ -f apache-ant-$ANT_VERSION-bin.tar.gz ]; then
    tar -xvzf apache-ant-$ANT_VERSION-bin.tar.gz
    rm apache-ant-$ANT_VERSION-bin.tar.gz
    chmod 755 apache-ant-$ANT_VERSION
    ln -s apache-ant-$ANT_VERSION ant
    ln -s /usr/local/ant/bin/ant /usr/local/bin/ant
fi

# Gradle
echo "Installing Gradle $GRADLE_VERSION"
wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip
if [ -f gradle-$GRADLE_VERSION-bin.zip ]; then
    unzip gradle-$GRADLE_VERSION-bin.zip
    rm gradle-$GRADLE_VERSION-bin.zip
    chmod 755 gradle-$GRADLE_VERSION
    ln -s gradle-$GRADLE_VERSION gradle
    ln -s /usr/local/gradle/bin/gradle /usr/local/bin/gradle
fi

# Groovy
echo "Installing Groovy $GROOVY_VERION"
wget https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-$GROOVY_VERION.zip
if [ -f apache-groovy-binary-$GROOVY_VERION.zip ]; then
    unzip apache-groovy-binary-$GROOVY_VERION.zip
    rm apache-groovy-binary-$GROOVY_VERION.zip
    chmod 755 groovy-$GROOVY_VERION
    ln -s groovy-$GROOVY_VERION groovy
    ln -s /usr/local/groovy/bin/groovy /usr/local/bin/groovy
fi

# Scala tooling (Coursier)
echo "Installing Coursier"
cd /usr/local/bin
if [ "$OS_ARCH" == "aarch64" ]; then
    curl -fL https://github.com/coursier/launchers/raw/master/cs-aarch64-pc-linux.gz | gzip -d > cs
else
    curl -fL https://github.com/coursier/launchers/raw/master/cs-x86_64-pc-linux.gz | gzip -d > cs
fi
chmod +x cs
./cs setup --yes
cd /usr/local

# AWS CLI v2
echo "Setup AWS CLI"
if [ "$OS_ARCH" == "aarch64" ]; then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
else
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
fi

if [ -f awscliv2.zip ]; then
    unzip awscliv2.zip
    ./aws/install
    rm awscliv2.zip
fi


# Setup Jenkins user
cd
if [ ! -d /var/lib/jenkins ]; then
    echo "Setup Jenkins user"
    if [ ! -d /home/jenkins ]; then
        adduser --disabled-password --gecos "" jenkins
        adduser jenkins sudo
    fi
fi
