# 0. create multipass container
multipass launch --name=nc-ass3

multipass shell nc-ass3

# 1. install all components
sudo apt-get install apache2 socat
git clone https://github.com/Gooowan/nc_assignment3

# 2.0. change 80 -> 20000
sudo nano /etc/apache2/ports.conf 
sudo nano /etc/apache2/sites-available/000-default.conf

# 2.1. restart apache
sudo systemctl restart apache2

# 3.0. iptables
sudo iptables -A INPUT -p tcp --dport 20000 -s localhost -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 20000 -j DROP

# 3.1. check if no duplicates in iptables
sudo iptables -S

# 3.1.1. if duplicates
sudo iptables -D INPUT -p tcp --dport 20000 -s localhost -j ACCEPT
sudo iptables -D INPUT -p tcp --dport 20000 -j DROP

# 3.2. cd nc_assignment3 and add permission to execute
chmod +x proxy_server.sh

# 4. move service to /etc/systemd/system/
sudo mv /home/ubuntu/nc_assignment3/proxy-server.service /etc/systemd/system/proxy-server.service

# 4.1. move html's
cd /var/www/html

delete all files there with:
sudo rm *.html

sudo mv /home/ubuntu/nc_assignment3/index.html /etc/systemd/system/index.html
sudo mv /home/ubuntu/nc_assignment3/error.html /etc/systemd/system/error.html

# 5. start sevice
sudo systemctl daemon-reload
sudo systemctl enable proxy-server.service
sudo systemctl start proxy-server.service

# 5.1. check status of proxy
sudo systemctl status proxy-server.service

# 6
open browser with ip:port and check two pages