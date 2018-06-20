#!/bin/bash
BASE_SERVER="172.20.134.171"
yum install -y wget
wget $BASE_SERVER/sort/zookeeper-3.4.5.tar.gz
mkdir /root/apps
tar -zxvf zookeeper-3.4.5.tar.gz -C /root/apps
cd /root/apps/zookeeper-3.4.5/conf
cp zoo_sample.cfg zoo.cfg
cat >> zoo.cfg  << EOF
server.1=172.20.134.171:2883:3888
server.2=172.20.134.172:2883:3888
server.3=172.20.134.173:2883:3888
EOF
source /etc/profile
/root/apps/zookeeper-3.4.5/bin/zkServer.sh start 
