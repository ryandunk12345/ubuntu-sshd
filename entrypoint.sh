#!/bin/bash
mkdir -p /root/.ssh
touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

cat /etc/ssh/sshd_config

/usr/sbin/sshd -D
