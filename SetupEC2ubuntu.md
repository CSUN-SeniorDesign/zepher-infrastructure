---
title: "Setup EC2 instance Ubuntu Nginx web server"
author: "Author Name"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-09-08T01:50:11Z
draft: false
---
	Installing Ubuntu Server using Amazon Web Services 

	Overview: 
	
		- This lab teaches how to step-by-step install nginx web server on Ubuntu using Amazon Web Service.


	Prerequisite :
	
		- Amazon Web Services Account

	Steps:
	
		1. Installing the operating system:
		2. Login on Amazon Web Services (https://aws.amazon.com/console/)
		3. Make sure that your location on top right is US West (N. California)
		4. Click EC2 in All Services Section
		5. Click Launch Instance under Create Instance
		6. In step 1 Select Ubuntu Server 16.04 LTS (HVM), SSD Volume Type
		7. In step 2 Select the Free tier eligible t2.micro which is selected automatically
		8. Then click Next: Configure Instance Details
		9. Don’t change anything in step 3, just click Next: Add Storage
		10. In Step 4: Add Storage, leave the Size(GiB) to 8
		11. Click Next: Add Tags, and click Add Tag
		12. Under Key Type: Name and under Value Type: (type the name of your virtual Machine ex. testvm)
		13. After Click Next: Configure Security Group
		14. Next type same name as your virtual machine name under Security group name: testvm
		15. Scroll down and click Add Rule twice.
		16. under type choose HTTP and HTTPS and click Review and Launch
		17. Check everything and click Launch
		18. A window is going to Popup about a Key pair
		19. For the first option choose create a new key pair
		20. For Key pair name write your virtual machine name + key ex. testvmKey
		21. Next click Download Key pair and click Launch Instances
		22. Now scroll down and click View Instances
		23. On the left side scroll down until you see Elastic IPs and click it
		24. Now click Allocate new address
		25. Click Allocate and once its down go to Actions and select Associate address
		26. Under Instance select your virtual machine called (testvm)
		27. Make sure to check the box: Allow Elastic IP to be reassociated if already attached
		28. Click Associate

	Installing nginx:
		
		1. Sudo apt-get install nginx
		2. Confirm if nginx is installed using: http://localhost

	Create ssh keys for team members:

		- Follow the steps to create ssh keys and upload the public to the ubuntu server
			https://www.digitalocean.com/community/tutorials/how-to-create-ssh-keys-with-putty-to-connect-to-a-vps
