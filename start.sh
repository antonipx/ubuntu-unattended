#!/bin/bash
#set -e

# update hostname
hostname=$(vmware-rpctool "info-get guestinfo.hostname")
hostnamectl set-hostname $hostname
sed -i "s@ubuntu.ubuntu@$fqdn@g" /etc/hosts
sed -i "s@ubuntu@$hostname@g" /etc/hosts

# update repos
apt-get -y update
#apt-get -y upgrade
#apt-get -y dist-upgrade
#apt-get -y autoremove
#apt-get -y purge

# as stuff
apt -yq install jq htop atop iotop iftop iperf3 dstat
apt -yq install openssh-server
mkdir /home/ubuntu/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCQniDpP1+M1N0mUn8Eeg8cAlqK84TjXhe4BF5kD+XNa5iunGT7s8+PPhLb47pDQTPX+s1vhx5BuCysDDUQPeB43hAuUkDYH3OFWOSzYuaNzqpal3mjdz9bNf8Pjb+cIp0CQ2Q/iuDGjtYcHepuVbeD1DWhSGxG0WL8UPqzahLBl5gjPmjG8OUqxBv87PY9BrUsIA7eokCGwpANsA6z1DX+k0sPGfa2k6ZEEhnZf3jwI64Zx87girx+i/2yWfgXzi4ungkO6ufyGe0UfDvIs7M9r7hAoiM+G7OHnOEIKs+Z2JR74o2VKRHp3Smb+76b4anC7gyPopQq5vzDbaxz2wDT askey" >> /home/ubuntu/.ssh/authorized_keys
chmod 600 /home/ubuntu/.ssh/authorized_keys
chown -R ubuntu /home/ubuntu
cd /usr/local/bin; curl https://getmic.ro | bash
curl -s https://get.docker.com/ | bash
swapoff -a
sed -i -e '/swap/d' /etc/fstab
chmod -x /etc/update-motd.d/*
echo "%sudo ALL=NOPASSWD: ALL" >> /etc/sudoers

chmod 0 $0

echo " DONE; rebooting ... "

reboot
