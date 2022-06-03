#!/bin/bash
sudo echo "start" > /tmp/max-user-data.log
sudo wget https://raw.githubusercontent.com/mcrucovschii/WebServerTF/Development/hapee-userdata.sh.tpl -O /root/haproxy.sh
sudo cd /root/
sudo bash /root/haproxy.sh
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
${serverlist}
EOF
sudo chmod 644 /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy
