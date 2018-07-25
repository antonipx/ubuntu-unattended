#!/bin/bash
set -e

# set defaults
default_hostname="$(hostname)"
default_domain="netson.local"
default_puppetmaster="foreman.netson.nl"
tmp="/root/"

clear

# check for root privilege
if [ "$(id -u)" != "0" ]; then
   echo " this script must be run as root" 1>&2
   echo
   exit 1
fi

# determine ubuntu version
ubuntu_version=$(lsb_release -cs)


# print status message
echo " preparing your server; this may take a few minutes ..."

# set fqdn
fqdn="$hostname.$domain"

# update hostname
echo "$hostname" > /etc/hostname
sed -i "s@ubuntu.ubuntu@$fqdn@g" /etc/hosts
sed -i "s@ubuntu@$hostname@g" /etc/hosts
hostname "$hostname"

# update repos
apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove
apt-get -y purge

# as stuff
apt -y install openssh-server
systemctl enable openssh-server
systemctl start openssh-server
curl -s https://raw.githubusercontent.com/antonipx/cloud/master/run/ubuntu-run.sh | bash

# remove myself to prevent any unintended changes at a later stage
rm $0

# finish
echo " DONE; rebooting ... "

# reboot
reboot
