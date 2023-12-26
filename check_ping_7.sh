#!/bin/bash
#mail="vikas.singh@skilrock.com"

for i in `cat ping6`
do
 ping -c  5 $i  >>/dev/null
    if [ $? -eq 0 ]
then
     echo ""
else
  echo  " $i is Down Please check  ASAP  " | mutt  -s " $i is down " vikas.singh@skilrock.com
fi
done
