#!/bin/bash

# Make sure NVM is loaded
. $NVM_DIR/nvm.sh

echo "Validate tools installed using package manager"
which git docker nano zip unzip curl wget
docker --version
aws --version
git version
nano --version
zip --version
unzip --version
curl --version
wget --version

echo "Validate languages installed using the Package Manager"
which python3 pip3 ruby gem bundler java
python3 --version
pip3 --version
ruby --version
gem --version
bundler --version
java -version

echo "Validate stuff installed from tarballs and zip archives"
which mvn ant gradle groovy sbt scala kotlin go packer terraform sass
mvn -version
ant -version
gradle -version
groovy -version
scala -version
kotlin -version
go version
packer version
terraform version
sass --version

echo "Validate NVM and nodejs"
nvm ls
which node npm grunt gulp webpack tsc less cordova ionic ng
nvm which lts/argon
nvm which lts/boron
nvm which lts/carbon
nvm which stable
nvm which current
node --version
npm --version
grunt --version
gulp --version
webpack --version
tsc --version
less --version
cordova telemetry off
cordova --version
ionic --version
ng --version
