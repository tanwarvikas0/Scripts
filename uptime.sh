#!/bin/bash
> uptime_info.txt
user_name='ctr_support'
password='ctr_support321'
read -p "Please Enter the file name:" List
diskspace() 
{
        sshpass -p $password ssh -o stricthostkeychecking=no $user_name@$ip<< EOF
	uptime
	#df -Ph
EOF
}
cat $List | while read ip
do
	echo "Uptime information for "$ip >> uptime_info.txt
      # diskspace | sed s/%//g | awk '{ if($5 > 80) print $0;}' >> uptime_info.txt
        diskspace >> uptime_info.txt
	if [ $? -gt 0 ]; then
		echo "Not able to ssh "$ip >> uptime_info.txt
	fi
done


