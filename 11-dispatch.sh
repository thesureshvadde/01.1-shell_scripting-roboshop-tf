#!/bin/bash
source common.sh
code_dir=$(pwd)
rm -rf ${logfile}

print_head "installing golang"
dnf install golang -y &>> ${logfile}
status_check

print_head "creating roboshop user"
userstatus &>> ${logfile}
status_check

print_head "creating /app directory"
appstatus -y &>> ${logfile}
status_check


print_head "downloading dispatch.zip code"
curl -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip &>> ${logfile}
status_check

print_head "unzip dispatch.zip"
cd /app 
unzip /tmp/dispatch.zip &>> ${logfile}
status_check

print_head "installing dependincies"
go mod init dispatch &>> ${logfile}
status_check
go get &>> ${logfile}
status_check
go build &>> ${logfile}
status_check

print_head "coping dispatch service file"
cp ${code_dir}/configuration/dispatch.service /etc/systemd/system/dispatch.service &>> ${logfile}
status_check

print_head "daemon reload"
systemctl daemon-reload &>> ${logfile}
status_check

print_head "enabling dispatch"
systemctl enable dispatch &>> ${logfile}
status_check

print_head "styarting dispatch"
systemctl start dispatch &>> ${logfile}
status_check