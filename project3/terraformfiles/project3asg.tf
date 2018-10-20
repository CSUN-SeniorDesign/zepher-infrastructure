resource "aws_launch_configuration" "ASG" {
	name = "ASG"
	image_id = "ami-00430184c7bb49914"
	instance_type = "t2.micro"
	security_groups = ["${aws_security_group.linux-securitygroup.id}"]
	key_name = "newpair"
	user_data = "#!/bin/bash\necho ECS_CLUSTER='zephyrecscluster' > /etc/ecs/ecs.config"	
	iam_instance_profile = "${aws_iam_instance_profile.ecs_profile.name}"
	lifecycle {
		create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "bar1" {
  name                 = "bar1"
  launch_configuration = "${aws_launch_configuration.ASG.name}"
  vpc_zone_identifier       = ["${aws_subnet.zephyrprs1.id}", "${aws_subnet.zephyrprs2.id}","${aws_subnet.zephyrprs3.id}"]

  min_size             = 1
  max_size             = 2
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = "${aws_autoscaling_group.bar1.id}"
  alb_target_group_arn   = "${aws_alb_target_group.zephyralbtg.arn}"
}

resource "aws_ecs_task_definition" "task1" {
  family = "task1"

  container_definitions = <<DEFINITION
[
  {
    "name": "zephyrdocker",
    "image": "902066483070.dkr.ecr.us-west-1.amazonaws.com/dockerdanieltest:latest",
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
