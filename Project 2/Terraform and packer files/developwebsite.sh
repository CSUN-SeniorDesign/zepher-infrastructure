#!/bin/bash                                                          
sudo aws s3 cp s3://zephyrproject2/circleciproduction/ /home/ubuntu/update/ --recursive                                          
sudo mkdir -p /home/ubuntu/update;                                      
sudo mkdir -p /home/ubuntu/current;                                     
sudo mkdir -p /home/ubuntu/pasttar;                                                                                                     
ls /home/ubuntu/update > update.txt                                  
ls /home/ubuntu/current > current.txt                                                                                                    
num=$(echo "$(cat update.txt)")                                      
num2=$(echo "$(cat current.txt)")                                                                                                        
if [ "$num" = "$num2" ]; then                                        
  sudo rm /home/ubuntu/update/*                                      
else                                                                 
  sudo mv /home/ubuntu/current/* /home/ubuntu/pasttar/               
  sudo mv /home/ubuntu/update/* /home/ubuntu/current/                
  sudo rm -r /var/www/html/public                                    
  sudo tar -C /var/www/html/ -zxvf /home/ubuntu/current/*.tar.gz     
fi                                                                   