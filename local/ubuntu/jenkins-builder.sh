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
KOTLIN_VERSION="1.6.20"
GO_VERSION="1.18"
PACKER_VERSION="1.8.0"
TF_VERSION="1.1.7"

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

if [ "$OS_ARCH" == "aarch64" ]; then
    add-apt-repository "deb [arch=arm64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
else
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
fi
apt-get update -y
apt-get install -y docker-ce
apt-cache policy docker-ce
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
if [ ! -d apache-maven-$MVN_VERSION ]; then
    echo "Installing Maven $MVN_VERSION"
    wget https://dlcdn.apache.org/maven/maven-3/$MVN_VERSION/binaries/apache-maven-$MVN_VERSION-bin.tar.gz
    if [ -f apache-maven-$MVN_VERSION-bin.tar.gz ]; then
        echo "Installing Maven 3"
        tar -xvzf apache-maven-$MVN_VERSION-bin.tar.gz
        rm apache-maven-$MVN_VERSION-bin.tar.gz
        if [ -e maven ]; then
            rm maven
        fi
        ln -s apache-maven-$MVN_VERSION maven
        chown -R root.root apache-maven-$MVN_VERSION
        chmod 755 apache-maven-$MVN_VERSION
        if [ -e /usr/local/bin/mvn ]; then
            rm /usr/local/bin/mvn
        fi
        ln -s /usr/local/maven/bin/mvn /usr/local/bin/mvn
    else
        echo "Unable to find Maven installer"
    fi
fi

# Ant
if [ ! -d apache-ant-$ANT_VERSION ]; then
    echo "Installing Apache Ant $ANT_VERSION"
    wget https://dlcdn.apache.org/ant/binaries/apache-ant-$ANT_VERSION-bin.tar.gz
    if [ -f apache-ant-$ANT_VERSION-bin.tar.gz ]; then
        tar -xvzf apache-ant-$ANT_VERSION-bin.tar.gz
        rm apache-ant-$ANT_VERSION-bin.tar.gz
        chmod 755 apache-ant-$ANT_VERSION
        if [ -e ant ]; then
            rm ant
        fi
        ln -s apache-ant-$ANT_VERSION ant
        if [ -e /usr/local/bin/ant ]; then
            rm /usr/local/bin/ant
        fi
        ln -s /usr/local/ant/bin/ant /usr/local/bin/ant
    fi
fi

# Gradle
if [ ! -d gradle-$GRADLE_VERSION ]; then
    echo "Installing Gradle $GRADLE_VERSION"
    wget https://services.gradle.org/distributions/gradle-$GRADLE_VERSION-bin.zip
    if [ -f gradle-$GRADLE_VERSION-bin.zip ]; then
        unzip gradle-$GRADLE_VERSION-bin.zip
        rm gradle-$GRADLE_VERSION-bin.zip
        chmod 755 gradle-$GRADLE_VERSION
        if [ -e gradle ]; then
            rm gradle
        fi
        ln -s gradle-$GRADLE_VERSION gradle
        if [ -e /usr/local/bin/gradle ]; then
            rm /usr/local/bin/gradle
        fi
        ln -s /usr/local/gradle/bin/gradle /usr/local/bin/gradle
    fi
fi

# Groovy
if [ ! -d groovy-$GROOVY_VERION ]; then
    echo "Installing Groovy $GROOVY_VERION"
    wget https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-$GROOVY_VERION.zip
    if [ -f apache-groovy-binary-$GROOVY_VERION.zip ]; then
        unzip apache-groovy-binary-$GROOVY_VERION.zip
        rm apache-groovy-binary-$GROOVY_VERION.zip
        chmod 755 groovy-$GROOVY_VERION
        if [ -e groovy ]; then
            rm groovy
        fi
        ln -s groovy-$GROOVY_VERION groovy
        if [ -e /usr/local/bin/groovy ]; then
            rm /usr/local/bin/groovy
        fi
        ln -s /usr/local/groovy/bin/groovy /usr/local/bin/groovy
    fi
fi

# Scala tooling (Coursier)
if [ ! -e /usr/local/bin/cs ]; then
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
fi

