#!/bin/bash
source common.sh
code_dir=$(pwd)
rm -rf ${logfile}


print_head "installing erlang repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>> ${logfile}
status_check

print_head "installing rabbitmq-server repo"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>> ${logfile}
status_check

print_head "installing rabbitmq-server"
dnf install rabbitmq-server -y  &>> ${logfile}
status_check

print_head "enabling rabbitmq-server"
systemctl enable rabbitmq-server  &>> ${logfile}
status_check

print_head "starting rabbitmq-server"
systemctl start rabbitmq-server  &>> ${logfile}
status_check

print_head "adding rabbitmq user"
rabbitmqctl add_user roboshop roboshop123 &>> ${logfile}
status_check

print_head "setting permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> ${logfile}
status_check