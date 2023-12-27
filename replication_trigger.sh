#!/bin/bash
ip=`hostname -I|awk '{print $1}'`
binfile="MYSQL "
uname=""
pwd=""
cmd=`$binfile -u$uname -p$pwd  -e "show slave status\G;"`
if [[ $? -gt 0 ]]; then
        echo "Not able to connect with MYSQL slave node "$ip |mail -s "Ithuba | Mysql Connection Failed on $ip for Replication Check" ##add email address
exit
fi
sbh=`echo "$cmd" |  grep Seconds_Behind_Master|head -n 1|awk '{print $2}'`
echo "current="$sbh >> /home/ctr_support/replicationCheck/data.txt
prev=`grep prev /home/ctr_support/replicationCheck/data.txt | gawk -F'=' '{print $2}'`
current=`grep current /home/ctr_support/replicationCheck/data.txt | gawk -F'=' '{print $2}'`
if [[ $? -eq 0 ]]; then
        > /home/ctr_support/replicationCheck/repl_monitor.txt
        echo '' >> /home/ctr_support/replicationCheck/repl_monitor.txt
        echo "Replication Detail of SlaveNode $ip" >> /home/ctr_support/replicationCheck/repl_monitor.txt
        echo '' >> /home/ctr_support/replicationCheck/repl_monitor.txt
        echo `echo "$cmd" |  grep Master_Host` >> /home/ctr_support/replicationCheck/repl_monitor.txt
        echo `echo "$cmd" |  grep Master_Log_File | head -n 1` >> /home/ctr_support/replicationCheck/repl_monitor.txt
        echo `echo "$cmd" |  grep Slave_IO_Running` >> /home/ctr_support/replicationCheck/repl_monitor.txt
        echo `echo "$cmd" |  grep Slave_SQL_Running|head -n 1` >> /home/ctr_support/replicationCheck/repl_monitor.txt
        echo `echo "$cmd" |  grep Read_Master_Log_Pos` >> /home/ctr_support/replicationCheck/repl_monitor.txt
        echo `echo "$cmd" |  grep Exec_Master_Log_Pos` >> /home/ctr_support/replicationCheck/repl_monitor.txt
        echo `echo "$cmd" |  grep Seconds_Behind_Master` >> /home/ctr_support/replicationCheck/repl_monitor.txt
        echo `echo "$cmd" |  grep Last_IO_Error` >> /home/ctr_support/replicationCheck/repl_monitor.txt
        echo `echo "$cmd" |  grep Last_SQL_Error` >> /home/ctr_support/replicationCheck/repl_monitor.txt
        var=`cat /home/ctr_support/replicationCheck/repl_monitor.txt`
        slaveio=`echo "$cmd"|grep Slave_IO_Running|head -n 1|awk '{print $2}'`
        slavesql=`echo "$cmd"|grep Slave_SQL_Running|head -n 1|awk '{print $2}'`
        if [[ $slaveio == 'No' || $slavesql == 'No' ]]; then
                echo "$var"|mail -s "Mysql Replication for $ip is reporting Error"  ##add your email
        #sbh=`echo "$cmd" |  grep Seconds_Behind_Master|head -n 1|awk '{print $2}'
        elif [[ $sbh -gt 600 || $sbh == 'NULL' ]]; then
                echo "prev="$sbh > /home/ctr_support/replicationCheck/data.txt
                echo "$var"|mail -s "Mysql Replication Reporting Delay for $ip"  ##add your email
        elif [[ $prev -gt '200'  &&  $current == '0' ]]; then
                echo "$var"|mail -s "Resolved : Ithuba | Mysql Replication Reporting Delay for $ip"  ##email 
        else
                >/home/ctr_support/replicationCheck/data.txt
                echo "prev="$current > /home/ctr_support/replicationCheck/data.txt
                exit
        fi
fi
