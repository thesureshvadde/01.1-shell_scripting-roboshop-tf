#!/bin/bash
source common.sh
code_dir=$(pwd)
rm -rf ${logfile}

print_head "installing maven-->java"
dnf install maven -y &>> ${logfile}
status_check

print_head "creating roboshop user"
userstatus &>> ${logfile}
status_check

print_head "creating /app directory"
appstatus -y &>> ${logfile}
status_check

print_head "downloading shipping.zip code"
curl -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> ${logfile}
status_check

print_head "unzip shipping.zip"
cd /app 
unzip /tmp/shipping.zip &>> ${logfile}
status_check

print_head "installing dependincies"
mvn clean package &>> ${logfile}
status_check
mv target/shipping-1.0.jar shipping.jar &>> ${logfile}
status_check

print_head "coping shipping service file"
cp ${code_dir}/configuration/shipping.service /etc/systemd/system/shipping.service &>> ${logfile}
status_check

print_head "daemon-reload"
systemctl daemon-reload &>> ${logfile}
status_check

print_head "enabling shipping"
systemctl enable shipping &>> ${logfile}
status_check

print_head "starting shipping"
systemctl start shipping &>> ${logfile}
status_check

print_head "installing mysql"
dnf install mysql -y &>> ${logfile}
status_check

print_head "loading schema"
mysql -h mysql.sureshvadde.online -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>> ${logfile}
status_check

print_head "restarting shipping"
systemctl restart shipping &>> ${logfile}
status_check