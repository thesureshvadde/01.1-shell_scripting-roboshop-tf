#!/bin/bash
source common.sh
code_dir=$(pwd)
rm -rf ${logfile}

print_head "disabling mysql default version"
dnf module disable mysql -y &>> ${logfile}
status_check

print_head "coping mysql repo"
cp ${code_dir}/configuration/mysql.repo /etc/yum.repos.d/mysql.repo &>> ${logfile}
status_check

print_head "installing mysql community server"
dnf install mysql-community-server -y &>> ${logfile}
status_check

print_head "enabling mysql"
systemctl enable mysqld &>> ${logfile}
status_check

print_head "starting mysql"
systemctl start mysqld &>> ${logfile}
status_check

print_head "setting mysql root password"
mysql_secure_installation --set-root-pass RoboShop@1 &>> ${logfile}
status_check


#mysql -uroot -pRoboShop@1