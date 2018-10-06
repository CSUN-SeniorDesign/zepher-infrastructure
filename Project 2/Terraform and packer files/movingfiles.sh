#!/bin/bash   
sudo mv /home/ubuntu/conf.yaml /etc/datadog-agent/conf.d/nginx.d/conf.yaml
cd /etc/datadog-agent/conf.d/nginx.d/
sudo chown dd-agent:dd-agent conf.yaml
sudo chmod 640 conf.yaml
cd ~
sudo mv /home/ubuntu/datadog.yaml /etc/datadog-agent/datadog.yaml
cd /etc/datadog-agent/
sudo chown dd-agent:dd-agent datadog.yaml
sudo chmod 640 datadog.yaml
cd ~
sudo mv /home/ubuntu/status.conf /etc/nginx/conf.d/status.conf
cd /etc/nginx/conf.d/
sudo chown root:root status.conf
sudo chmod 644 status.conf
cd ~
sudo service datadog-agent restart
sudo service nginx restart