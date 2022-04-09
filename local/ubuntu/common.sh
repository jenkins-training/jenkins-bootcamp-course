#!/bin/bash

if [ -f /etc/os-release ]; then
    source /etc/os-release
else
    echo "Not Ubuntu - bailing"
    exit 1
fi

# Update from OS install
apt-get update -y
apt-get upgrade -y
sleep 5

# Common utilities
apt-get install -y nano wget zip unzip curl git python3 python3-pip build-essentials

python3 --version
pip3 --version
git --version

# Install Java 11
apt-get install -y openjdk-11-jre-headless openjdk-11-jdk-headless

java -version

export SETUP_COMMON="done"