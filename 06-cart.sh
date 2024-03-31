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

print_head "creating roboshop user"
userstatus &>> ${logfile}
status_check

print_head "creating /app directory"
appstatus -y &>> ${logfile}
status_check

print_head "downloading cart.zip code"
curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> ${logfile}
status_check

print_head "unzip cart.zip"
cd /app 
unzip /tmp/cart.zip &>> ${logfile}
status_check

print_head "installing dependincies"
npm install  &>> ${logfile}
status_check

print_head "coping cart.service file"
vim /etc/systemd/system/cart.service &>> ${logfile}
status_check

print_head "daemon-reload"
systemctl daemon-reload &>> ${logfile}
status_check

print_head "enabling cart"
systemctl enable cart &>> ${logfile}
status_check

print_head "starting cart"
systemctl start cart &>> ${logfile}
status_check