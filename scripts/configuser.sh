#!/bin/sh
echo "Creating user $1"

adduser -u $3 -h /home/$1 -D -s /bin/false $1 
adduser $1 ftpaccess

chown -R root:root /home/$1
chmod 755 /home/$1

mkdir -p /home/$1/in
mkdir -p /home/$1/out



chown -R $1:$1 /home/$1/in
chmod 755 /home/$1/in

chown -R root:ftpaccess /home/$1/out
chmod 755 /home/$1/in

mkdir -p /home/$1/.ssh
echo "$2" > /home/$1/.ssh/authorized_keys

chown -R $1:$1 /home/$1/.ssh
chmod 700 /home/$1/.ssh
chmod 600 /home/$1/.ssh/authorized_keys

echo "$1 hard nproc $4" >> /etc/security/limits.conf

echo "User created"