#!/bin/bash
PASSWD=$1
PASS_ROOT=$2
SUDO=/usr/bin/sudo

rm -rf /tmp/hadoop
mkdir /tmp/hadoop
rm -rf /tmp/result_su
/bin/echo "$PASSWD" | $SUDO -S ls > /dev/null 2>&1
statu=`echo $?`
echo "$statu" > /home/test/statu

if [[ $statu -eq 127 ]] || [[ $statu -eq 1 ]]; then
        (sleep 1; echo "$PASS_ROOT") | python -c "import pty; pty.spawn(['/bin/su','-c','/sbin/ifconfig']);" > /tmp/result_su
	SU_STATU_NUM=`cat /tmp/result_su | wc -l`
        if [ $SU_STATU_NUM -le 4 ]; then
                exit 2
        else
        (sleep 1; echo "$PASS_ROOT") | python -c "import pty; pty.spawn(['/bin/su','-c','/usr/bin/run_su.sh']);"
                exit 0
        fi
fi

if [ $statu -eq 0 ]; then
        /bin/echo "$PASSWD" | $SUDO -S /usr/bin/run_su.sh 
fi

exit 0
