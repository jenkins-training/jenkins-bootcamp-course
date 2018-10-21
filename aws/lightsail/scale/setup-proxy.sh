#!/bin/bash

CUR_USER=`whoami`
if [ "$CUR_USER" != "root" ]; then
  echo "Not root yet"
  exit 1
fi

if [ "" == "$1" ]; then
  echo "Please provide domain name:"
  echo "  setup-proxy.sh full.domain.name Private.IP.Address"
  exit 1
fi
DOMAIN=$1

if [ "" == "$2" ]; then
  echo "Please provide Private IP address to Jenkins master"
  echo "  setup-proxy.sh full.domain.name Private.IP.Address"
  exit 1
fi
IPADDR=$2

cd /etc/nginx/sites-available
if [ -f webproxy.conf ]; then
  rm webproxy.conf
fi
wget https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/aws/lightsail/scale/webproxy.conf
sed -i "s/DOMAIN_NAME/$DOMAIN/g" webproxy.conf
sed -i "s/JENKINS_IP/$IPADDR/g" webproxy.conf

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
ln -s ../sites-available/webproxy.conf webproxy.conf

nginx -t

systemctl restart nginx
