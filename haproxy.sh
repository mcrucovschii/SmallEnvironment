#!/bin/bash
sudo echo "start" > /tmp/max-user-data.log
sudo yum install git -y
sudo cd /root/
sudo git clone https://github.com/nozaq/amazon-linux-cis.git
sudo cd /root/
sudo python ./amazon-linux-cis
#sudo yum install gcc pcre-devel tar make -y
sudo wget http://www.haproxy.org/download/2.6/src/haproxy-2.6.0.tar.gz -O /root/haproxy.tar.gz
sudo tar -xvf /root/haproxy.tar.gz -C /root
sudo cd /root/haproxy-2.6.0
#sudo make TARGET=linux-glibc
#sudo make install
sudo wget https://github.com/mcrucovschii/WebServerTF/raw/20a3b65a2df369745e2bd668a8f8527a516f6eac/haproxy -O /usr/local/sbin/haproxy
sudo chmod 755 /usr/local/sbin/haproxy
sudo mkdir -p /etc/haproxy
sudo mkdir -p /var/lib/haproxy
sudo touch /var/lib/haproxy/stats
sudo ln -s /usr/local/sbin/haproxy /usr/sbin/haproxy
sudo cp /root/haproxy-2.6.0/examples/haproxy.init /etc/init.d/haproxy
sudo chmod 755 /etc/init.d/haproxy
sudo useradd -r haproxy
sudo groupadd haproxy
sudo systemctl daemon-reload
sudo chkconfig haproxy on
sudo iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo tee /etc/haproxy/haproxy.cfg <<EOF
global
   log /dev/log local0
   log /dev/log local1 debug
   chroot /var/lib/haproxy
   stats timeout 30s
   user haproxy
   group haproxy
   daemon
defaults
   log global
   mode http
   option httplog
   option dontlognull
   timeout connect 5000
   timeout client 50000
   timeout server 50000
frontend http_front
   bind *:80
   stats uri /haproxy?stats
   default_backend http_back
backend http_back
   balance roundrobin
   server server_name1 172.31.17.176:80 check
   server server_name2 172.31.31.80:80 check
EOF
sudo chmod 644 /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy
