AWS Auto Scaling and Launch Configuration

<h1>Setup AWS Auto scaling Group and Launch Configuration</h1>
AWS Auto scaling lets us automate and easily scale the Amazon EC2 instances we need using a launch configuration. That launch configuration is our template to the instances that the AWS Auto Scaling will create. Allowing us to create many instance at once without much user involvement.

<h2>Overview:</h2>
By the end of this guide the user will be able to create launch configurations that will be used by the AWS Auto scaling. They will be able to run the Auto Scaling using terraform for some automation.
 
<h2>Prerequisites:</h2>

•	A Linux machine 

•	Terraform Installed

•	AWS access 


<h2>Guide:</h2>

<h3>Pre-Requisites and Launch Configuration</h3>

Terraform will be needed in this guide as that is what we will be using to run the these files. There are a couple of pre-requisites that should be completed in terraform before doing the AWS Auto scaling. This includes having files such as

securitygroup.tf

Provider.tf

With these files we will be able to provide the variables that the launch and AWS Auto Scaling files will be able to reference so it can be easy to change if needed in the future. 

The securitygroup.tf will contain resources that will declare your security groups and what they allow or disallow.

Example :

    resource "aws_security_group" "nameofgroup" {  
      name        = "name"
	    description = "description"
	    vpc_id      = "${aws_vpc.vpcname.id}"

	    ingress {
		  from_port   = 22
		  to_port     = 22
		  protocol    = "tcp"
		  cidr_blocks = ["127.0.0.1/16"]
	  }
	  ingress {
		  from_port   = 80
		  to_port     = 80
		  protocol    = "tcp"
		  cidr_blocks = ["127.0.0.2/16"]
	  }
	  egress {
		  from_port   = 0
		  to_port     = 0
		  protocol    = "-1"
		  cidr_blocks = ["0.0.0.0/0"]
	  }
  }


The provider.tf will contain resources such as vpc declaration and subnet declaration.

Example :

    resource "aws_subnet" "nameofsubnet" {
	    vpc_id     = "${aws_vpc.vpcname.id}"
	    cidr_block = "127.0.0.1"
	    availability_zone = "region"
    tags {
	    Name = "Tagname"
	    }
    }
	

<h3>Launch Configuration</h3>

Create a aws_launch_configuration.tf file

Example : 

    resource "aws_launch_configuration" "NameforyourLaunchConfig" {
	    name = "NameForConfig"
	    image_id = "ReferenceToAMI"
	    instance_type = "t2.micro (InstanceType)"
	    security_groups = ["${aws_security_group.nameofyoursecuritygroup.id}"]
	    key_name = "(keyname)"	
	    lifecycle {
		    create_before_destroy = true
	    }
    }

This is the skeleton to the configuration file and each variable will need to be edited to satisfy your needs. In this instance we have the these variable:

**Name:** Where we name the launch configuration
	
**Image_id:** You can have a variable in another Terraform file that contains the AMI or you can find one in AWS and use that id in this launch configuration.
	
**Instance_type:** Will be based on what AWS offers, we are choosing the free tier (t2.micro)
	
**Security_groups:** This will apply the security group chosen to the Instance we are creating. In this case we are referring to the securitygroup.tf file that contains our security group variable and information.
	
**Key_name:** contains the key that it uses to create the EC2 instance
	
**Lifecycle:** This section destroys the instances that exist after creating the new ones.

<h3>AWS Auto Scaling</h3>

We can append the previous file to keep it concise and add this resource to be able to use the launch configuration

Example : 

    resource "aws_autoscaling_group" "NameofyourASG" {
	    name                 = "NameforASG"
	    launch_configuration = "${aws_launch_configuration.nameofthelaunchconfiguration.name}"
	    vpc_zone_identifier       = ["${aws_subnet.VPCName.id}"]
	    min_size             = 1
	    max_size             = 2
	
	    lifecycle {
	    create_before_destroy = true
	    }
    }

This skeleton is the Auto Scaling file that will reference the Launch configuration in order to build the instances needed. The variables are as follows:
	
**Name:** The name of the Auto Scaling file
	
**Launch_configuration:** This Variable will reference the previous resource, Launch Configuration, for some information needed to build the instances. The variable will be "${aws_launch_configuration.x.name}" where x is the name of the launch configuration.
	
**Vpc_zone_identifier:** This variable will look to your provider to find the VPC we want to use. ["${aws_subnet.x.id}"] where x is the name of the VPC you want to use.
	
**Min_size:** The minimum amount of instances we want to create using this Auto Scaling group.
	
**Max_size:** The maximum amount of instances we want to create using this Auto Scaling group.
	
**Lifecycle:** This section destroys the instances that exist after creating the new ones.

After setting up both files you can run the file in terraform and it will create the instances that can be checked on the AWS console.

<h3>Troubleshooting</h3>

Most errors will come from incorrect references using your variables. Make sure the variables are correct.

Other errors can occur if it doesn't have permission which may occur if you don’t give your secret key and access key to terraform.
Declaring these and exporting them to terraform will solve these errors.
