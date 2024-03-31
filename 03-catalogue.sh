#!/bin/bash
source common.sh
code_dir=$(pwd)
rm -rf ${logfile}

print_head "disabling nodejs default version"
dnf module disable nodejs -y &>> ${logfile}
status_check

print_head "enabling nodejs:18 version"
dnf module enable nodejs:18 -y &>> ${logfile}
status_check

print_head "installing nodejs"
dnf install nodejs -y &>> ${logfile}
status_check

print_head "creating roboshop user"
userstatus -y &>> ${logfile}
status_check

print_head "creating /app directory"
appstatus -y &>> ${logfile}
status_check

print_head "diownloading catalogue.zip code"
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> ${logfile}
status_check

print_head "unzip catalogue.zip"
cd /app 
unzip /tmp/catalogue.zip &>> ${logfile}
status_check

print_head "installing dependinces"
npm install  &>> ${logfile}
status_check

print_head "coping cvatalogue.service file"
cp ${code_dir}/configuration/catalogue.service /etc/systemd/system/catalogue.service &>> ${logfile}
status_check

print_head "daemon-reload-->Restarting all running services"
systemctl daemon-reload &>> ${logfile}
status_check

print_head "enabling catalogue"
systemctl enable catalogue &>> ${logfile}
status_check

print_head "starting catalogue"
systemctl start catalogue &>> ${logfile}
status_check

print_head "coping mongo.repo file"
cp ${code_dir}/configuration/mongo.repo /etc/yum.repos.d/mongo.repo &>> ${logfile}
status_check

print_head "installing mongodb"
dnf install mongodb-org-shell -y &>> ${logfile}
status_check

print_head "loading schema"
mongo --host mongodb.sureshvadde.online < /app/schema/catalogue.js &>> ${logfile}
status_check