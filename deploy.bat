@echo off

set STACK_NAME=Tomcat
set REGION=us-east-1
set CLI_PROFILE=default
set TEMPLATE=ubuntu.yml 

aws cloudformation deploy ^
    --region %REGION% ^
    --profile %CLI_PROFILE% ^
    --stack-name %STACK_NAME% ^
    --template-file %TEMPLATE% 
