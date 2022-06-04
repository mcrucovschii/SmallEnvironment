#!/bin/bash
sudo yum -y update
sudo yum -y install httpd jq
sudo yum install amazon-linux-extras -y
sudo yum clean metadata
sudo amazon-linux-extras enable php7.4
sudo amazon-linux-extras install -y php7.4
sudo wget https://wordpress.org/latest.tar.gz
sudo tar xvzf latest.tar.gz -C /var/www/html
sudo cd /var/www/
sudo chown -R apache:apache html
sudo chkconfig httpd on
#sudo systemctl enable httpd
sudo systemctl restart httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "http://$myip/wp-admin/setup-config.php" > /tmp/max.log


#myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
#echo "<h2>WebServer with ip: $myip </h2><br>Small Environment build by Terraform" > /var/www/html/index.html
#sudo service httpd start
#sudo chkconfig httpd on

#!/bin/bash
#yum update -y
#amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
#yum install -y httpd mariadb-server
#systemctl start httpd
#systemctl enable httpd
#usermod -a -G apache ec2-user
#chown -R ec2-user:apache /var/www
#chmod 2775 /var/www
#find /var/www -type d -exec chmod 2775 {} \;
#find /var/www -type f -exec chmod 0664 {} \;
#echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
