#!/bin/bash
DIR=$1
if [ "$(ls -A ${DIR})" ]; then
echo "${DIR} is not Empty"
else
echo "${DIR} is Empty"
echo "cp -R ${DIR}_/* ${DIR}"
cp -R ${DIR}_/* ${DIR}
echo "Address=${CodeMeter_Server}" >> /etc/wibu/CodeMeter/Server.ini
fi
