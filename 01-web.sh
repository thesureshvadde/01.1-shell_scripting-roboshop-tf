#!/bin/bash
source common.sh
code_dir=$(pwd)
rm -rf ${logfile}

print_head "installing nginx"
dnf install nginx -y &>> ${logfile}
status_check

print_head "enabling nginx"
systemctl enable nginx &>> ${logfile}
status_check

print_head "starting nginx"
systemctl start nginx &>> ${logfile}
status_check 

print_head "removing nginx default content"
rm -rf /usr/share/nginx/html/* &>> ${logfile}
status_check

print_head "downloading web content"
curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> ${logfile}
status_check

print_head "changing directory to /usr/share/nginx/html"
cd /usr/share/nginx/html &>> ${logfile}
status_check

print_head "unzip web.zip"
unzip /tmp/web.zip &>> ${logfile}
status_check

print_head "copy roboshop.conf"
cp ${code_dir}/configuration/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>> ${logfile}
status_check

print_head "restarting Nginx"
systemctl restart nginx &>> ${logfile}
status_check