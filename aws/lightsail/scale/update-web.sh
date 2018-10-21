#!/bin/bash

CUR_USER=`whoami`
if [ "$CUR_USER" != "root" ]; then
  echo "Not root yet"
  exit 1
fi

cd /etc/nginx/sites-available
wget https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/aws/lightsail/scale/web-secured.conf

cd ../sites-enabled
ln -s ../sites-available/web-secured.conf web-secured.conf

nginx -t

systemctl restart nginx
