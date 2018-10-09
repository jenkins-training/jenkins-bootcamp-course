#!/bin/bash

systemctl stop nginx

cd /etc/nginx/conf.d
if [ -f lightsail-jenkins.conf ]; then
  rm lightsail-jenkins.conf
fi

cd /etc/nginx/sites-available
wget https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/aws/lightsail/jenkins-secured.conf

