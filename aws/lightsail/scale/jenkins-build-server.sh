#!/bin/bash

# Variables
MVN_VERSION="3.5.4"
ANT_VERSION="1.10.5"
GRADLE_VERSION="4.10.2"
GROOVY_VERION="2.5.3"
SCALA_VERION="2.12.7"
SBT_VERSION="1.2.6"
KOTLIN_VERSION="1.2.71"
GO_VERSION="1.11.1"


# Update from OS install
apt-get update -y
sleep 10

# Common utilities
apt-get install -y nano wget curl git python3
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

# Python 3, Pip and AWS CLI
apt-get install -y python3 python3-pip
python3 --version
pip3 --version
pip install awscli

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

# Groovy
wget https://dl.bintray.com/groovy/maven/apache-groovy-binary-$GROOVY_VERION.zip
unzip apache-groovy-binary-$GROOVY_VERION.zip
rm apache-groovy-binary-$GROOVY_VERION.zip
chmod 755 apache-groovy-$GROOVY_VERION
ln -s apache-groovy-$GROOVY_VERION groovy
ln -s groovy/bin/groovy bin/groovy

# SBT
wget https://piccolo.link/sbt-$SBT_VERSION.tgz
tar -xvzf sbt-$SBT_VERSION.tgz
rm sbt-$SBT_VERSION.tgz
chmod 755 sbt-$SBT_VERSION
ln -s sbt-$SBT_VERSION sbt
ln -s sbt/bin/sbt bin/sbt

# Scala
wget https://downloads.lightbend.com/scala/$SCALA_VERION/scala-$SCALA_VERION.tgz
tar -xvzf scala-$SCALA_VERION.tgz
rm scala-$SCALA_VERION.tgz
chmod 755 scala-$SCALA_VERION
ln -s scala-$SCALA_VERION scala
ln -s scala/bin/scala bin/scala

# Kotlin
wget https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN_VERSION/kotlin-compiler-$KOTLIN_VERSION-linux-x64.zip
unzip kotlin-compiler-$KOTLIN_VERSION-linux-x64.zip
rm kotlin-compiler-$KOTLIN_VERSION-linux-x64.zip
mv kotlinc kotlin-$KOTLIN_VERSION
ln -s kotlin-$KOTLIN_VERSION kotlin
ln -s kotlin/bin/kotlin bin/kotlin
ln -s kotlin/bin/kotlinc bin/kotlinc
ln -s kotlin/bin/kotlin-compiler bin/kotlin-compiler

# Go Lang
wget https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz
tar -xvzf go$GO_VERSION.linux-amd64.tar.gz
rm go$GO_VERSION.linux-amd64.tar.gz
mv go go-$GO_VERSION
ln -s go-$GO_VERSION go
ln -s go/bin/go bin/go

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
