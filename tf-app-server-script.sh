#!/bin/bash
sudo yum -y update
sudo yum -y install httpd jq
sudo yum install amazon-linux-extras -y
sudo yum clean metadata
sudo amazon-linux-extras enable php7.4
sudo amazon-linux-extras install -y php7.4
sudo wget https://wordpress.org/latest.tar.gz
sudo tar xvzf latest.tar.gz -C /var/www/html
sudo chown -R apache:apache /var/www/html
sudo chkconfig httpd on
#sudo systemctl enable httpd
sudo systemctl restart httpd
wget https://raw.githubusercontent.com/mcrucovschii/SmallEnvironment/Development/wp-config.php -O /var/www/html/wordpress/wp-config.php
sudo chown apache:apache /var/www/html/wordpress/wp-config.php
dbhost=${dbhost}
#sudo sed -i 's/34.220.158.42/${dbhost}/' /var/www/html/wordpress/wp-config.php
sudo sed -i 's/34.220.158.42/'$dbhost'/' /var/www/html/wordpress/wp-config.php
wget https://raw.githubusercontent.com/mcrucovschii/SmallEnvironment/Development/htaccess-wordpress -O /var/www/html/wordpress/.htaccess
chown apache:apache /var/www/html/wordpress/.htaccess
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>WebServer with ip: $myip </h2><br>Small Environment build by Terraform" > /var/www/html/index.html
