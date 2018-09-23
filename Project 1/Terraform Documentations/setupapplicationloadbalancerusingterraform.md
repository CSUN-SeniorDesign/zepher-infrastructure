---
title: "Setup Application Load Balancer using Terraform"
author: "Author Name"
cover: "/img/cover.jpg"
tags: ["tagA", "tagB"]
date: 2018-09-23T15:40:45-07:00
draft: true
---

	Setup Application Load Balancer using Terraform
	
	Overview:
			By the end of this tutorial the reader should be to able to setup following in AWS using just Terraform:
				- Create a Application Load Balancer So that instances in private subnet can be displayed using this alb.
				
	Steps:
			Create a Application Load Balancer So that instances in private subnet can be displayed using this alb
				- First we have to create a security group using aws_security_group resource. We have to define name is any, description about the security group, vpc_id, and rules, port 22 in our case for ssh, we want to allow and from where.
						we add this lines to our provider.tf file:
									
									resource "aws_security_group" "zephyralbsg" {  
										  name = "zephyralbsg"
										  description = "allow port 80 access"
										  vpc_id = "${aws_vpc.zephyrvpc.id}"

										  ingress {
											from_port   = 80
											to_port     = 80
											protocol    = "tcp"
											cidr_blocks = ["0.0.0.0/0"]
										  }
										  egress {
											from_port   = 0
											to_port     = 0
											protocol    = "-1"
											cidr_blocks = ["0.0.0.0/0"]
										  }
										  tags {
												Name = "zephyr alb"
											}
										  
										 }
						In this security group we are allowing inbound port 80 access from anywhere using ingress.
						Save the file and go back to cmd -> change into the folder where you have the files -> terraform plan to see what changes will be made
						If everything is good you can make the changes by using terraform apply -> yes
						
				- Second we create the application load balancer using aws_alb resource.
						we add this lines to our provider.tf file:
						
							resource "aws_alb" "zephyralb"{
								 name = "zephyralb"
								 internal = false
								 security_groups = ["${aws_security_group.zephyralbsg.id}"]
								 depends_on = ["aws_security_group.zephyralbsg"]
								 subnets = ["${aws_subnet.zephyrps1.id}","${aws_subnet.zephyrps2.id}","${aws_subnet.zephyrps3.id}"]
							}
							
				- Third we create a target group that would listen on port 80 with health check.
						we add this lines to our provider.tf file:
						
							resource "aws_alb_target_group" "zephyralbtg" {
								name	= "zephyralbtg"
								vpc_id	= "${aws_vpc.zephyrvpc.id}"
								port	= "80"
								protocol	= "HTTP"
								depends_on = ["aws_alb.zephyralb"]
								health_check {
											path = "/"
											port = "80"
											protocol = "HTTP"
											healthy_threshold = 5
											unhealthy_threshold = 2
											interval = 30
											timeout = 5
											matcher = "200"
								}
							}
							
				- Fourth we create a listener for port 80 that would forward any request that comes from outside will point to the target group.
						we add this lines to our provider.tf file:

							resource "aws_alb_listener" "front_end" {
							  load_balancer_arn = "${aws_alb.zephyralb.arn}"
							  port              = "80"
							  protocol          = "HTTP"
							  default_action {
								type             = "forward"
								target_group_arn = "${aws_alb_target_group.zephyralbtg.arn}"
							  }
							}
				- Fifth we attach our private web servers to the target group.
						we add this lines to our provider.tf file:

							resource "aws_alb_target_group_attachment" "zephyralbattach1" {
							  target_group_arn = "${aws_alb_target_group.zephyralbtg.arn}"
							  target_id        = "${aws_instance.linux1.id}"
							  port             = 80
							  depends_on = ["aws_alb.zephyralb"]
							}