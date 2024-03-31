#!/bin/bash
source common.sh
code_dir=$(pwd)
rm -rf ${logfile}

print_head "disabling nodejs default version"
dnf module disable nodejs -y &>> ${logfile}
status_check

print_head "enabling nodejs:18"
dnf module enable nodejs:18 -y &>> ${logfile}
status_check

print_head "installing nodejs"
dnf install nodejs -y &>> ${logfile}
status_check

print_head "creating roboshop user -->application user"
userstatus &>> ${logfile}
status_check

print_head "creating /app directory -->application directory"
appstatus -y &>> ${logfile}
status_check

print_head "downloading user.zip code"
curl -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> ${logfile}
status_check

print_head "unzip user.zip"
cd /app 
unzip /tmp/user.zip &>> ${logfile}
status_check

print_head "installing dependincies"
npm install  &>> ${logfile}
status_check

print_head "coping user.service"
cp ${code_dir}/configuration/user.service /etc/systemd/system/user.service &>> ${logfile}
status_check

print_head "daemon-reload"
systemctl daemon-reload &>> ${logfile}
status_check

print_head "enabling user"
systemctl enable user &>> ${logfile}
status_check

print_head "start user"
systemctl start user &>> ${logfile}
status_check

print_head "coping mongodb repo"
cp ${code_dir}/configuration/mongo.repo /etc/yum.repos.d/mongo.repo &>> ${logfile}
status_check

print_head "installing mongodb"
dnf install mongodb-org-shell -y &>> ${logfile}
status_check

print_head "loading schema"
mongo --host mongodb.sureshvadde.online < /app/schema/user.js &>> ${logfile}
status_check