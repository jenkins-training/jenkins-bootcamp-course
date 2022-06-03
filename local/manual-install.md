# Jenkins Server

Manual installation using Multipass on Windows, Mac or Linux.

Supported Platforms:

* Mac (with Homebrew) - x86 or M1 64-bit
* Windows x86 64-bit
* Linux x86 64-bit

Goal:

* Install Jenkins LTS on Ubuntu 22.04 LTS

## Setup

Multiplass needs to be installed.

### Mac Installation of Multipass

Use `brew` to install Multipass:

```bash
# install
brew install multipass

# confirm installation
which multipass
multipass version
```

### Create VM

Download common tools cloud-init config:

```bash
curl -o setup.yaml https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/main/local/ubuntu/common.yaml
```

Launch new VM instance (Ubuntu 22.04 LTS):

```bash
multipass launch jammy --name jenkins --cloud-init setup.yaml
```

The cloud init just provides a handful of common tools like Git, zip, and Python and will do a package update.

Once the process has completed, you can query the cloud init output to ensure it is complete:

```bash
multipass exec jenkins -- sudo cat /var/log/cloud-init-output.log
```

Now, login to the jenkins instance:

```bash
multipass shell jenkins
```

### Java Installation

Once inside the new Jenkins VM, install Java:

```bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get install -y openjdk-11-jre-headless openjdk-11-jdk-headless
```

### Jenkins Server Installation

Import the Jenkins package key:

```bash
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
```

Create a Jenkins repository for Apt:

```bash
cd /etc/apt/sources.list.d
sudo nano jenkins.list
```

Contents of the `jenkins.list` file:

```
deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/
```

Content should be all on one line. Save and close the file, which will return us to the prompt.

Now, install Jenkins using Apt:

```bash
sudo apt-get update
sudo apt-get install -y jenkins
```

Once the installation is complete, you can exit the instance:

```bash
exit
```

### DNS Entry for Jenkins

You should be back to the host system. Now, we need to get the IPv4 address of the Jenkins instance:

```bash
multipass info jenkins
```

Find the "IPv4" field and copy the IP address.

Use sudo/admin rights to open your host system's hosts file:

```bash
# Mac
sudo nano /etc/hosts
```

Update or add the line:

```
<paste-IPv4-address>  jenkins.local jenkins
```

Save and close the file.

### Jenkins Setup Wizard

While still in the terminal, grab the initial password token for the Jenkins setup wizard (next):

```bash
multipass exec jenkins -- sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Copy the token.

Now, open a web browser and go to: `http://jenkins.local:8080/`

Walk through setup wizard.

### Nginx Reverse Proxy

Go back into the Jenkins instance:

```bash
multipass shell jenkins
```

Install Nginx web server:

```bash
sudo apt-get install -y nginx
```

Remove the default site:

```bash
sudo rm /etc/nginx/sites-enabled/default
```

Download Jenkins reverse proxy config:

```bash
cd /etc/nginx/conf.d
sudo wget -O jenkins-server-proxy.conf https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/main/local/ubuntu/nginx-jenkins.conf
```

Now, restart Nginx:

```bash
sudo systemctl restart nginx
sudo systemctl enable nginx
```

Should be safe to exits Jenkins VM:

```bash
exit
```

### Configure Jenkins for Proxy

Return to web browser and remove the ":8080" from the address.

URL: http://jenkins.local/

Now, go to Manage Jenkins > Configure System

Find the "Jenkins URL" field - remove the ":8080" from the address.

Save.

