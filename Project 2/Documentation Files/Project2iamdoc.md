Setup AWS Infrastructure using Terraform
	
	Overview:
		By the end of this tutorial the reader should be to able to setup following in AWS using just Terraform:
		
			- AWS IAM user 
			- AWS IAM Group
			- AWS group policy to give accesses to IAM user to put files s3 bucket when using CircleCI
			- AWS role for EC2 instances
			- AWS role policy to give access to ec2 instances to grab files from s3 bucket 
			- Attach the role to policy
	
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
				
		3. Create group circleci in the tf file. 

				resource "aws_iam_group" "circleci" {
					name = "circleci"
				}
				
		4. In this part the user will be created .
				
				resource "aws_iam_user" "zephyr1" {
					name = "zephyr1"
				}
				
		5. Final step if it is required we can add the users into a group.
		
				resource "aws_iam_group_membership" "zephyradmin-users" {
					name = "new-users"
					users = [
						"${aws_iam_user.zephyr1.name}"
					]
					group = "${aws_iam_group.circleci.name}"
				}
		
		6. Create AWS group policy to give accesses to IAM user to put files s3 bucket when using CircleCI
				
				resource "aws_iam_group_policy" "circleciputs3" {
					  name  = "circleciputs3"
					  group = "${aws_iam_group.circleci.id}"
					  policy = <<EOF
					{
						"Version": "2012-10-17",
						"Statement": [
							{
								"Sid": "VisualEditor0",
								"Effect": "Allow",
								"Action": [
									"s3:PutObject"
								],
								"Resource": [
									"arn:aws:s3:::zephyrproject2/*",
									"arn:aws:s3:::zephyrproject2"
								]
							}
						]
					}
					EOF
					}
		
		7. AWS role for EC2 instances
		
				resource "aws_iam_role" "role" {
					  name = "role"
					  assume_role_policy = <<EOF
					{
					  "Version": "2012-10-17", 
					  "Statement": [
						{
						  "Action": "sts:AssumeRole", 
						  "Effect": "Allow", 
						  "Principal": {
							"Service": "ec2.amazonaws.com"
						  }
						}
					   ]
					} 
					EOF
					}
		
		8. AWS role policy to give access to ec2 instances to grab files from s3 bucket 

				resource "aws_iam_policy" "getpolicyforec2" {
					  name = "getpolicyforec2"
					  policy = <<EOF
					{
						"Version": "2012-10-17",
						"Statement": [
							{
								"Effect": "Allow",
								"Action": [
									"s3:GetObject",
									"s3:ListBucket"
								],
								"Resource": [
									"arn:aws:s3:::zephyrproject2/*",
									"arn:aws:s3:::zephyrproject2"
								]
							}
						]
					}
					  EOF
					}
		
		9. Attach the role to policy
			
				resource "aws_iam_role_policy_attachment" "attachingpolicy" {
					role       = "${aws_iam_role.role.name}"
					policy_arn = "${aws_iam_policy.getpolicyforec2.arn}"
				}