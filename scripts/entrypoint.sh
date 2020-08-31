#!/bin/sh
mkdir -p /home
chown root:root /home
chmod 755 /home

# Converte o JSON para um CSV
cat $1/users.json  | jq '.users[] | [.username, .pubkey, .uid, .maxconnections * 2] | @csv'  |  sed -e 's/\\\"/\"/gi'  | sed -e 's/\"//gi' > $1/user_config.csv
while IFS=, read -r col1 col2 col3 col4
do 
    $1/configuser.sh "$col1" "$col2" "$col3" "$col4"
done  < $1/user_config.csv
echo "configuring NFT"
/app/nftables_config.sh
echo "starting sshd"
sshguard & /usr/sbin/sshd -D -E /app/sshd.log   