---
title: "Setup IAM Users"
author: "Tonny Wong"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-09-23T15:15:35-08:00
draft: false
---

	Setup AWS Infrastructure using Terraform
		Terraform is used to create, manage, and update infrastructure resources such as physical machines, VMs, network switches, containers, and more. Almost any infrastructure type can be represented as a resource in Terraform. In this lesson we will use Terraform to create the virtual private cloud that we created in last lesson, which was using aws console.
		Last lesson Link: https://github.com/CSUN-SeniorDesign/zephyr-infrastructure/blob/master/setupAWS_VPC.md

		Overview:
			By the end of this tutorial the reader should be to able to setup following in AWS using just Terraform:
				1.       Install Terraform in Windows Operating Systems.
				2.       Install aws cli.
				3.       Creating one IAM administrator permissions user with programmatic access.
				4.       Configure aws cli
				5.       Building infrastructure using terraform:
				-          A VPC  with size /16 CIDR block.In this case we are using 172.31.0.0/16 CIDR block.
				-          1 Internet Gateway (IG) attached to zephyrvpc.
				-          3 public subnets in 3 different availability zones (AZ) [172.31.0.0/22, 172.31.4.0/22, 172.31.8.0/22]
				-          3 private subnets in 3 different availability zones (AZ)  [172.31.16.0/22, 172.31.32.0/22, 172.31.48.0/22]
				-          1 route table for the public subnets with added route through the internet gateway created earlier.
				-          1 route table for the private subnets.
				-          Associate public subnets to public route table.
				-          Associate public subnets to public route table.
				-          Create bastion host for ssh purposes.
				-          Create NAT instance for internet for private resources
				-          Edit the public route table with new route.
 
 
		Prerequisites:
			Computer with Windows Operating System
			AWS account
        		Create one as a student for $100 free credit: https://www.awseducate.com/registration#APP_TYPE
 
		Steps:
			1. 