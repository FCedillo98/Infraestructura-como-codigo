#!/bin/bash

STACK_NAME=Tomcat
REGION=us-east-1
CLI_PROFILE=default
TEMPLATE=ubuntu.yml 

aws cloudformation deploy \
	--region $REGION \
	--profile $CLI_PROFILE \
	--stack-name $STACK_NAME \
	--template-file $TEMPLATE

if [ $? -eq 0 ]; then
    aws cloudformation list-exports \
		--query "Exports[?Name=='IpPublico'].Value"
fi