# Kotlin
if [ ! -d kotlin-$KOTLIN_VERSION ]; then 
    wget https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN_VERSION/kotlin-compiler-$KOTLIN_VERSION.zip
    if [ -f kotlin-compiler-$KOTLIN_VERSION.zip ]; then
        unzip kotlin-compiler-$KOTLIN_VERSION.zip
        rm kotlin-compiler-$KOTLIN_VERSION.zip
        mv kotlinc kotlin-$KOTLIN_VERSION
        if [ -e kotlin ]; then
            rm kotlin
        fi
        ln -s kotlin-$KOTLIN_VERSION kotlin
        if [ -e /usr/local/bin/kotlin ]; then
            rm /usr/local/bin/kotlin
        fi
        ln -s /usr/local/kotlin/bin/kotlin /usr/local/bin/kotlin
        if [ -e /usr/local/bin/kotlinc ]; then
            rm /usr/local/bin/kotlinc
        fi
        ln -s /usr/local/kotlin/bin/kotlinc /usr/local/bin/kotlinc
        if [ -e /usr/local/bin/kotlin-compiler ]; then
            rm /usr/local/bin/kotlin-compiler
        fi
        ln -s /usr/local/kotlin/bin/kotlin-compiler /usr/local/bin/kotlin-compiler
    fi
fi

# Go Lang
if [ ! -d go-$GO_VERSION ]; then
    if [ "$OS_ARCH" == "aarch64" ]; then
        wget -O go$GO_VERSION.tar.gz https://dl.google.com/go/go$GO_VERSION.linux-arm64.tar.gz
    else
        wget -O go$GO_VERSION.tar.gz https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz
    fi

    if [ -e go ]; then
        rm go
    fi

    tar -xvzf go$GO_VERSION.tar.gz
    rm go$GO_VERSION.tar.gz
    mv go go-$GO_VERSION
    ln -s go-$GO_VERSION go

    if [ -e ]; then
        rm /usr/local/bin/go
    fi 
    ln -s /usr/local/go/bin/go /usr/local/bin/go
fi

# Packer
if [ ! -d packer-$PACKER_VERSION ]; then
    if [ "$OS_ARCH" == "aarch64" ]; then
        wget -O packer.zip https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_${PACKER_VERSION}_linux_arm64.zip
    else
        wget -O packer.zip https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_${PACKER_VERSION}_linux_amd64.zip
    fi

    if [ -e packer ]; then
        rm packer
    fi

    unzip packer.zip
    rm packer.zip
    mkdir packer-$PACKER_VERSION
    mv packer packer-$PACKER_VERSION
    chmod 755 packer-$PACKER_VERSION
    
    ln -s packer-$PACKER_VERSION packer
    if [ -e /usr/local/bin/packer ]; then
        rm /usr/local/bin/packer
    fi
    ln -s /usr/local/packer/packer /usr/local/bin/packer
fi

# Terraform
if [ ! -d terraform-$TF_VERSION ]; then
    if [ "$OS_ARCH" == "aarch64" ]; then
        wget -O terraform.zip https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_${TF_VERSION}_linux_arm64.zip
    else
        wget -O terraform.zip https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_${TF_VERSION}_linux_amd64.zip
    fi

    if [ -e terraform ]; then
        rm terraform
    fi

    unzip terraform.zip
    rm terraform.zip
    mkdir terraform-$TF_VERSION
    mv terraform terraform-$TF_VERSION
    chmod 755 terraform-$TF_VERSION
    
    ln -s terraform-$TF_VERSION terraform
    if [ -e /usr/local/bin/terraform ]; then
        rm /usr/local/bin/terraform
    fi
    ln -s /usr/local/terraform/terraform /usr/local/bin/terraform
fi

# AWS CLI v2
if [ ! -e /usr/local/bin/aws ]; then
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

    aws --version
fi

cd /usr/local
mkdir -p /usr/local/nvm
chmod 755 nvm
export NVM_DIR="/usr/local/nvm"
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
sleep 10
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo '\nexport NVM_DIR="/usr/local/nvm"' >> /root/.bashrc
    echo '. $NVM_DIR/nvm.sh' >> /root/.bashrc

    # Install LTS
    nvm install --lts=gallium
    nvm use --lts=gallium
    sleep 5
    nvm version
    node --version
    NODE_VERSION=`node --version`
    ln -s /usr/local/nvm/versions/node/$NODE_VERSION /usr/local/nodejs-$NODE_VERSION
    ln -s /usr/local/nvm/versions/node/$NODE_VERSION /usr/local/nodejs-lts
    npm install -g grunt-cli webpack webpack-cli gulp-cli less typescript @angular/cli cordova ionic

    # Install Latest
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
fi



# Setup Jenkins user
cd
if [ ! -d /var/lib/jenkins ]; then
    echo "Setup Jenkins user"
    if [ ! -d /home/jenkins ]; then
        adduser --disabled-password --gecos "" jenkins
        adduser jenkins sudo

        echo '\nexport NVM_DIR="/usr/local/nvm"' >> /home/jenkins/.bashrc
        echo '. $NVM_DIR/nvm.sh' >> /home/jenkins/.bashrc
        chown jenkins.jenkins /home/jenkins/.bashrc

        mkdir .ssh
        chmod 700 .ssh
        chown jenkins.jenkins .ssh
    fi
fi