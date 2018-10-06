(crontab -l 2> /dev/null; echo '*/5 * * * * /home/ubuntu/developwebsite.sh') | crontab -
(crontab -l 2> /dev/null; echo '*/5 * * * * /home/ubuntu/staging.sh') | crontab -