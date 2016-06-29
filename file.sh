#!/bin/bash

if [ "$STEP" = "ONE" ]
then

#core-site.xml
rm -rf $T_FOLDER
mkdir $T_FOLDER 
cat >> $T_FOLDER/core-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
<property>
    <name>fs.defaultFS</name>
    <value>hdfs://$HOSTM:9000</value>
</property>
<property>
    <name>hadoop.tmp.dir</name>
    <value>file:/usr/local/hadoop/tmp</value>
</property>
</configuration>
EOF

#hdfs-site.xml
cat >> $T_FOLDER/hdfs-site.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
<property>
    <name>dfs.namenode.secondary.http-address</name>
    <value>$HOSTM:50090</value>
</property>
<property>
    <name>dfs.namenode.name.dir</name>
    <value>file:/usr/local/hadoop/dfs/name</value>
</property>
<property>
    <name>dfs.datanode.data.dir</name>
    <value>file:/usr/local/hadoop/dfs/data</value>
</property>
<property>
    <name>dfs.replication</name>
    <value>3</value>
</property>
</configuration>
EOF

#mapred-site.xml
cat >> $T_FOLDER/mapred-site.xml << EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->

<!-- Put site-specific property overrides in this file. -->

<configuration>
<property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
</property>
</configuration>
EOF

#yarn-site.xml
cat >> $T_FOLDER/yarn-site.xml << EOF
<?xml version="1.0"?>
<!--
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License. See accompanying LICENSE file.
-->
<configuration>
<property>
    <name>yarn.resourcemanager.hostname</name>
    <value>$HOSTM</value>
</property>
<property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
</property>
<property>
    <name>yarn.nodemanager.local-dirs</name>
    <value>file:/usr/local/hadoop/yarn</value>
</property>
</configuration>
EOF

elif [ "$STEP" = "TWO" ]
then

cat >> $T_FOLDER/hosts << EOF
$IP	$HOSTM
EOF

elif [ "$STEP" = "THREE" ]
then

# Create user ssh key file
su hdfs <<-EOF
$KEYGEN -f /home/hdfs/.ssh/id_rsa -t rsa -q -N ''
cat /home/hdfs/.ssh/id_rsa.pub > /home/hdfs/.ssh/authorized_keys
$KEYSCAN -t rsa $HOSTM >> ~/.ssh/known_hosts 2>&1
EOF

su yarn <<-EOF
$KEYGEN -f /home/yarn/.ssh/id_rsa -t rsa -q -N ''
cat /home/yarn/.ssh/id_rsa.pub > /home/yarn/.ssh/authorized_keys
$KEYSCAN -t rsa $HOSTM >> ~/.ssh/known_hosts 2>&1
EOF

elif [ "$STEP" = "FOUR" ]
then

cat >> $T_FOLDER/hosts <<-EOF

::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF
cp $T_FOLDER/hosts /etc/.

elif [ "$STEP" = "FIVE" ]
then

su hdfs <<-EOF
$KEYSCAN -t rsa $S_HOSTM >> ~/.ssh/known_hosts 2>&1
EOF

su yarn <<-EOF
$KEYSCAN -t rsa $S_HOSTM >> ~/.ssh/known_hosts 2>&1
EOF

elif [ "$STEP" = "SIX" ]
then

mv $T_FOLDER/hosts /etc/.
mv $T_FOLDER/slaves $H_FOLDER/.
mv $T_FOLDER/core-site.xml $H_FOLDER/.
mv $T_FOLDER/hdfs-site.xml $H_FOLDER/.
mv $T_FOLDER/mapred-site.xml $H_FOLDER/.
mv $T_FOLDER/yarn-site.xml $H_FOLDER/.
mkdir -p /usr/local/hadoop/{tmp,dfs,yarn}
mkdir -p /usr/local/hadoop/dfs/{name,data}
chown -R hdfs:hadoop /usr/local/hadoop/{tmp,dfs}
chown -R yarn:hadoop /usr/local/hadoop/yarn
/sbin/iptables -F

else
	exit 0
fi
