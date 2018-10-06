# AWS Setup for Jenkins

## SSH Keys

```bash
cd
# only if needed
mkdir .ssh
cd .ssh

# generate ssh key, replace email with your own
ssh-keygen -t rsa -b 4096 -C "you@example.com" -f aws-jenkins.key
```
