#!/bin/bash
sudo rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum-config-manager --enable mysql80-community
sudo yum -y update
sudo yum --enablerepo=mysql80-community install mysql-community-server -y
echo "Start sql" >> /tmp/max.log
sudo service mysqld start
sudo mysql_secure_installation
sudo service mysqld restart
sudo chkconfig mysqld on
temp=`sudo grep "A temporary password" /var/log/mysqld.log | awk '{print $13}'`
