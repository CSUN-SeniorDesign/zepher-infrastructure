---
title: "Setup Locking State in Terraform"
author: "Tonny Wong"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-09-23T15:15:35-07:00
draft: true
---

	Setup AWS Infrastructure using Terraform
		Terraform is used to create, manage, and update infrastructure resources such as physical machines, VMs, network switches, containers, and more. Almost any infrastructure type can be represented as a resource in Terraform. In this lesson we will use Terraform to create the virtual private cloud that we created in last lesson, which was using aws console.
		Last lesson Link: https://github.com/CSUN-SeniorDesign/zephyr-infrastructure/blob/master/setupAWS_VPC.md

		Overview:
			By the end of this tutorial the reader should be to able to setup following in AWS using just Terraform:
			
				- Create a terraform automation that would create a locking state in S3.
			
		Prerequisites:
			Computer with Windows Operating System
			AWS account
        		Create one as a student for $100 free credit: https://www.awseducate.com/registration#APP_TYPE
 
		Steps:
		
			When building a infrastructure with terraform config. It generates a file called terraform.tfstat.
			The file contains information about the configurations inside the infrastructure.
			This tutorial reader will help provide a lock remote terraform state file. If working in a team it is best to secure and store the terraform state files remotely
		
			1.  You will need to create a s3 bucket in the terraform config such as this one that we have used:
			
			# To store the state file in nad an terraform s3 backened resource.
			
				terraform {
					backend "s3" {
					bucket = "zephyrbuckets3"
					key    = "terraform.tfstate"
					dynamodb_table = "zephyrlock"

					region = "us-west-2"
					}
				}

			2. Then the backened resource is created 
			
			resource "aws_s3_bucket" "zephyrbucket" {
			bucket = "zephyrbuckets3"

				versioning {
					enabled = true
				}
				lifecycle {
					prevent_destroy = true
				}
			}
			resource "aws_dynamodb_table" "zephyrlock" {
				name = "zephyrlock"
				hash_key = "LockID"
				read_capacity = 20
				write_capacity = 20
 
				attribute {
					name = "LockID"
					type = "S"
				}
 
				tags {
					Name = "DynamoDB Terraform State Lock Table"
				}
			}
	
			It is good to have a locking state so that if the state file is stored remotely in order for
			Multiple people to access it. This prevents people from alternating the same file at a time creating corruption within the file.