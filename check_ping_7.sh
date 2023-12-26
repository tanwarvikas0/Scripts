#!/bin/bash
#mail="vikas.singh@skilrock.com"  # Add your mail id 

for i in `cat ping6` # Here the server list are in the ping 6 file
do
 ping -c  5 $i  >>/dev/null
    if [ $? -eq 0 ]
then
     echo ""
else
  echo  " $i is Down Please check  ASAP  " | mutt  -s " $i is down " vikas.singh@skilrock.com
fi
done
