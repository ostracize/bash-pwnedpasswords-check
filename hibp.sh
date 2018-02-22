#!/bin/bash
read -p "What password do you want to check? " PASS
echo "Checking:" $PASS

HASH=`echo -n ${PASS} | /usr/bin/shasum | awk '{print $1}'`
PREFIX=`echo -n ${HASH} | cut -c1-5`
SUFFIX=`echo -n ${HASH} | cut -c6-99`

RESULT=`curl -s -o - https://api.pwnedpasswords.com/range/${PREFIX} | grep -i ${SUFFIX}`

if [ $? != 0  ]; then
    echo "Password not found"
else
    COUNT=`echo ${RESULT} | awk -F: '{print $2}'`
    echo "Password count: ${COUNT}"
fi;
