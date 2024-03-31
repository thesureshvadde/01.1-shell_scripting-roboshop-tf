#!/bin/bash
source common.sh
code_dir=$(pwd)
rm -rf ${logfile}

print_head "coping mongo.repo"
cp ${code_dir}/configuration/mongo.repo /etc/yum.repos.d/mongo.repo  &>> ${logfile}
status_check

print_head "installing mongodb"
dnf install mongodb-org -y  &>> ${logfile}
status_check

print_head "enabling mongodb"
systemctl enable mongod &>> ${logfile}
status_check

print_head "sytarting mongodb"
systemctl start mongod &>> ${logfile}
status_check

print_head "updating mongodb listening address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>> ${logfile}
status_check

print_head "restarting mongodb"
systemctl restart mongod &>> ${logfile}
status_check