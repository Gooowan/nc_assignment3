#!/bin/bash

# Step 0: Create and connect to a Multipass container (Manual Step)
# multipass launch --name=nc-ass3
# multipass shell nc-ass3

# Step 1: Install Apache2 and socat
sudo apt-get update
sudo apt-get install -y apache2 socat

# Clone the assignment repository (Adjust the URL as needed)
git clone https://github.com/Gooowan/nc_assignment3

# Step 2: Configure Apache to use port 20000
sudo sed -i 's/Listen 80/Listen 20000/' /etc/apache2/ports.conf
sudo sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:20000>/' /etc/apache2/sites-available/000-default.conf

# Restart Apache to apply changes
sudo systemctl restart apache2

# Step 3: Configure iptables
sudo iptables -A INPUT -p tcp --dport 20000 -s localhost -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 20000 -j DROP

# Note: Duplicate iptables rules need manual verification

# Grant execution permissions to the proxy script
chmod +x /home/ubuntu/nc_assignment3/proxy_server.sh

# Step 4: Deploy Proxy Server and Web Pages
sudo mv /home/ubuntu/nc_assignment3/proxy-server.service /etc/systemd/system/proxy-server.service

# Prepare the Apache web directory and move HTML files
sudo rm /var/www/html/*.html
sudo mv /home/ubuntu/nc_assignment3/index.html /var/www/html/index.html
sudo mv /home/ubuntu/nc_assignment3/error.html /var/www/html/error.html

# Step 5: Start and Verify the Proxy Service
sudo systemctl daemon-reload
sudo systemctl enable proxy-server.service
sudo systemctl start proxy-server.service

# Echo a message to open the browser manually
echo "Setup completed. Please open a web browser and navigate to http://<IP-of-container>:20000 to check the availability of the 'index.html' and 'error.html' pages."