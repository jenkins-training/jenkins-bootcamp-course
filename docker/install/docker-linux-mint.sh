#!/bin/bash

# curl https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/docker/install/docker-linux-mint.sh -o docker-setup.sh
# chmod +x docker-setup.sh
# sudo ./docker-setup.sh <username>

CUR_USER=`whoami`
if [ "${CUR_USER}" == "root" ]; then
  echo "Good, running as root"
else
  echo "Whoops! You are ${CUR_USER}, but root required. Please use sudo."
  exit 1
fi

DOCK_USER=$1
if [ "${DOCK_USER}" == "root" ]; then
  echo "The docker user cannot be root"
  exit 1
else
  echo "Using the user ${DOCK_USER} to be used with Docker"
fi

export DEBIAN_FRONTEND=noninteractive

# Update from OS install
apt-get update -y
apt-get -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' upgrade
apt-get autoremove -y
sleep 10

# Common utilities
apt-get install -y nano wget curl git zip unzip python3 python3-pip apt-transport-https ca-certificates curl software-properties-common

# # Docker (official)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
cd /etc/apt/sources.list.d
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" >> docker.list

cd

apt-get update -y
apt-get install -y docker-ce
docker --version

if [ "${DOCK_USER}X" == "X" ]; then
  echo "No docker user specified, skipping for now."
else
  usermod -aG docker ${DOCK_USER}
fi

systemctl enable docker

echo "Installing Docker Compose"
curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Installing Kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add
cd /etc/apt/sources.list.d
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >> kubernetes.list
apt-get update -y
apt-get install -y kubeadm kubectl

echo "Docker is installed"
echo "Add yourself to the docker group with:"
echo "  sudo usermod -aG docker <username>"
