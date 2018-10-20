<h1>Overview: </h1>
This guide will demonstrate and explain how to set up an Autoscaling Group for ECS as well as a task-definition to load dockerfiles.

<h2>Prerequisites: </h2>

Terraform Installed

AWS access

An ASG. Because there is not much difference between an ASG that can handle and ECS and one that can't, please refer to the previously written: https://github.com/CSUN-SeniorDesign/zephyr-infrastructure/blob/master/Project%202/Documentation%20Files/Launch_Config.md for guidance in setting one up.

<h2>Guide: </h2>


<h3>ECS: </h3>

Instantiating an ECS is done simply using:

resource "aws_ecs_cluster" "zephyrcluster" {
name = "zephyrcluster"
}

<h3>ASG Alterations: </h3>

There are 3 things you need to add to make the ASG usable for an ECS. Add these lines to the 'resource "aws_launch_configuration"' block of your code

image_id:
	Go to this url: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html and choose an ECS-Optimized Linux ami for your desired region

user_data = "#!/bin/bash\necho ECS_CLUSTER='clusterName' > /etc/ecs/ecs.config"
	This line will allow the ECS to pick up the instance generated
	
iam_instance_profile = "${aws_iam_instance_profile.profileName.name}"
	This line will connect to a previously made ecs-roles profile in order to set up the permissions necessary for the instance to communicate with the ECS
	
	
<h3>Task-definition: </h3>

This directs the ECS to do something. In this case, uploading our dockerfile

resource "aws_ecs_task_definition" "task1" {
  family = "task1"

  container_definitions = <<DEFINITION
[
  {
    "name": "zephyrdocker",
    "image": "docker-image-link",
    "cpu": 10,
    "memory": 500,
    "portMappings": [
     {
       "containerPort": 80,
       "hostPort": 80,
	   "protocol": "tcp"
     }
     ],
     "essential": true
  }
]
DEFINITION
}

container_definitions: can point to a file on your system, or in this case, the text until DEFINITION comes up again in the file
name: the name of the file being uploaded
image: a tagged link to the file being uploaded; found in the dockerfile itself, or can extend to the ECR it is held in
cpu: the number of cpu units the task is allowed to use (default is 10)
memory: the number of memory units the task is allowed to use (default is 500)
portMappings: what ports the task will be working with
containerPort: the inbound port on the ECS
hostPort: the outbound port of the host where the dockerfile is located
protocol: tcp or udp
essential: this task needs to be run

<h3>Troubleshooting: </h3>

The task-definition section is effectively JSON script and is very particular with it's formatting. This will likely cause obtuse errors to appear. Be sure to wach your use of commas and brackets when writing it, even copying it as indentation can cause errors. This website: https://jsonformatter.curiousconcept.com/ helped to check my formatting and could be a major help to you when writing it.