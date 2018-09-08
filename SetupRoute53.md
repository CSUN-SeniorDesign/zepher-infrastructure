---
title: "Setup Route53"
author: "Author Name"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-09-08T01:50:20Z
draft: false
---

	
	Setup Route53 for Domain

	Overview:

		- A guide to setting up your domain using Route53 to serve requests.
		- User will be able to do the following after following this tutorial:
			Setup a Hosted Zone within Route53 in AWS
			Configure the DNS section within the Domain Provider
			Create Additional records within the Hosted Zone
		

	Prerequisites:
	
		- Access to the account of the Domain Provider
		- Access to a account to the AWS

	Steps

		Setting up Route53:

			1. Log into AWS → click Services. 
			2. Under Networking & Content Delivery click on Route53
			3. Click Hosted Zones →  Create Hosted Zone
			4. A window should have appeared titled Create Hosted Zone
			5. Domain Name section →  Enter a Domain name 
			6. Type section → Choose either Public Hosted Zone or Private Hosted Zone
			7. Click Create
			8. This should create two records, one Name Service (NS) record and one Start of Authority (SOA) record.

		Configuring Domain Provider:

			1. Click the NS type record → In the Value section, Copy the text.
			2. The Domain provider in this tutorial will be GoDaddy.
			3. Log into GoDaddy → click My Products
			4. Under Domains, click DNS
			5. Under Nameservers, change to use Custom
			6. Paste each Value from the NS record. Should be 4 → click Save


		Creating additional records for Domain (www. & Blog.):
		
			1. Log into AWS → click Services
			2. Under Networking & Content Delivery click on Route53
			3. Click Hosted Zones → click Your Hosted Zone
			4. Click Create Record Set → Name section →  Enter a Name such as www.
			5. Type section → change to type A - IPv4 addresses
			6. You change type to your preference but we chose type A
			7. Alias should be No
			8. TTL(Seconds) should stay at default
			9. Value → Enter your Elastic IP from your AWS Instance in here.
			10 .Click Save Record Set
			11. Repeat this process for any additional names. Such as for Blog.
