#!/bin/bash
sudo echo "start" > /tmp/hapee-user-data.log
sudo yum install git -y
sudo git clone https://github.com/nozaq/amazon-linux-cis.git
sudo cd /root/
sudo python ./amazon-linux-cis
#sudo yum install gcc pcre-devel tar make -y
#sudo wget http://www.haproxy.org/download/2.6/src/haproxy-2.6.0.tar.gz -O /root/haproxy.tar.gz
#sudo tar -xvf /root/haproxy.tar.gz -C /root
#sudo cd /root/haproxy-2.6.0
#sudo make TARGET=linux-glibc
#sudo make install
sudo wget https://github.com/mcrucovschii/SmallEnvironment/raw/Development/haproxy -O /usr/local/sbin/haproxy
sudo chmod 755 /usr/local/sbin/haproxy
sudo mkdir -p /etc/haproxy
sudo mkdir -p /var/lib/haproxy
sudo touch /var/lib/haproxy/stats
sudo ln -s /usr/local/sbin/haproxy /usr/sbin/haproxy
sudo wget https://raw.githubusercontent.com/mcrucovschii/SmallEnvironment/Development/haproxy.init -O /etc/init.d/haproxy
sudo chmod 755 /etc/init.d/haproxy
sudo useradd -r haproxy
sudo groupadd haproxy
sudo systemctl daemon-reload
sudo chkconfig haproxy on
sudo iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo chmod 644 /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy
sudo echo "end" >> /tmp/hapee-user-data.log
