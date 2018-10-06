---
title: "Deployment Script"
author: "Tonny Wong"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-10-05T15:15:35-07:00
draft: false
---

	Staging Script for the Hugo site:
	
		We will have two sites to deplow. One of the sites is going to be the staging site that will contain the latest code and production code which will deploy.
		It will determine when to deploy and have a certain revision before deployment. This should be automated rather than being manually typed in the process.
		
		The staging site will be continously updating the site as when it is pushed from the terminal git push command.
		This will be done every 5 minutes to update with a following script.

		Overview:
			By the end of this tutorial the reader should be to able to setup following:
			
				- Create a script to deploy site (staging) and automatically update it every 5 minutes:
				
					1. Check S3 for the latest build ID.
					2. Check the latest build on the local system.
					3. If newer version is available, download and unackage somewhere on the system.
					4. Point the web server at the new version of the code.
					5. Gracefully restart the web server to make sure it is serving the new information.
					6. Clean up an packages or deployments that are no longer needed.
			
		Prerequisites:
		
			Computer with Windows Operating System
			
			AWS account:
        		Create one as a student for $100 free credit: https://www.awseducate.com/registration#APP_TYPE
				
		Steps:

		-	Create script with any script extension:
		
				-	This documentation was done with a .sh extension.
				
		-	Then start with the first line as "#!/bin/bash".
		
		-	Grab the tar file and place it into a file on linux using this command as an example: (If the linux file do not exist it will create them)
		
				- sudo aws s3 cp s3://zephyrproject2/circleciproduction/ /home/ubuntu/staging/ --recursive
				
		-	Then we will create 3 more files if they do not exist, to do the verification process (Names can be any as long as you know which one does what).
		
				- sudo mkdir -p /home/ubuntu/staging
					- This will be the file that will have the grabbed tar file.
				- sudo mkdir -p /home/ubuntu/stagingcurrent
					- This one will have the current version thats on the www/html/public.
				- sudo mkdir -p /home/ubuntu/stagingpasttar
					- We will have old tar incase of errorto verify changes also.
				- sudo mkdir -p /var/www/html/staging
					- This is where we will put our staging site.
				
		-	Then used ls to check whats inside the folder, Meaning that one should contain the the grab tar file and one with the current file.
				
				- ls /home/ubuntu/staging > update1.txt
				- ls /home/ubuntu/stagingcurrent > current1.txt
				
		-	Put them into a variable so that the output of the text can be used in the if statement for verification purposes.
				
			-	The verification should do is to verify the tar file.
			-	The program has to be ran twice in order to have something in those files.
			-	So when we actually start editing tar it will continously grab the most recent updated tar.
				-	If the tar is not new it will remove the tar that was downloaded.
					
					num=$(echo "$(cat update1.txt)")
					num=$(echo "$(cat current1.txt)")
					
					if [ "$num" = "$num2" ]; then
						echo "There is no updated files"
						sudo rm /home/ubuntu/staging/*

		-	After the verification process was done then the tar file will be unzipped and placed in the html staging public.
		
		-	Before we do put it into the html public we will remove whatever is inside the html and then place it by running this code:
				
				else                                                                 
					sudo mv /home/ubuntu/stagingcurrent/* /home/ubuntu/stagingpasttar/               
					sudo mv /home/ubuntu/staging/* /home/ubuntu/stagingcurrent/                
					sudo rm -r /var/www/html/staging/public                                    
					sudo tar -C /var/www/html/staging/ -zxvf /home/ubuntu/stagingcurrent/*.tar.gz     
				fi                                                                   