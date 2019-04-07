#!/bin/bash

export DEBIAN_FRONTEND=noninteractive 

# Variables
MVN_VERSION="3.6.0"
ANT_VERSION="1.10.5"
GRADLE_VERSION="5.3.1"
GROOVY_VERION="2.5.6"
SCALA_VERION="2.12.8"
SBT_VERSION="1.2.8"
KOTLIN_VERSION="1.3.21"
GO_VERSION="1.12.1"
PACKER_VERSION="1.3.5"
TF_VERSION="0.11.13"
SASS_VERSION="1.17.3"

# Update from OS install
apt-get update -y
apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
apt-get autoremove -y
sleep 10

# Common utilities
apt-get install -y nano wget curl git
apt-get install -y zip unzip
apt-get install -y build-essentials

# Install Java 8
apt-get install -y openjdk-8-jdk openjdk-8-jdk-headless

# Python 3, Pip and AWS CLI
apt-get install -y python3 python3-pip
python3 --version
pip3 --version
pip3 install awscli requests boto3

# Ruby
apt-get install -y ruby-full
gem install bundler

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
if [ -f apache-maven-$MVN_VERSION-bin.tar.gz ]; then
    tar -xvzf apache-maven-$MVN_VERSION-bin.tar.gz
    rm apache-maven-$MVN_VERSION-bin.tar.gz
    chmod 755 apache-maven-$MVN_VERSION
    ln -s apache-maven-$MVN_VERSION maven
    ln -s /usr/local/maven/bin/mvn /usr/local/bin/mvn
else
    echo "FAIL: apache-maven-$MVN_VERSION-bin.tar.gz failed to download - unable to install"
fi

# Ant
wget https://www-us.apache.org/dist/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz
if [ -f apache-ant-$ANT_VERSION-bin.tar.gz ]; then
    tar -xvzf apache-ant-$ANT_VERSION-bin.tar.gz
    rm apache-ant-$ANT_VERSION-bin.tar.gz
    chmod 755 apache-ant-$ANT_VERSION
    ln -s apache-ant-$ANT_VERSION ant
    ln -s /usr/local/ant/bin/ant /usr/local/bin/ant
else
    echo "FAIL: apache-ant-$ANT_VERSION-bin.tar.gz failed to download - unable to install"
fi

# Gradle
wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip
if [ -f gradle-$GRADLE_VERSION-bin.zip ]; then
    unzip gradle-$GRADLE_VERSION-bin.zip
    rm gradle-$GRADLE_VERSION-bin.zip
    chmod 755 gradle-$GRADLE_VERSION
    ln -s gradle-$GRADLE_VERSION gradle
    ln -s /usr/local/gradle/bin/gradle /usr/local/bin/gradle
else
    echo "FAIL: gradle-$GRADLE_VERSION-bin.zip failed to download - unable to install"
fi

# Groovy
wget https://dl.bintray.com/groovy/maven/apache-groovy-binary-$GROOVY_VERION.zip
if [ -f apache-groovy-binary-$GROOVY_VERION.zip ]; then
    unzip apache-groovy-binary-$GROOVY_VERION.zip
    rm apache-groovy-binary-$GROOVY_VERION.zip
    chmod 755 groovy-$GROOVY_VERION
    ln -s groovy-$GROOVY_VERION groovy
    ln -s /usr/local/groovy/bin/groovy /usr/local/bin/groovy
else
    echo "FAIL: apache-groovy-binary-$GROOVY_VERION.zip failed to download - unable to install"
fi

# SBT
wget https://piccolo.link/sbt-$SBT_VERSION.tgz
if [ -f sbt-$SBT_VERSION.tgz ]; then
    tar -xvzf sbt-$SBT_VERSION.tgz
    rm sbt-$SBT_VERSION.tgz
    mv sbt sbt-$SBT_VERSION
    chmod 755 sbt-$SBT_VERSION
    ln -s sbt-$SBT_VERSION sbt
    ln -s /usr/local/sbt/bin/sbt /usr/local/bin/sbt
