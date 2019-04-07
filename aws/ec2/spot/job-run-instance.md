# Jenkins Job: Run EC2 Instance

This assumes the AWS CLI is available on the build node used.

## Job (Freestyle)

**Folder**: utilities
**Name**: ec2-instance-run

## Build Environment

### Delete Workspace

No changes

### Use Secret Text

Binding = AWS Creds (defaults ok)

### Inject Enviroment (Properties content)

Replace with your own values from AWS account, example from Instructor's account.

```
AMI_ID=ami-123a456b78
INST_TYPE=m5.xlarge
INST_COUNT=1
KEY_NAME=aws-jenkins-slave
SEC_GROUPS=sg-1a2b3c4d5e6
SUBNET_ID=subnet-123z987
AWS_DEFAULT_REGION=us-east-1
```

## Execute Shell

```bash
aws --version

echo "download user data script"
wget https://raw.githubusercontent.com/jenkins-training/jenkins-bootcamp-course/master/aws/ec2/spot/jenkins-slave-setup.sh

echo "Spin up EC2 Instance"
aws ec2 run-instances --image-id ${AMI_ID} --count ${INST_COUNT} --instance-type ${INST_TYPE} --key-name ${KEY_NAME} --security-group-ids ${SEC_GROUPS} --subnet-id ${SUBNET_ID} --user-data file://jenkins-slave-setup.sh
```
