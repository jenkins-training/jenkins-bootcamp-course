#!/bin/bash

CUR_USER=`whoami`
if [ "$CUR_USER" != "root" ]; then
  echo "Not root yet"
  exit 1
fi

if [ "" == "$1" ]; then
  echo "Please provide domain name:"
  echo "  restore-web.sh full.domain.name"
  exit 1
fi
DOMAIN=$1

cd /etc/nginx/sites-available
if [ -f web-secured.conf ]; then
  rm web-secured.conf
fi
if [ -f web.conf ]; then
  rm web.conf
fi
if [ -f webproxy.conf ]; then
  rm webproxy.conf
fi

wget https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/aws/lightsail/scale/web.conf
wget https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/aws/lightsail/scale/web-secured.conf
sed -i "s/DOMAIN_NAME/$DOMAIN/g" web-secured.conf

cd ../sites-enabled
if [ -e default ]; then
  rm default
fi
if [ -e web.conf ]; then
  rm web.conf
fi
if [ -e web-secured.conf ]; then
  rm web-secured.conf
fi
if [ -e webproxy.conf ]; then
  rm webproxy.conf
fi
ln -s ../sites-available/web-secured.conf web-secured.conf

nginx -t

systemctl restart nginx
