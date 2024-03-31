#!/bin/bash
source common.sh
code_dir=$(pwd)
rm -rf ${logfile}

print_head "installing redis repo"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> ${logfile}
status_check

print_head "enabling redis:remi-6.2"
dnf module enable redis:remi-6.2 -y &>> ${logfile}
status_check

print_head "installing redis"
dnf install redis -y &>> ${logfile}
status_check

print_head "updating redis listening address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf  &>> ${logfile} #127.0.0.1 to 0.0.0.0
status_check

print_head "enabling redis"
systemctl enable redis &>> ${logfile}
status_check

print_head "starting redis"
systemctl start redis &>> ${logfile}
status_check