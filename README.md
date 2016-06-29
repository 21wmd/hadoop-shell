# hadoop-shell

hadoop-shell 能够自动实现SSH无密码登录、清空 Iptables 规则、部署 Hadoop 最基本的
配置文件。


1、首先安装 Hadoop 和其依赖
sudo apt-get install openssh-server openjdk-8-jdk hadoop -y

2、将 hadoop-shell 中所有文件拷贝至 /usr/bin/ 目录中，然后运行 sudo /usr/bin/config_hadoop.sh。

3、启动 Hadoop

手册运行时需要在Master节点执行初始化命令，使用hdfs用户执行
hdfs namenode -format

Master节点使用hdfs用户启动HDFS
/usr/sbin/start-dfs.sh

Master节点使用yarn用户启动YARN
/usr/sbin/start-yarn.sh
