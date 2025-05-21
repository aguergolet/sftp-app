#!/bin/sh
mkdir -p /home
chown root:root /home
chmod 755 /home

# Process users directly from JSON
jq -r '.users[] | "\(.username) \(.pubkey) \(.uid) \(.maxconnections * 2)"' $1/users.json |
while IFS=' ' read -r username pubkey uid maxconnections_doubled; do
    $1/configuser.sh "$username" "$pubkey" "$uid" "$maxconnections_doubled"
done

echo "configuring NFT"
/app/nftables_config.sh
echo "starting sshd"
sshguard & /usr/sbin/sshd -D -E /app/sshd.log   