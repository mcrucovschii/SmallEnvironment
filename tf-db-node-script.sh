#!/bin/bash
sudo rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo yum-config-manager --enable mysql80-community
sudo yum -y update
sudo yum --enablerepo=mysql80-community install mysql-community-server -y
sudo service mysqld start
#sudo mysql_secure_installation
sudo chkconfig mysqld on
temppass=`sudo grep "A temporary password" /var/log/mysqld.log | awk '{print $13}'`
#sudo echo #temppass > /root/.my.cnf
echo $temppass > /tmp/max.log
sudo `sudo grep "A temporary password" /var/log/mysqld.log | awk '{print $13}'` > /root/.my.cnf
mysql --connect-expired-password -u root -p"$temppass" -e "ALTER USER root@localhost IDENTIFIED BY 'ak^SMg4g9p5'; flush privileges;"
mysql -u root -p"ak^SMg4g9p5" -e "CREATE USER 'wordpress'@'%' IDENTIFIED BY 'ak^SMg4g9p5';"
mysql -u root -p"ak^SMg4g9p5" -e "CREATE DATABASE wordpress;"
mysql -u root -p"ak^SMg4g9p5" -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'%';"
mysql -u root -p"ak^SMg4g9p5" -e "flush privileges;"
