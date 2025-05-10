#!/bin/bash

terminate_ping_loop=0
test_ssh_connection=0

readonly sname=$(basename $0) # this script's name
readonly sdir=$(dirname $0) # this script's directory

command -v ifconfig >/dev/null 2>&1 || { echo "ifconfig is missing.  Aborting." >&2; exit 1; }
command -v sshpass >/dev/null 2>&1 || { echo "sshpass is missing.  Aborting." >&2; exit 1; }

readonly username=root
readonly password=root
readonly remote=11.0.0.2

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
	echo "** Trapped CTRL-C"
	terminate_ping_loop=1
	test_ssh_connection=1
}

clear

readonly qemu=${sdir}/../output/host/bin/qemu-system-x86_64

${qemu} \
	--m 1G \
	--smp 4 \
	--cpu host \
	--enable-kvm \
	--netdev tap,id=mynet0,ifname=tap0,script=${sdir}/ifup.sh,downscript=no \
	--device e1000,netdev=mynet0,mac=52:55:00:d1:55:01 \
	--kernel ${sdir}/../output/images/bzImage \
	--append "quiet net.ifnames=0" \
	--nographic \
	> /dev/null \
	&

qemu_id=$!
sleep 1

printf "trying to connect to qemu \n"
printf "press ctrl-c to terminate \n"
printf "\n"

echo -n "waiting for ping reply"
while ! [ 0 -ne ${terminate_ping_loop} ]
do
	timeout 2 ping -c1 ${remote} > /dev/null
	rval=$?

	if [ 0 -eq $rval ]; then
		printf "\ngot reply from qemu \n"
		break
	else
		printf "."
	fi
done

echo -n "waiting for ssh connection"

while ! [ 0 -ne ${test_ssh_connection} ]
do
	sshpass -p ${password} ssh \
		-o StrictHostKeyChecking=no \
		-o PasswordAuthentication=yes \
		-o UserKnownHostsFile=/dev/null \
		-o LogLevel=ERROR \
		${username}@${remote} exit 0 >& /dev/null

	if [ $? -eq 0 ]; then
		printf "\nssh connection is good \n"
		break
	fi

	sleep 1
	echo -n "."
done

sshpass -p ${password} ssh \
		-o StrictHostKeyChecking=no \
		-o PasswordAuthentication=yes \
		-o UserKnownHostsFile=/dev/null \
		-o LogLevel=ERROR \
		${username}@${remote}

echo "ssh terminated. killing qemu as well"
kill $qemu_id
