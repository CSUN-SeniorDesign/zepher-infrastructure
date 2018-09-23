---
title: "Setup AWS Infrastructure Using Terraform"
author: "Author Name"
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
			1.Installing Terraform on Windows:
			
			    Download terraform zip file: https://www.terraform.io/downloads.html
			    Extract the zip file in you Documents. (Note. at this point we need to add this zip file in our environmental variable so we can use terraform using cmd.)
			    Search for environment variable => Edit the systems environmental variables if win 10 => Environment Variable (bottom right corner) => select Path => Edit => Browse => select the extracted zip file in your documents.
			    Open CMD to see if terraform can be used from cmd => “terraform version”
			    Result:  Terraform v0.11.8
			 
			2. Installing AWS cli on Windows:
			
				Follow the steps given by aws to download aws cli on Windows: https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-windows.html
		 
			3. Creating one IAM administrator permissions user with programmatic access.
		 
		        Log in to aws console: https://console.aws.amazon.com/console/home
				On AWS Services search for IAM
		        Click on Users => Add User => Type Username
		        For “Select AWS access type” choose Programmatic Access for that it create an access key (access key ID and a secret access key) for that user which we will use on terraform to connect to aws. => Next: Permission
		        Click on “Attach existing policies directly” => Select AdministratorAccess policy => Next: Review
		        Click “Create User”
		        Either download .csv file or write your Access key ID and Secret access key since it will be shown only once.
		 
			4. Configure aws cli:
			
				Open CMD => type “aws --version” to find the version of aws cli in your system
				aws configure --profile username => enter
				
					AWS Access Key ID [None]: enter access id you got for that IAM user
					AWS Secret Access Key [None]: enter secret access key
					Default region name [None]: region you want to create your infrastructure
					Default output format [None]: text
			5. Building infrastructure using terraform:
				1. Create a file for the infrastructure terraform files
					Open CMD → mkdir terraformtest
					cd terraformtest
				2. Creating VPC
					Create a file provider.tf using touch provider.tf using cmd
					Go to the folder and open file using Notepad or Notepad++
					First we need to define our provider which is aws using following commands:
						o   provider "aws" { }
					Everything in terraform are resources and we create them using following syntax:
						o   resource “resource type” “logical name for the resource” { }
					After that we create a vpc using aws_vpc resource
							
							resource "aws_vpc" "zephyrvpc" {
							  cidr_block   	= "172.31.0.0/16"
							  instance_tenancy = "default"
							 
							  tags {
								Name = "zephyrvpc"
							  }
							}
					 
					Save the file and go back to cmd -> change into the folder where you have the files -> terraform init to initialize terraform -> terraform plan to see what changes will be made
					If everything is good you can make the changes by using terraform apply -> yes
					You can go back to aws console to see that VPC was created or not.
					 
				3. Create Internet Gateway using terraform:
					To create internet gateway, we use aws_internet_gateway resource and attached vpc-using vpc_id. Important Note: "${aws_vpc.zephyrvpc.id}" is using interpolation syntax to get the id of the vpc we created previously using the logical name of the resource.
					we add this lines to our provider.tf file:
					 
							resource "aws_internet_gateway" "zephyrgw" {
							vpc_id = "${aws_vpc.zephyrvpc.id}"
							 
							tags {
							Name = "zephyrgw"
							}
							}
					 
					Save the file and go back to cmd -> change into the folder where you have the files -> terraform plan to see what changes will be made
					If everything is good you can make the changes by using terraform apply -> yes
					You can go back to aws console to see that internet gateway was created or not.
					 
				4. Create subnets using terraform:
					To create subnet, we use aws_subnet resource. We have to define the CIDR block of the subnet, availability_zone and the vpc the subnets will reside in.
					we add this lines to our provider.tf file:
					 
							resource "aws_subnet" "zephyrps1" {
							  vpc_id 	= "${aws_vpc.zephyrvpc.id}"
							  cidr_block = "172.31.0.0/22"
							  availability_zone = "us-west-2a"
							 
							  tags {
								Name = "zephyrps1"
							  }
							}
					Copy and paste this resource 5 more time to create This CIDR blocks:
						   Name           CIDR block
						zephyrps2       172.31.4.0/22
						Zephyrps3       172.31.8.0/22
						zephyrprs1      172.31.16.0/20
						Zephyrprs2      172.31.32.0/20
						Zephyrprs3      172.31.48.0/20
						   
					Save the file and go back to cmd  ->  change into the folder where you have the files -> terraform plan to see what changes will be made
					If everything is good you can make the changes by using terraform apply  ->  yes
					You can go back to aws console to see that all six subnets were created or not.
					 
					 
				5. Create route table for the public subnets with added route through the internet gateway created earlier.
					To create route table, we use aws_route_table resource. We have to define the vpc and a route that allows internet access to our resources in our public subnets.
					we add this lines to our provider.tf file:
					 
							resource "aws_route_table" "zephyrprt" {
							  vpc_id = "${aws_vpc.zephyrvpc.id}"
							 
							  route {
								cidr_block = "0.0.0.0/0"
								gateway_id = "${aws_internet_gateway.zephyrgw.id}"
							  }
							  tags {
								Name = "zephyrprt"
							  }
							}
					 
					Save the file and go back to cmd  ->  change into the folder where you have the files  ->  terraform plan to see what changes will be made
					If everything is good you can make the changes by using terraform apply  ->  yes
					You can go back to aws console to see that a route table was created or not. Also check the inbound and outbound setting.
					 
					 
				6. Create route table for the private subnets with  no added route.
					we add this lines to our provider.tf file:
					 
							resource "aws_route_table" "zephyrprrt" {
							  vpc_id = "${aws_vpc.zephyrvpc.id}"
							  tags {
								Name = "zephyrprrt"
							  }
							}
					 
					We did not add any route in this table is because it is for private subnets resources and they will have access to internet to do updates and etc. via a NAT instance which will be added later in the lesson.
					Save the file and go back to cmd -> change into the folder where you have the files  -> terraform plan to see what changes will be made
					If everything is good you can make the changes by using terraform apply  ->  yes
					You can go back to aws console to see that a route table was created or not. Also check the inbound and outbound setting.
					 
				7. Associate public subnets with public route table
					To associate the subnet to route table, we use aws_route_table_association resource. We have to define subnet_id and route_table_id using interpolation syntax. 
					we add this lines to our provider.tf file:
					 
							resource "aws_route_table_association" "zephyrpra1" {
							  subnet_id  	= "${aws_subnet.zephyrps1.id}"
							  route_table_id = "${aws_route_table.zephyrprt.id}"
							}
					 
					Copy and paste this resource 2 more time for subnets:
						subnet_id  	= "${aws_subnet.zephyrps2.id}"
						subnet_id  	= "${aws_subnet.zephyrps3.id}"
					Save the file and go back to cmd -> change into the folder where you have the files -> terraform plan to see what changes will be made
					If everything is good you can make the changes by using terraform apply -> yes
					 
				8. Associate private subnets with private route table
					To associate the subnet to route table, we use aws_route_table_association resource. We have to define subnet_id and route_table_id using interpolation syntax.
					we add this lines to our provider.tf file:
					 
							resource "aws_route_table_association" "zephyrpra1" {
							  subnet_id  	= "${aws_subnet.zephyrprs1.id}"
							  route_table_id = "${aws_route_table.zephyrprrt.id}"
							}
					 
					Copy and paste this resource 2 more time for subnets:
							subnet_id  	= "${aws_subnet.zephyrprs2.id}"
							subnet_id  	= "${aws_subnet.zephyrprs3.id}"
					Save the file and go back to cmd -> change into the folder where you have the files -> terraform plan to see what changes will be made
					If everything is good you can make the changes by using terraform apply -> yes
					 
					 
				9. Create bastion host for ssh purposes.
					To create a bastion first we have to create a security group using aws_security_group resource. We have to define name is any, description about the security group, vpc_id, and rules, port 22 in our case for ssh, we want to allow and from where.
						we add this lines to our provider.tf file:
									resource "aws_security_group" "bastionsecuritygroup" { 
									  name        = "bastion"
									  description = "Allow SSH traffic to bastion"
									  vpc_id      = "${aws_vpc.zephyrvpc.id}"
									  ingress {
										from_port   = 22
										to_port     = 22
										protocol    = "tcp"
										cidr_blocks = ["0.0.0.0/0"]
									  }
									  egress {
										from_port   = 0
										to_port     = 0
										protocol    = "-1"
										cidr_blocks = ["0.0.0.0/0"]
									  }
									 }
									 
						In this security group we are allowing inbound ssh access from anywhere using ingress.
						Save the file and go back to cmd -> change into the folder where you have the files -> terraform plan to see what changes will be made
						If everything is good you can make the changes by using terraform apply -> yes
					
					After creating the security group next we will use aws_instanse resource to create our bastion host. In here we have to define the ami number, availability_zone of the instance, instance_type, subnet_id of public subnet id, security group.
					 
						we add this lines to our provider.tf file:
					 
								resource "aws_instance" "bastion" {
									ami = "ami-51537029"
									availability_zone = "us-west-2b"
									instance_type = "t2.micro"
									key_name = "newpair"
									subnet_id = "${aws_subnet.zephyrps2.id}"
									associate_public_ip_address = true
										vpc_security_group_ids  = ["${aws_security_group.bastion-securitygroup.id}"]
								depends_on = ["aws_security_group.bastion-securitygroup"]
									tags {
										Name = "Bastion Instance"
									}
								}
								 
						since we are using this instance as ssh we need to add a key so we can use putty to ssh, and we added associate_public_ip_address so it get a public ip when created.
						Save the file and go back to cmd -> change into the folder where you have the files -> terraform plan to see what changes will be made
						If everything is good you can make the changes by using terraform apply -> yes
					 
				10. Create NAT instance for internet access for private resources
					 
					To create a NAT instance that is already configured by aws, we have to create a security group using aws_security_group resource. We have to define name is any, description about the security group, vpc_id, and rules, port 22 and port 443 access from private instances and outbound to all.
						we add this lines to our provider.tf file:
					 
									resource "aws_security_group" "nat-securitygroup" { 
									  name        = "nat"
									  description = "Allow traffic to pass from the private subnet to the internet"
									  vpc_id      = "${aws_vpc.zephyrvpc.id}"
									 
									  ingress {
											from_port = 80
											to_port = 80
											protocol = "tcp"
											cidr_blocks = ["172.31.16.0/20","172.31.32.0/20","172.31.48.0/20"]
										}
										ingress {
											from_port = 443
											to_port = 443
											protocol = "tcp"
															cidr_blocks = ["172.31.16.0/20","172.31.32.0/20","172.31.48.0/20"]
										}
										ingress {
											from_port = 22
											to_port = 22
										 protocol = "tcp"
											cidr_blocks = ["0.0.0.0/0"]
										}
										ingress {
											from_port = -1
											to_port = -1
											protocol = "icmp"
											cidr_blocks = ["0.0.0.0/0"]
										}
										egress {
											from_port = 80
											to_port = 80
											protocol = "tcp"
											cidr_blocks = ["0.0.0.0/0"]
										}
										egress {
											from_port = 443
											to_port = 443
											protocol = "tcp"
											cidr_blocks = ["0.0.0.0/0"]
										}
										egress {
											from_port = 22
											to_port = 22
										  protocol = "tcp"
											cidr_blocks = ["172.31.0.0/16"]
										}
										egress {
											from_port = -1
											to_port = -1
											protocol = "icmp"
											cidr_blocks = ["0.0.0.0/0"]
										}
										tags {
											Name = "NAT securitygroup"
										}
									 }
									 
						In this security group we are allowing inbound 80 and 443 from our private subnets and outbound to anyone.
						Save the file and go back to cmd -> change into the folder where you have the files -> terraform plan to see what changes will be made
						If everything is good you can make the changes by using terraform apply -> yes
					 
					After creating the security group next we will use aws_instanse resource to create our bastion host. In here we have to define the ami number, availability_zone of the instance, instance_type, subnet_id of public subnet id, security group.
					 
						we add this lines to our provider.tf file:
					 
								resource "aws_instance" "nat" {
									ami = "ami-40d1f038"
									availability_zone = "us-west-2a"
									instance_type = "t2.micro"
									key_name = "newpair"
									subnet_id = "${aws_subnet.zephyrps1.id}"
									associate_public_ip_address = true
										vpc_security_group_ids = ["${aws_security_group.nat-securitygroup.id}"]
										source_dest_check = false
										depends_on = ["aws_security_group.nat-securitygroup"]
									tags {
										Name = "Nat Instance"
									}
								}
						Since we are using this instance as nat we added a key so we can use putty to ssh, and since NAT instance into do both source and destination check we have to disable it.
						Save the file and go back to cmd -> change into the folder where you have the files -> terraform plan to see what changes will be made
						If everything is good you can make the changes by using terraform apply -> yes
					 
				11. Edit the public route table with new route.
										resource "aws_route_table" "zephyrprrt" {
										  vpc_id = "${aws_vpc.zephyrvpc.id}"
										 
										route {
												cidr_block = "0.0.0.0/0"
												instance_id = "${aws_instance.nat.id}"
											}
										 
										tags {
											Name = "zephyrprrt"
										  }
										}
