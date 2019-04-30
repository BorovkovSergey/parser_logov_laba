#!/bin/bash
grep -o '^<[0-9]\{1,2\}' log.txt | sort | uniq > uniq_source
echo "Количество разных источников сообщений: " `grep -c '<[0-9]\{1,2\}' uniq_source`
if [[ $1 && $1 = 'show_all' ]] ;then
    echo "Перечень разных источников сообщений:: " `cat uniq_source`
fi
echo  

grep -o '%ASA-[0-9]\{1,1\}-[0-9]\{6,6\}' log.txt | sort | uniq > uniq_messages
echo "Количество разных типов сообщений от Cisco ASA, встречающихся в дампе: " `grep -c '%ASA-[0-9]\{0,1\}-[0-9]\{1,6\}' uniq_messages`
if [[ $1 && $1 = 'show_all' ]] ;then
    echo "Перечень разных типов сообщений от Cisco ASA, встречающихся в дампе: " `cat uniq_messages | grep -o '[0-9]\{6,6\}'`
    echo "Прочитать про каждый тип сообщений можно по ссылке: https://www.cisco.com/c/en/us/td/docs/security/asa/syslog/b_syslog/syslogs1.html"
fi
echo

grep "ASA" log.txt > uniq_adreses
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,999\}' uniq_adreses | sort | uniq > uniq_adreses2 
LEGAL_IPS_COUNT=`grep -c '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' uniq_adreses2`
UNLEGAL_IPS_3=`grep -c '[3-9]\{1,1\}[0-9]\{2,2\}' uniq_adreses2`
UNLEGAL_IPS_3v2=`grep -c '\([2]\{1,1\}[6-9]\{1,1\}[0-9]\{1,9\}\|[2]\{1,1\}[5]\{1,1\}[6-9]\{1,9\}\)' uniq_adreses2`
grep '[3-9]\{1,1\}[0-9]\{2,2\}' uniq_adreses2 > uniq_adreses4
grep '\([2]\{1,1\}[6-9]\{1,1\}[0-9]\{1,1\}\|[2]\{1,1\}[5]\{1,1\}[6-9]\{1,1\}\)' uniq_adreses2 > uniq_adreses5
echo "Количество различных IP-адресов, встретившихся в сообщениях Cisco ASA: " $((${LEGAL_IPS_COUNT}-${UNLEGAL_IPS_3}-${UNLEGAL_IPS_3v2}))
if [[ $1 && $1 = 'show_all' ]] ;then
    echo "Перечень различных IP-адресов, встретившихся в сообщениях Cisco ASA: " `cat uniq_adreses2 | sort`
fi

echo "Количество различных невалидных IP-адресов, встретившихся в сообщениях Cisco ASA: " $(($UNLEGAL_IPS_3+${UNLEGAL_IPS_3v2}))
if [[ $1 && $1 = 'show_all' ]] ;then
    echo "Перечень различных невалидных IP-адресов, встретившихся в сообщениях Cisco ASA: " `cat uniq_adreses5 | sort` `cat uniq_adreses4 | sort`
fi
