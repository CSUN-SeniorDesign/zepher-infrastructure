---
title: "Setup Linux Server"
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

				- Create 2 linux servers in private subnets
			
		Prerequisites:
			Computer with Windows Operating System
			AWS account
        		Create one as a student for $100 free credit: https://www.awseducate.com/registration#APP_TYPE
 
		Steps:
			1. This first step will create the linux security group with the allowed ports and ip address they are able to use.
				resource "aws_security_group" "linux-securitygroup" {  
					name        = "linux"
					description = "Allow SSH traffic to bastion"
					vpc_id      = "${aws_vpc.zephyrvpc.id}"

					ingress {
						from_port   = 22
						to_port     = 22
						protocol    = "tcp"
						cidr_blocks = ["172.31.0.0/16"]
					}
					ingress {
						from_port   = 80
						to_port     = 80
						protocol    = "tcp"
						cidr_blocks = ["172.31.0.0/16"]
					}
					egress {
						from_port   = 0
						to_port     = 0
						protocol    = "-1"
						cidr_blocks = ["0.0.0.0/0"]
					}

				}

			2. This will create the first private subnet linux server.
				
				resource "aws_instance" "linux1" {
					ami = "ami-51537029"
					availability_zone = "us-west-2a"
					instance_type = "t2.micro"
					key_name = "newpair"
					subnet_id = "${aws_subnet.zephyrprs1.id}"
					vpc_security_group_ids = ["${aws_security_group.linux-securitygroup.id}"]
		
					depends_on = ["aws_security_group.linux-securitygroup"]
	

  
					tags {
						Name = "linux1 Instance"
					}
				}
				
			3. This will create the second private subnet linux server.
				
				resource "aws_instance" "linux2" {
					ami = "ami-51537029"
					availability_zone = "us-west-2a"
					instance_type = "t2.micro"
					key_name = "newpair"
					subnet_id = "${aws_subnet.zephyrprs.id}"
					vpc_security_group_ids = ["${aws_security_group.linux-securitygroup.id}"]
		
					depends_on = ["aws_security_group.linux-securitygroup"]
	

  
					tags {
						Name = "linux2 Instance"
					}
				}



