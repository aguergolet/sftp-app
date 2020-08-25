#!/bin/sh
# Converte o JSON para um CSV
cat $1/users.json  | jq '.users[] | [.uid, .pubkey] | @csv'  |  sed -e 's/\\\"/\"/gi'  | sed -e 's/\"//gi' > $1/user_config.csv
while IFS=, read -r col1 col2
do 
    $1/configuser.sh "$col1" "$col2"
done  < $1/user_config.csv
/usr/sbin/sshd -D 