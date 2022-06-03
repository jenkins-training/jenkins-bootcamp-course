# Jenkins Installation

## Purpose

This guide will help setup a Jenkins server quickly on Ubuntu Server 20.04 LTS.

## Requirements

* Ubuntu 20.04 LTS (tested with server) - x86/amd64 or Arm64
* Networking working

## Included

The following items will be installed/setup:

* Basic tools like zip, nano, git
* OpenJDK 11 (headless)
* Jenkins (server)
* Nginx
    * Add reverse proxy config to point to Jenkins server

## Jenkins Server Setup

Run (copy and paste) the following command(s) in the Terminal in your Ubuntu server.

### Jenkins Server (combined)

Jenkins server and build components within same system:

```bash
wget -qO - https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/main/local/ubuntu/jenkins-combined.sh | sudo bash
```

### Jenkins Server (only)

Jenkins server only:

```bash
wget -qO - https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/main/local/ubuntu/jenkins-server.sh | sudo bash
```

### Jenkins Build Compontents

Jenkins build node components:

```bash
wget -qO - https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/main/local/ubuntu/jenkins-builder.sh | sudo bash -s maven
```

### Common

For those that want to save time between refreshes, this script installs the common components like Java, Python, and Git - along with updating the system packages. This is a good option to save a snapshot after running this script.

```bash
wget -qO - https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/main/local/ubuntu/common.sh | sudo bash
```


### Mac M1 using Multipass

```bash
# download class repo
cd ~
mkdir projects
cd projects
git clone git@github.com:jenkins-training/jenkins-bootcamp-course.git
cd jenkins-bootcamp-course

# multipass.run
brew install multipass
multipass version           # version info
multipass help              # help info
multipass find              # list available images
multipass launch jammy --name jenkins --cloud-init local/ubuntu/common.yaml
multipass shell jenkins

# within instance, see if cloud init completed
cat /var/log/cloud-init-output.log

# install Java
sudo apt-get install -y openjdk-11-jre-headless openjdk-11-jdk-headless

# get the jenkins key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

cd /etc/apt/sources.list.d
sudo nano jenkins.list

# contents of jenkins.list
deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/
# save and close file

sudo apt-get update
sudo apt-get install -y jenkins

# run specific setup script as needed





exit                        # exit instance shell
multipass info jenkins      # instance info - copy IPv4 address
nano /etc/hosts             # Add entry: <IPv4>  jenkins.local

# Navigate browser to http://jenkins.local/
multipass exec jenkins -- sudo cat /var/lib/jenkins/secrets/initialAdminPassword
# Copy and paste password token into password field to unlock Jenkins
```
