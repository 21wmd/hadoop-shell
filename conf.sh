#!/bin/bash
T_FOLDER=/tmp/hadoop
H_FOLDER=/etc/hadoop
export T_FOLDER

mv $T_FOLDER/hosts /etc/.
mv $T_FOLDER/{slaves,core-site.xml,hdfs-site.xml,mapred-site.xml,yarn-site.xml} $H_FOLDER/.

mkdir -p /usr/local/hadoop/{tmp,dfs,yarn}
mkdir -p /usr/local/hadoop/dfs/{name,data}
chown -R hdfs:hadoop /usr/local/hadoop/{tmp,dfs}
chown -R yarn:hadoop /usr/local/hadoop/yarn
/sbin/iptables -F

su hdfs << 'EOF'
cp $T_FOLDER/id_1 /home/hdfs/.ssh/authorized_keys
EOF
su yarn << 'EOF'
cp $T_FOLDER/id_2 /home/yarn/.ssh/authorized_keys
EOF
rm -rf $T_FOLDER
