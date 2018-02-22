#!/bin/bash
read -p "What password do you want to check? " PASS
echo "Checking:" $PASS

# Split the SHA1 hash of the password
HASH=`echo -n ${PASS} | /usr/bin/shasum | awk '{print $1}'`
PREFIX=`echo -n ${HASH} | cut -c1-5`
SUFFIX=`echo -n ${HASH} | cut -c6-99`

# https://haveibeenpwned.com/API/v2#SearchingPwnedPasswordsByRange
RESULT=`curl -s -o - https://api.pwnedpasswords.com/range/${PREFIX} | grep -i ${SUFFIX}`

if [ $? != 0  ]; then
    echo "Password not found"
else
    COUNT=`echo ${RESULT} | awk -F: '{print $2}'`
    echo "Password count: ${COUNT}"
fi;
