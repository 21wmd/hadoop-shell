#!/bin/bash
if [ -n "$SSH_ASKPASS_PASSWORD" ]; then
    cat <<< "$SSH_ASKPASS_PASSWORD"
elif [ $# -lt 1 ]; then
    echo "Usage: echo password | $0 <ssh command line options>" >&2
    exit 1
else
    read SSH_ASKPASS_PASSWORD

    export SSH_ASKPASS=$0
    export SSH_ASKPASS_PASSWORD

    [ "$DISPLAY" ] || export DISPLAY=dummydisplay:0

    # use setsid to detach from tty
	exec setsid "$@"
fi
