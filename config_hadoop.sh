#!/bin/bash

SSH=/usr/bin/ssh
SCP=/usr/bin/scp
SH_PATH=/usr/bin
T_FOLDER=/tmp/hadoop
H_FOLDER=/etc/hadoop
WHIPTAIL=/usr/bin/whiptail
KEYGEN=/usr/bin/ssh-keygen
KEYSCAN=/usr/bin/ssh-keyscan
HOSTM=`hostname`
i=1
export i
export HOSTM
export T_FOLDER
export WHIPTAIL
export KEYGEN
export KEYSCAN

# Check run as root
if [[ $EUID -ne 0 ]]; then
	$WHIPTAIL --title "Config Hadoop" --msgbox "This script must be run as root! Hit OK to quit." 10 50
        exit 1
fi

rm -rf /home/hdfs/.ssh/
rm -rf /home/yarn/.ssh/
rm -rf ~/.ssh
$KEYGEN -f ~/.ssh/id_rsa -t rsa -q -N ''

STEP=ONE
source $SH_PATH/file.sh

ROLE=Master
CHOO=IP
i=""
source $SH_PATH/input_para.sh

STEP=TWO
source $SH_PATH/file.sh

CHOO=NUM
source $SH_PATH/input_para.sh

STEP=THREE
source $SH_PATH/file.sh

i=1
while [ "$i" -le "$SLAVE_NUM" ]; do
	source $SH_PATH/check.sh

	HN[$i]=$HOSTNAME
	ADDR[$i]=$IP
	USE[$i]=$R_USER
	PW1_[$i]=$PASSWD
	PW2_[$i]=$PASSWD_ROOT

	echo "${HN[$i]}" >> $T_FOLDER/slaves
	echo "${ADDR[$i]}	${HN[$i]}" >> $T_FOLDER/hosts
	i=$(($i+1))
done

STEP=FOUR
source $SH_PATH/file.sh

STEP=FIVE
i=1
while [ "$i" -le "$SLAVE_NUM" ]; do
	echo "${PW1_[$i]}" | ./sshaskpass.sh $SCP $T_FOLDER/* ${USE[$i]}@${ADDR[$i]}:/tmp/hadoop/.
	echo "${PW1_[$i]}" | ./sshaskpass.sh $SSH -o NumberOfPasswordPrompts=1 ${USE[$i]}@${ADDR[$i]} "auth.sh \"${PW1_[$i]}\" \"${PW2_[$i]}\"" > /dev/null 2>&1
	S_HOSTM=`cat /tmp/hadoop/slaves | sed -n $i'p'`
	export S_HOSTM
	source $SH_PATH/file.sh
	i=$(($i+1))
done

STEP=SIX
source $SH_PATH/file.sh

exit 0
