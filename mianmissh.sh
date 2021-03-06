#!/bin/bash
SERVERS="172.20.134.172 172.20.134.173"
PASSWORD=123
BASE_SERVER=172.20.134.171
auto_ssh_copy_id() {
	expect -c "set timeout -1;
		spawn ssh-copy-id $1;
		expect {
			*(yes/no)* {send -- yes \r ;exp_continue;}
			*assword:* {send -- $2\r;exp_continue;}
			eof	   {exit 0;}
		}";

}
ssh_copy_id_to_all() {
	for SERVER in $SERVERS
	do
	   auto_ssh_copy_id $SERVER $PASSWORD
 	 
	done

}
ssh_copy_id_to_all
for SERVER in $SERVERS
do
	scp zkinstall.sh root@$SERVER:/root
	ssh root@$SERVER /root/zkinstall.sh
done
