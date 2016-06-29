#!/bin/bash
PASSWD=$1
PASS_ROOT=$2
SUDO=/usr/bin/sudo

/bin/echo "$PASSWD" | $SUDO -S ls > /dev/null 2>&1
statu=`echo $?`

if [[ $statu -eq 127 ]] || [[ $statu -eq 1 ]]; then
        (sleep 1; echo "$PASS_ROOT") | python -c "import pty; pty.spawn(['/bin/su','-c','/usr/bin/conf.sh']);"
                exit 0
fi

if [ $statu -eq 0 ]; then
        /bin/echo "$PASSWD" | $SUDO -S /usr/bin/conf.sh 
fi
exit 0
