#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with ip: $myip </h2><br>Small Environment build by Terraform" > /var/www/html/index.html
sudo service httpd start
sudo chkconfig httpd on
