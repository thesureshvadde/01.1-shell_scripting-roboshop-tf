#!/bin/bash
source common.sh
code_dir=$(pwd)
rm -rf ${logfile}


print_head "installing python3-devel"
dnf install python36 gcc python3-devel -y &>> ${logfile}
status_check

print_head "creating roboshop user"
userstatus &>> ${logfile}
status_check

print_head "creating /app directory"
appstatus -y &>> ${logfile}
status_check

print_head "downloading payment.zip code"
curl -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>> ${logfile}
status_check

print_head "unzip payment.zip"
cd /app 
unzip /tmp/payment.zip &>> ${logfile}
status_check

print_head "installing dependincies"
pip3.6 install -r requirements.txt &>> ${logfile}
status_check

print_head "copying payment service file"
cp ${code_dir}/configuration/payment.service /etc/systemd/system/payment.service &>> ${logfile}
status_check

print_head "daemon reload"
systemctl daemon-reload &>> ${logfile}
status_check

print_head "enabling payment"
systemctl enable payment &>> ${logfile}
status_check

print_head "starting payment"
systemctl start payment &>> ${logfile}
status_check