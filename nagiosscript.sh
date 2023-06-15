#!/bin/bash

#script to install nagios on Master Node and configuring one client
#To set host name as a master

hostnamectl set-hostname master

#to Disable firewall

systemctl stop firewalld.service

systemctl disable firewalld.service

#To disable Selinux
cd /etc/selinux

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

#To install Nagios with Openhpc

yum install ohpc-nagios -y

#Now to start the nagios service

systemctl start nagios

#To enable the nagios

systemctl enable nagios

#To see the staus

systemctl status nagios

#To start http

systemctl start httpd

#To see the status of http

systemctl status httpd

#Now set the password to login Nagios

htpasswd -bc /etc/nagios/passwd nagiosadmin nagiosadmin

#Now go to the conf.d

cd /etc/nagios/conf.d

#To copy the original file into the other file for editing

cp hosts.cfg.example hosts.cfg

#To overwrite the host file

sed -i '30,$d' hosts.cfg
sed -i 's/members\ HOSTNAME1\,HOSTNAME2\,HOSTNAME3\,HOSTNAME4/members\ client/g' hosts.cfg
sed -i 's/host_name\ HOSTNAME1/host_name\ client/g' hosts.cfg
ipp=`cat /etc/hosts | grep client | awk '{ print $1 }'`
sed -i 's/address\ HOST1_IP/address\ '"$ipp"'/g' hosts.cfg

#to edit the ownership for hosts.cfg and services.cfg

chown -R nagios. /etc/nagios/conf.d/hosts.cfg

#to copy the services file

cp services.cfg.example services.cfg

chown -R nagios. /etc/nagios/conf.d/services.cfg

#restart the nagios services

systemctl restart nagios
