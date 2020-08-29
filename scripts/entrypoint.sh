#!/bin/sh
# Converte o JSON para um CSV
cat $1/users.json  | jq '.users[] | [.username, .pubkey, .uid] | @csv'  |  sed -e 's/\\\"/\"/gi'  | sed -e 's/\"//gi' > $1/user_config.csv
while IFS=, read -r col1 col2
do 
    $1/configuser.sh "$col1" "$col2"
done  < $1/user_config.csv
echo "starting sshd"
/usr/sbin/sshd -D  -E /app/sshd.log