#!/bin/bash

#Script to configure cleint
#to set host name as a client

hostnamectl set-hostname client

#to Disable firewall

systemctl stop firewalld.service

systemctl disable firewalld.service

#To disable Selinux
cd /etc/selinux/config

setenforce 0

sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

#To add the host file details
echo "add master and client hosts and ip details press ctrl+d to save"
while xyz= read -r line;
do
 user_input+="$line"$'\n'

done

echo "$user_input" >> /etc/hosts

#To install repos
yum install http://build.openhpc.community/OpenHPC:/1.3/CentOS_7/x86_64/ohpc-release-1.3-1.el7.x86_64.rpm -y

#To install utilities

yum -y install yum-utils -y

#To install repos

wget -P /etc/yum.repos.d https://xcat.org/files/xcat/repos/yum/latest/xcat-core/xcat-core.repo -y

#To install nagios plugins

yum install nagios-plugins-all-ohpc nrpe-ohpc -y

cd /etc/nagios/

ipp=`cat /etc/hosts | grep master | awk '{ print $1 }'`

sed -i 's/allowed_hosts.*/allowed_hosts\=127\.0\.0\.1\,'"$ipp"'/g' /etc/nagios/nrpe.cfg

systemctl start nrpe

systemctl enable nrpe

systemctl status nrpe

mkdir /var/log/nagios
chown -R nrpe:nrpe /var/log/nagios

systemctl restart nrpe

systemctl enable nrpe
