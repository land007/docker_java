#!/bin/bash
nohup /analytics.sh > /dev/null 2>&1 &
/usr/sbin/sshd
/check.sh /java
