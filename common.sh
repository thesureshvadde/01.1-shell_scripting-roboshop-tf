logfile=/tmp/roboshop.log

print_head() {
    echo -e "\e[36m $1 \e[0m"
}

status_check() {
    if [ $? -eq 0 ]
    then
        echo -e "\e[32m success \e[0m"
    else
        echo -e "\e[31m failure \e[0m"
        exit 1
    fi
}

userstatus(){
    id roboshop &>> ${logfile}
    if [ $? -eq 0 ]
    then
        echo -e "\e[32m user already exist \e[0m"
    else
        useradd roboshop &>> ${logfile}   
        status_check
    fi
}

appstatus(){
    cd /app &>> ${logfile}
    if [ $? -eq 0 ]
    then
        echo -e "\e[32m /app already exist \e[0m" 
    else
        mkdir /app &>> ${logfile}
    fi
}
