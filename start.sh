#!/bin/bash
exec >/var/log/unattended.log 2>&1

# update hostname
h=$(vmware-rpctool "info-get guestinfo.hostname")
hostnamectl set-hostname $h
echo -e "127.0.0.1\t$h" >> /etc/hosts

# update repos
apt-get -y update
#apt-get -y upgrade
#apt-get -y dist-upgrade
#apt-get -y autoremove
#apt-get -y purge

echo "%sudo ALL=NOPASSWD: ALL" >> /etc/sudoers

echo " DONE; rebooting ... "
reboot
