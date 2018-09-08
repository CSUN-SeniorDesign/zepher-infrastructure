---
title: "Set up TLS certificate"
author: "Author Name"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-09-08T01:50:49Z
draft: false
---

	Generating TLS Certificates

	Overview:

		- A guide to Generating TLS Certificates for a Users Domain
		- At the end of this Tutorial the User will be to do the following:
		- Generate a set of Security Certificates for their domain
		- Check to see if the domains have the Security Certificates.
		- Keep there Private key safe.
	

	Prerequisites:

		- Access to AWS account
		- Access to SSH access to the server your website is hosted. 
		- You are using nginx and on Ubuntu 16.04 (xenial)

	Steps:

		Installing CertBot:

			1. SSH into your web server → Type the Following Commands
			2. Sudo apt-get update
			3. Sudo apt-get install software-properties-common
			4. Sudo apt-get-repository ppa:certbot/certbot
			5. Sudo apt-get update
			6. Sudo apt-get install python-certbot-nginx

		Installing Certificates:

			1. Type sudo certbot --nginx
			2. This command will download the certificates for you and automatically edit the configuration files needed.
			3. If you have a domain with aliases you will need to modify this command
					Instead type sudo certbot --nginx -d yourdomain.com -d aliascom
			4. You could continue the command using -d alias.com for each alias you have. This will certify your domain and all of it’s aliases.



		Checking the Certificates:
		
			1. After waiting some time there are two ways of checking to see if you have the certificates
			2. In the SSH type sudo certbot certificates
			3. You should get a response showing all the domains and aliases that have been certified.
			4. Go to www.ssllabs.com → click Test your Server
					- Type in your Domain Name
					- Wait and Analyze the Results.




