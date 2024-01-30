@echo off

set STACK_NAME=Tomcat
set REGION=us-east-1

aws cloudformation delete-stack ^
    --stack-name %STACK_NAME% ^
    --region %REGION% 