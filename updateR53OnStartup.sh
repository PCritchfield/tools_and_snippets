#!/bin/bash

if ! [ "$(command -v aws)" ]; then
        echo "Package, awscli, not installed. Installing"
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        unzip awscliv2.zip
        sudo ./aws/install -b /usr/bin
else
	echo "Package, awscli, is installed"
fi

# Extract information about the Instance
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id/)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/)
MY_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4/)

echo $INSTANCE_ID
echo $AZ
echo $MY_IP

# Extract tags associated with instance
ZONE_TAG=$(aws ec2 describe-tags --profile updateR53 --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`R53_HOSTED_ZONE`].Value' --output text)
NAME_TAG=$(aws ec2 describe-tags --profile updateR53 --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`R53_DNS_NAME`].Value' --output text)
ENV_TAG=$(aws ec2 describe-tags --profile updateR53 --region ${AZ::-1} --filters "Name=resource-id,Values=${INSTANCE_ID}" --query 'Tags[?Key==`environment`].Value' --output text)

echo $ZONE_TAG
echo $NAME_TAG
echo $ENV_TAG

# Update Route 53 Record Set based on the Name tag to the current Public IP address of the Instance
#if [[ "$ENV_TAG" == "development" && -n "$ENV_TAG" ]]; then
#  echo "updating"
#  aws route53 change-resource-record-sets --profile updateR53 --hosted-zone-id $ZONE_TAG --change-batch '{"Changes":[{"Action":"UPSERT","ResourceRecordSet":{"Name":"'$NAME_TAG'","Type":"A","TTL":300,"ResourceRecords":[{"Value":"'$MY_IP'"}]}}]}'
#fi

