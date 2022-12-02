#!/bin/bash
mail="" #insert your mail
logfile="/tmp/certrenew.log"
service="" #leave empty to autoselect service from port 80/443
if [[ $(whoami) != "root" ]]
then
        exit 13
fi
if [[ -z $service ]]
then
        service=($(netstat -lptun | tr -s " " | grep -E "\:(80|443)" | cut -f7 -d" " | cut -f2 -d "/"| head -n2 | sed 's/ /\n/g'))
        if [[ ! -z ${service[0]} && ${service[0]} == ${service[1]} ]]
        then
                service=${service[1]}
        fi
fi
if [[ -f $logfile ]]
then
        echo "" > $logfile
else
        touch $logfile
fi
print_tolog () {
        echo $@ >> $logfile
}
print_tolog "Cert renew started at " $(date)
command_output=$(systemctl stop ${service})
if [[ $? -eq 0  && -z $(netstat -lptun | grep ${service}) ]]
then
        print_tolog " [OK] ${service^} stopped"
        command_output=$(certbot renew)
        if [[ $? -ne 0 ]]
        then
                print_tolog " [ERROR] Certs could not be renewed, printing error"
                print_tolog $command_output
                error=1
        else
                print_tolog " [OK] Certs renewed"
        fi
        command_output=$(systemctl start ${service})
        if [[ $? -eq 0 ]]
        then
                print_tolog " [OK] ${service^} started correctly"
        else
                print_tolog "[Error] ${service^} could not be started, printing error"
                print_tolog $command_output
                error=1
        fi
else
        print_tolog "[Error] ${service^} could not be stopped, printing error"
        print_tolog $command_output
        error=1
fi
print_tolog "Cert renew ended at " $(date)
cat $logfile | mail -s "Certbot renew" $mail #If you want to recieve a mail only if the process failed move this line two lines down
if [[ $error -ne 0 ]]
then
        exit $error
fi
exit 0
