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
			
				- Create a terraform automation to create aws iam users
		
		Prerequisites:
			Computer with Windows Operating System
			AWS account
        		Create one as a student for $100 free credit: https://www.awseducate.com/registration#APP_TYPE
 
		Steps:
			1.  Create a tf extension file with any name that you are able to identify as the iam user
			2. In the file provide the aws region, secret key and access key.
			
					provider "aws" {
						access_key = "${var.aws_access_key}"
						secret_key = "${var.aws_secret_key}"
						region     = "${var.region}"
					}
					
			3. Create group administrators in the tf file. 

					resource "aws_iam_group" "zephyradmin" {
						name = "zephyradmin"
					}
					
			4. Create the iam policy so that the users have admin access.
			
					resource "aws_iam_policy_attachment" "zephyradmin-attach" {
						name = "zephyradmin-attach"
						groups = ["${aws_iam_group.zephyradmin.name}"]
						policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
					}
					
			5. In this part the users will be created this is part of our script that created a user for each individual.
					
					resource "aws_iam_user" "adminusr1" {
						name = "Danielp1"
					}
					resource "aws_iam_user" "adminusr2" {
						name = "Tonnyp1"
					}
					resource "aws_iam_user" "adminusr3" {
						name = "Haydenp1"
					}
					resource "aws_iam_user" "adminusr4" {
						name = "Neelp1"
					}
			6. Final step if it is required we can add the users into a group.
			
					resource "aws_iam_group_membership" "zephyradmin-users" {
						name = "zephyradmin-users"
						users = [
							"${aws_iam_user.adminusr1.name}",
							"${aws_iam_user.adminusr2.name}",
							"${aws_iam_user.adminusr3.name}",
							"${aws_iam_user.adminusr4.name}",

						]
						group = "${aws_iam_group.zephyradmin.name}"
					}