else
    echo "FAIL: sbt-$SBT_VERSION.tgz failed to download - unable to install"
fi

# Scala
wget https://downloads.lightbend.com/scala/$SCALA_VERION/scala-$SCALA_VERION.tgz
if [ -f scala-$SCALA_VERION.tgz ]; then
    tar -xvzf scala-$SCALA_VERION.tgz
    rm scala-$SCALA_VERION.tgz
    chmod 755 scala-$SCALA_VERION
    ln -s scala-$SCALA_VERION scala
    ln -s /usr/local/scala/bin/scala /usr/local/bin/scala
else
    echo "FAIL: scala-$SCALA_VERION.tgz failed to download - unable to install"
fi

# Kotlin
wget https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN_VERSION/kotlin-compiler-$KOTLIN_VERSION.zip
if [ -f kotlin-compiler-$KOTLIN_VERSION.zip ]; then
    unzip kotlin-compiler-$KOTLIN_VERSION.zip
    rm kotlin-compiler-$KOTLIN_VERSION.zip
    mv kotlinc kotlin-$KOTLIN_VERSION
    ln -s kotlin-$KOTLIN_VERSION kotlin
    ln -s /usr/local/kotlin/bin/kotlin /usr/local/bin/kotlin
    ln -s /usr/local/kotlin/bin/kotlinc /usr/local/bin/kotlinc
    ln -s /usr/local/kotlin/bin/kotlin-compiler /usr/local/bin/kotlin-compiler
else
    echo "FAIL: kotlin-compiler-$KOTLIN_VERSION.zip failed to download - unable to install"
fi

# Go Lang
wget https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz
if [ -f go$GO_VERSION.linux-amd64.tar.gz ]; then
    tar -xvzf go$GO_VERSION.linux-amd64.tar.gz
    rm go$GO_VERSION.linux-amd64.tar.gz
    mv go go-$GO_VERSION
    ln -s go-$GO_VERSION go
    ln -s /usr/local/go/bin/go /usr/local/bin/go
else
    echo "FAIL: go$GO_VERSION.linux-amd64.tar.gz failed to download - unable to install"
fi

# Packer
wget "https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_${PACKER_VERSION}_linux_amd64.zip"
if [ -f "packer_${PACKER_VERSION}_linux_amd64.zip" ]; then
    unzip "packer_${PACKER_VERSION}_linux_amd64.zip"
    rm "packer_${PACKER_VERSION}_linux_amd64.zip"
    mkdir packer-$PACKER_VERSION
    mv packer packer-$PACKER_VERSION
    chmod 755 packer-$PACKER_VERSION
    ln -s packer-$PACKER_VERSION packer
    ln -s /usr/local/packer/packer /usr/local/bin/packer
else
    echo "FAIL: packer.zip failed to download - unable to install"
fi

# Terraform
wget "https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_${TF_VERSION}_linux_amd64.zip"
if [ -f "terraform_${TF_VERSION}_linux_amd64.zip" ]; then
    unzip "terraform_${TF_VERSION}_linux_amd64.zip"
    rm "terraform_${TF_VERSION}_linux_amd64.zip"
    mkdir terraform-$TF_VERSION
    mv terraform terraform-$TF_VERSION
    chmod 755 terraform-$TF_VERSION
    ln -s terraform-$TF_VERSION terraform
    ln -s /usr/local/terraform/terraform /usr/local/bin/terraform
    ln -s /usr/local/terraform/terraform /usr/local/bin/tf
else
    echo "FAIL: terraform.zip failed to download - unable to install"
fi

# Sass
wget https://github.com/sass/dart-sass/releases/download/$SASS_VERSION/dart-sass-$SASS_VERSION-linux-x64.tar.gz
if [ -f dart-sass-$SASS_VERSION-linux-x64.tar.gz ]; then
    tar -xvxf dart-sass-$SASS_VERSION-linux-x64.tar.gz
    rm dart-sass-$SASS_VERSION-linux-x64.tar.gz
    mv dart-sass dart-sass-$SASS_VERSION
    ln -s dart-sass-$SASS_VERSION sass
    ln -s /usr/local/sass/sass /usr/local/bin/sass
    ln -s /usr/local/sass/dart-sass /usr/local/bin/dart-sass
