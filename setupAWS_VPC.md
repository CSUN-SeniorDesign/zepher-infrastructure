---
title: "Set up AWS VPC"
author: "Author Name"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-09-08T01:49:55Z
draft: false
---

	Setup AWS Virtual Private Cloud (VPC)
	
	Overview:
	
		1. By the end of this tutorial the reader should be to able to setup following in AWS:
		2. A VPC with size /16 CIDR block which provide 65536 available hots. In this case we are using default 172.31.0.0/16 CIDR block.
		3. 3 public subnets in 3 different availability zones (AZ) with at least 1024 available IP addresses per subnet which is size /22 CIDR block.
		4. 3 private subnets in 3 different availability zones (AZ) with at least 4096 available IP addresses per subnet which is size /20 CIDR block. 
		5. 1 route table for the public subnets to associate all 3 public subnets. This route table has 2 entry; first entry enables instance in the subnets to communicate with each other and second entry enable the instance in those public subnet to communicate with the internet.
		6. 1 route table for the private subnets to associate all 3 private subnets. This route table has one entry that only allow communication within the subnet and not outside world/internet.
		7. 1 Internet Gateway (IG) attached to the default route of the public subnet routing table. This gateway connect VPC to internet.

	Prerequisites:
	
		- AWS account 
			Create one as a student for $100 free credit: https://www.awseducate.com/registration#APP_TYPE

	Steps:
	
		1. Log in to Amazon Web Service: https://console.aws.amazon.com/console/home
		2. Create a VPC:
		3. Click on Services → Search for VPC
		4. Click on VPCs → Create VPC
		5. Enter a name for the VPC where it says “Name tag”
		6. Enter 172.31.0.0/16 in the IPv4 CIDR clock → click Yes,create


	Create Internet Gateway:
	
		1. Inside VPC In the left navigation pane, choose Internet Gateway.
		2. Click on create internet gateway.
		3. Enter a name for the gateway → Create
		4. Select the gateway → click on Action → Attach to VPC → select the VPC created in step 4

	Create public subnets (1024 IPv4 Address available):
	
		1. Now Inside VPC In the left navigation pane, choose Subnets.
		2. Click create subnet → give name for the subnet
		3. Select the VPC created in step 4
		4. Select any Availability Zone
		5. Enter 172.31.0.0/22 in the IPv4 CIDR block → create
		6. Repeat the steps again to create subnet with 172.31.4.0/22 and 172.31.8.0/22 IPv4 CIDR clock
		7. Create public subnets (4096 IPv4 address available):
		8. Now Inside VPC In the left navigation pane, choose Subnets.
		9. Click create subnet → give name for the subnet
		10. Select the VPC created in step 4
		11. Select any Availability Zone
		12. Enter 172.31.16.0/20 in the IPv4 CIDR block → create
		13. Repeat steps again to create subnet with 172.31.32.0/20 and 172.31.48.0/220 IPv4 CIDR clock
	
	Create a Public Route Table:
	
		1. Now Inside VPC In the left navigation pane, choose Route Tables.
		2. Click create Route Table 
		3. Give the route table a name (i.e. public_sub) and select the VPC created earlier.
		4. Click yes, create.
		5. Click on the public_sub route table → on the bottom click on Subnet Associations.
		6. Click Edit → select all 3 Public subnets created earlier → Save
		7. Click on Routes → Edit
		8. Add another route
		9. Destination = 0.0.0.0/0 
		10. Target = the internet gateway we created earlier.
		11. Click save.

	Create a Public Route Table:
	
		1. Now Inside VPC In the left navigation pane, choose Route Tables.
		2. Click create Route Table 
		3. Give the route table a name (i.e. private_sub) and select the VPC created earlier.
		4. Click yes, create.
		5. Click on the private_sub route table → on the bottom click on Subnet Associations.
		6. Click Edit → select all 3 Private subnets created earlier → Save
		7. We do not edit the routes.

