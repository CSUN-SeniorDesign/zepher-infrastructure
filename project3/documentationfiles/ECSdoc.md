# Automating ECS Deployments with Terraform

ECS is:

**a highly scalable, high performance container management service that supports Docker containers and allows you to easily run applications on a managed cluster of Amazon EC2 instances.**

The operative word here being "Easy". 

### IAM Roles

The First thing we need to do before deploying an ECS Cluster is to create IAM roles, and then attach specific policies. The roles are the following:

* [ECS Container Instance IAM Role](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html)
		
		The Amazon ECS container agent makes calls to the Amazon ECS API on your behalf. Container instances that run the agent require an IAM policy 
		and role for the service to know that the agent belongs to you. Before you can launch container instances and register them into a cluster, 
		you must create an IAM role for those container instances to use when they are launched. This requirement applies to container instances 
		launched with the Amazon ECS-optimized AMI provided by Amazon, or with any other instances that you intend to run the agent on.

* [ECS Service Scheduler IAM Role](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/service_IAM_role.html)
	
		The Amazon ECS service scheduler makes calls to the Amazon EC2 and Elastic Load Balancing APIs on your behalf to register and deregister 
		container instances with your load balancers. Before you can attach a load balancer to an Amazon ECS service, you must create an IAM role 
		for your services to use before you start them. This requirement applies to any Amazon ECS service that you plan to use with a load balancer.


[ecsrolepolicy.tf]

```tf
resource "aws_iam_role" "ecs_instance_role" {
    name = "ecs-instance-role"
#   path = "/"
    assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_instance_role1" {
    name = "ecs-instance-role1"
    role = "${aws_iam_role.ecs_instance_role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTelemetrySession",
        "ecs:Submit*",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "ecs_profile" {
    name = "ecs-instance-profile"
    role = "${aws_iam_role.ecs_instance_role.name}"
}
```

[ecsrolepolicy.tf]

```tf

resource "aws_iam_role_policy" "ecs_service_role_policy" {
    name = "ecs_service_role_policy"
    role = "${aws_iam_role.ecs_instance_role.id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:Describe*",
        "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
        "elasticloadbalancing:Describe*",
        "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}
```

### Elastic Container Service

Its time to create an ECS Cluster. In order to create an ECS cluster, we provision the following:

* [Cluster](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ECS_clusters.html)
* [Task Definition](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_definitions.html)
* [Service](http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_services.html)

We can provision these ECS components via the following command.


[project3.tf]
```tf
resource "aws_ecs_cluster" "zephyrecscluster" {
	name = "zephyrecscluster"
}
```

We use the task definition that Hayden created.

```tf
resource "aws_ecs_task_definition" "task1" {
  family = "task1"

  container_definitions = <<DEFINITION
[
  {
    "name": "zephyrdocker",
    "image": "902066483070.dkr.ecr.us-west-2.amazonaws.com/zephyrecr:latest",
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
```

[ecsservice.tf](https://github.com/meshhq/terraform-ecs-cluster/blob/master/ecs/service.tf)

```tf
resource "aws_ecs_service" "service1" {
    name = "test-http"
    cluster = "${aws_ecs_cluster.zephyrecscluster.id}"
    task_definition = "${aws_ecs_task_definition.task1.arn}"
    iam_role = "${aws_iam_role.ecs_instance_role.arn}"
    desired_count = 1
    depends_on = ["aws_iam_role_policy.ecs_service_role_policy"]

    load_balancer {
    target_group_arn = "${aws_alb_target_group.zephyralbtg.arn}"
    container_name   = "zephyrdocker"
    container_port   = "80"
  }
}
```

