#!/bin/bash

CUR_USER=`whoami`
if [ "$CUR_USER" != "root" ]; then
  echo "Not root yet"
  exit 1
fi

if [ "" == "$1" ]; then
  echo "Please provide domain name:"
  echo "  secure-web.sh full.domain.name email@domain.name"
  exit 1
fi
DOMAIN=$1

if [ "" == "$2" ]; then
  echo "Please provide email address:"
  echo "  secure-web.sh full.domain.name email@domain.name"
  exit 1
fi
EMAIL=$2

certbot certonly --webroot -w /var/www/jenkins/ --agree-tos -m $EMAIL --rsa-key-size 4096 -n -d $DOMAIN
sleep 15

cd /etc/nginx/sites-available
if [ -f web-secured.conf ]; then
  rm web-secured.conf
fi
wget https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/aws/lightsail/scale/web-secured.conf
sed -i "s/DOMAIN_NAME/$DOMAIN/g" web-secured.conf

cd ../sites-enabled
if [ -e web-secured.conf ]; then
  rm web-secured.conf
fi
ln -s ../sites-available/web-secured.conf web-secured.conf

nginx -t

systemctl restart nginx
