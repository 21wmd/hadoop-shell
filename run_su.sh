#!/bin/bash
# Check run as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root!"
	exit 1
fi

# Create ssh key file
su hdfs << 'EOF'
/usr/bin/ssh-keygen -f /home/hdfs/.ssh/id_rsa -t rsa -q -N ''
EOF

su yarn << 'EOF'
/usr/bin/ssh-keygen -f /home/yarn/.ssh/id_rsa -t rsa -q -N ''
EOF
