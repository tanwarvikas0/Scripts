#!/bin/bash
user_name=ctr_support
password=ctr_support321
ALERT=80
MAIL="vikas.singh@skilrock.com"
for server in `cat testdiskspace` 
do
  df -H | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5 " "$6 }'  | while read -r output;
 ssh   $user_name@$server
do
echo "$output" 
  space=$(echo "$output" | awk '{ print $1}' | cut -d'%' -f1 )
  partition=$(echo "$output" | awk '{ print $2 }' )
if [ $space  -ge $ALERT ]; then
    echo " Disk space is  \"$partition ($space%)\" on $(hostname -I) as on $(date)" |
    mutt -s "Warning :  disk space is  $space%"  vikas.singh@skilrock.com
fi
done
done
