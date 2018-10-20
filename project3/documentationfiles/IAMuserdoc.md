# Creating IAM User, Group, Policies for ECS, ECR and CircleCI

In this guide you will learn how to create following:
	IAM User
	IAM Group
	IAM Policy for allowing IAM user acces to create ECR.
	IAM Policy to allow IAM Group to add objects to S3 bucket.
	IAM Role for EC2 to get objects from S3 bucket.

[project3iam.tf]

creating a IAM User

```tf

resource "aws_iam_user" "project3" {
    name = "project3"
}

```

creating a IAM Group

```tf

resource "aws_iam_group" "project3g" {
    name = "project3g"
}

```

Adding IAM User to the IAM Group

```tf

resource "aws_iam_group_membership" "new-users2" {
    name = "new-users2"
    users = [
        "${aws_iam_user.project3.name}"
    ]
    group = "${aws_iam_group.project3g.name}"
}


```

creating a IAM Policy to allow IAM user access to ECR.

```tf

resource "aws_iam_policy" "newpo" {
  name = "newpo"
  
 policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:DescribeRepositories",
			  "ecr:ListImages",
			  "ecr:DescribeImages",
              "ecr:InitiateLayerUpload",
              "ecr:CompleteLayerUpload",
              "ecr:UploadLayerPart",
              "ecr:PutImage"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

```

Attaching the Policy to the Group.

```tf

resource "aws_iam_group_policy_attachment" "attach-policy" {
  group = "${aws_iam_group.project3g.name}"
  policy_arn = "${aws_iam_policy.newpo.arn}"
}

```

creating a IAM Policy for IAM Group to have access to put objects into the S3 bucket created for this project.

```tf

resource "aws_iam_group_policy" "circleci-put" {
  name  = "circleci-put"
  group = "${aws_iam_group.project3g.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:PutObject",
            "Resource": [
              "arn:aws:s3:::zephyrbucketp3/*",
              "arn:aws:s3:::zephyrbucketp3"
              ]
        }
    ]
}
EOF
}

```

creating a IAM Role for EC2.

```tf
resource "aws_iam_role" "role4" {
  name = "role4"

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
```

IAM Policy for the EC2 Role to have access to the S3 bucket to get object and list them.

```tf

resource "aws_iam_policy" "getpolicyec2" {
  name = "getpolicyec2"
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

```

Attaching the policy to the EC2 Role.

```tf

resource "aws_iam_role_policy_attachment" "attachingpolicy2" {
    role       = "${aws_iam_role.role4.name}"
    policy_arn = "${aws_iam_policy.getpolicyec2.arn}"
}
```