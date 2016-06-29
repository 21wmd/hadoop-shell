#!/bin/bash
if [ "$CHOO" = "NUM" ]
then
	SLAVE_NUM=""
	while [[ "$SLAVE_NUM" -lt 3 || ! -n "$SLAVE_NUM" ]]; do
		SLAVE_NUM=$($WHIPTAIL --title "Config Hadoop" --inputbox "Please input the total number of slave nodes." 10 50 3>&1 1>&2 2>&3)
		echo "$SLAVE_NUM" | egrep "^[0-9]*$" > /dev/null 2>&1
		COUNT=$?
		if [[ ! -n "$SLAVE_NUM" || "$COUNT" -eq 1 ]]; then
			$WHIPTAIL --title "Config Hadoop" --msgbox "Invalid input! Please input a number." 10 50
			SLAVE_NUM=""
		fi
		if [ "$SLAVE_NUM" -lt 3 ]; then
			$WHIPTAIL --title "Config Hadoop" --msgbox "Slave Number must > 2!" 10 50
		fi
	done
elif [ "$CHOO" = "IP" ]
then
	CONN=2
	while [ "$CONN" -ne 0 ]; do
		if [ "$CONN" -eq 1 ]; then
			$WHIPTAIL --title "Config Hadoop" --msgbox "IP address wrong! Hit OK to continue." 10 50
		fi	
		IP=$($WHIPTAIL --title "Config Hadoop" --inputbox "Please input IP address of $ROLE $i" 10 50 3>&1 1>&2 2>&3)
		while [ ! -n "$IP" ]; do
			$WHIPTAIL --title "Config Hadoop" --msgbox "Empty IP address is not allowed. Hit OK to continue." 10 50
			IP=$($WHIPTAIL --title "Config Hadoop" --inputbox "Please input IP address of $ROLE $i" 10 50 3>&1 1>&2 2>&3)
		done
	nc -zw3 $IP 22 > /dev/null 2>&1
	CONN=`echo $?`
	done
	export IP
elif [ "$CHOO" = "USER" ]
then
	R_USER=""
	while [ ! -n "$R_USER" ]; do
		R_USER=$($WHIPTAIL --title "Config Hadoop" --inputbox "Please input user name of Slave $i:" 10 50 3>&1 1>&2 2>&3)
		if [ ! -n "$R_USER" ]; then
			$WHIPTAIL --title "Config Hadoop" --msgbox "Empty user name is not allowed!" 10 50
		fi
	done
elif [ "$CHOO" = "U_PASS" ]
then
	PASSWD=""
	while [ ! -n "$PASSWD" ]; do
		PASSWD=$($WHIPTAIL --title "Config Hadoop" --passwordbox "Please input password for user $R_USER:" 10 50 3>&1 1>&2 2>&3)
		if [ ! -n "$PASSWD" ]; then
			$WHIPTAIL --title "Config Hadoop" --msgbox "Empty password for user $R_USER is not allowed!" 10 50
		fi
	done
elif [ "$CHOO" = "R_PASS" ]
then
	PASSWD_ROOT=""	
	while [ ! -n "$PASSWD_ROOT" ]; do
		PASSWD_ROOT=$($WHIPTAIL --title "Config Hadoop" --passwordbox "Please input root password for Slave $i" 10 50 3>&1 1>&2 2>&3)
		if [ ! -n "$PASSWD_ROOT" ]; then
			$WHIPTAIL --title "Config Hadoop" --msgbox "Empty password for root is not allowed!" 10 50
		fi
	done
else
	exit 0
fi
