#!/bin/bash

ROLE=Slave
CHOO=IP
source $SH_PATH/input_para.sh

CHOO=USER
source $SH_PATH/input_para.sh

$KEYSCAN -t rsa $IP >> ~/.ssh/known_hosts 2>&1

statu=3
while [ $statu -ne 0 ]; do
	if [ $statu -ne 2 ]; then
		if [[ $statu -eq 255 || $statu -eq 127 ]]; then
			if [ $statu -eq 127 ]; then
				if ($WHIPTAIL --title "Config Hadoop" --yesno "Slave $i does not have hadoop configured. Click Yes to quit or No to re-enter the user name." 10 50) then
					exit 0 
				else
					statu=255
				fi
			fi
			$WHIPTAIL --title "Config Hadoop" --msgbox "User name or password error! Hit OK to continue." 10 50
			CHOO=USER
			source $SH_PATH/input_para.sh
		fi
			CHOO=U_PASS
			source $SH_PATH/input_para.sh
		PASSWD_ROOT=""
	fi
	if [ $statu -eq 2 ]; then 
		if [ ! -n "$PASSWD_ROOT" ]; then
			PASSWD_ROOT=""
		else
			$WHIPTAIL --title "Config Hadoop" --msgbox "Root password error! Hit OK to continue." 10 50
		fi
		CHOO=R_PASS
		source $SH_PATH/input_para.sh
	fi
	echo "$PASSWD" | ./sshaskpass.sh $SSH -o NumberOfPasswordPrompts=1 $R_USER@$IP "test.sh \"$PASSWD\" \"$PASSWD_ROOT\"" > /dev/null 2>&1 
	statu=`echo $?`
done
echo "$PASSWD" | ./sshaskpass.sh $SCP /home/hdfs/.ssh/id_rsa.pub $R_USER@$IP:/tmp/hadoop/id_1 
echo "$PASSWD" | ./sshaskpass.sh $SCP /home/yarn/.ssh/id_rsa.pub $R_USER@$IP:/tmp/hadoop/id_2
HOSTNAME=`echo "$PASSWD" | ./sshaskpass.sh $SSH -o NumberOfPasswordPrompts=1 $R_USER@$IP "hostname"`

export HOSTNAME
export IP
export R_USER
export PASSWD
export PASSWD_ROOT

