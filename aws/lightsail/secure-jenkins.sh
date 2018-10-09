#!/bin/bash

systemctl stop nginx

cd /var/www
mkdir jenkins

cd /etc/nginx/conf.d
if [ -f lightsail-jenkins.conf ]; then
  rm lightsail-jenkins.conf
fi

cd /etc/nginx/sites-available
wget https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/aws/lightsail/jenkins-secured.conf

cd ../sites-enabled
ln -s ../sites-available/jenkins-secured.conf jenkins.conf

cd
nginx -t

systemctl start nginx

apt-get update -y
apt-get install -y software-properties-common
add-apt-repository ppa:certbot/certbot -y
apt-get update -y
apt-get install -y python-certbot-nginx

# Once complete, run command as root:
# certbot certonly --webroot -w /var/www/jenkins/ -d build.jenkins.training
