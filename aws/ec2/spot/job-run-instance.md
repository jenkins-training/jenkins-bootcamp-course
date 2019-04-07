# Jenkins Job: Run EC2 Instance

This assumes the AWS CLI is available on the build node used.

## Build Environment

### Delete Workspace

No changes

### Use Secret Text

Binding = AWS Creds (defaults ok)

### Inject Enviroment (Propertie content)

```
AMI_ID="ami-0a313d6098716f372"
INST_TYPE="t2.medium"
INST_COUNT=1
KEY_NAME="aws-jenkins-slave"
SG_IDS="sg-0a41ea8a45a49e748"
SUBNET="subnet-650f804b"
```

## Execute Shell

```bash
aws --version

echo "download user data script"
wget https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/aws/ec2/spot/jenkins-slave-setup.sh

echo "Spin up EC2 Instance"
aws ec2 run-instances --region us-east-1 --image-id ${AMI_ID} --count ${INST_COUNT} --instance-type ${INST_TYPE} --key-name ${KEY_NAME} --security-group-ids ${SG_IDS} --subnet-id ${SUBNET} --user-data file://jenkins-slave-setup.sh
```
