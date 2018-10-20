#!/bin/bash

# Update from OS install
apt-get update -y

# Common utilities
apt-get install -y nano zip unzip wget curl nginx

cd /etc/nginx/sites-available
wget https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/aws/lightsail/jenkins-secured.conf

# remove default symlink
cd /etc/nginx/sites-enabled
rm default
ln -s ../sites-available/jenkins-secured.conf jenkins.conf

cd
nginx -t

systemctl restart nginx
systemctl enable nginx

apt-get update -y
apt-get install -y software-properties-common
add-apt-repository ppa:certbot/certbot -y
apt-get update -y
apt-get install -y python-certbot-nginx

# Once complete, run command as root:
# certbot certonly --webroot -w /var/www/jenkins/ -d build.jenkins.training