else
    echo "FAIL: dart-sass-$SASS_VERSION-linux-x64.tar.gz failed to download - unable to install"
fi

# Node via NVM
cd /usr/local
mkdir -p /usr/local/nvm
chmod 755 nvm
export NVM_DIR="/usr/local/nvm"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
sleep 10
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo 'export NVM_DIR="/usr/local/nvm"' >> /root/.bashrc
    echo '. $NVM_DIR/nvm.sh' >> /root/.bashrc

    echo 'export NVM_DIR="/usr/local/nvm"' >> /home/ubuntu/.bashrc
    echo '. $NVM_DIR/nvm.sh' >> /home/ubuntu/.bashrc
    chown ubuntu.ubuntu /home/ubuntu/.bashrc

    # Install latest Argon LTS
    nvm install --lts=argon
    nvm use --lts=argon
    sleep 5
    nvm version
    node --version
    NODE_VERSION=`node --version`
    ln -s /usr/local/nvm/versions/node/$NODE_VERSION /usr/local/nodejs-$NODE_VERSION
    npm install -g grunt-cli gulp-cli less typescript

    # Install latest Boron LTS
    nvm install --lts=boron
    nvm use --lts=boron
    sleep 5
    nvm version
    node --version
    NODE_VERSION=`node --version`
    ln -s /usr/local/nvm/versions/node/$NODE_VERSION /usr/local/nodejs-$NODE_VERSION
    npm install -g grunt-cli webpack webpack-cli gulp-cli less typescript cordova ionic

    # Install Carbon LTS
    nvm install --lts=carbon
    nvm use --lts=carbon
    sleep 5
    nvm version
    node --version
    NODE_VERSION=`node --version`
    ln -s /usr/local/nvm/versions/node/$NODE_VERSION /usr/local/nodejs-$NODE_VERSION
    npm install -g grunt-cli webpack webpack-cli gulp-cli less typescript @angular/cli cordova ionic

    # Install latest Dubnium LTS
    nvm install --lts=dubnium
    nvm use --lts=dubnium
    sleep 5
    nvm version
    node --version
    NODE_VERSION=`node --version`
    ln -s /usr/local/nvm/versions/node/$NODE_VERSION /usr/local/nodejs-$NODE_VERSION
    ln -s /usr/local/nvm/versions/node/$NODE_VERSION /usr/local/nodejs-lts
    npm install -g grunt-cli webpack webpack-cli gulp-cli less typescript @angular/cli cordova ionic

    # Install latest
    nvm install node
    nvm use node
    nvm alias default node
    sleep 5
    nvm version
    node --version
    NODE_VERSION=`node --version`
    ln -s /usr/local/nvm/versions/node/$NODE_VERSION /usr/local/nodejs-$NODE_VERSION
    ln -s /usr/local/nvm/versions/node/$NODE_VERSION /usr/local/nodejs
    npm install -g grunt-cli webpack webpack-cli gulp-cli less typescript @angular/cli cordova ionic
else
    echo "FAIL: NVM failed to download - unable to install"
fi

# Setup Jenkins user
cd
adduser --disabled-password --gecos "" jenkins
adduser jenkins sudo

if [ -d /home/jenkins ]; then
    cd /home/jenkins

    echo 'export NVM_DIR="/usr/local/nvm"' >> /home/jenkins/.bashrc
    echo '. $NVM_DIR/nvm.sh' >> /home/jenkins/.bashrc
    chown jenkins.jenkins /home/jenkins/.bashrc

    mkdir .ssh
    chmod 700 .ssh
    chown jenkins.jenkins .ssh
    cd .ssh
    cp /home/ubuntu/.ssh/authorized_keys .
    chmod 600 authorized_keys
    chown jenkins.jenkins authorized_keys
fi
