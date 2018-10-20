resource "aws_iam_group" "project3g" {
    name = "project3g"
}
resource "aws_iam_user" "project3" {
    name = "project3"
}
resource "aws_iam_group_membership" "new-users2" {
    name = "new-users2"
    users = [
        "${aws_iam_user.project3.name}"
    ]
    group = "${aws_iam_group.project3g.name}"
}

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
resource "aws_iam_group_policy_attachment" "attach-policy" {
  group = "${aws_iam_group.project3g.name}"
  policy_arn = "${aws_iam_policy.newpo.arn}"
}
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
resource "aws_iam_role_policy_attachment" "attachingpolicy2" {
    role       = "${aws_iam_role.role4.name}"
    policy_arn = "${aws_iam_policy.getpolicyec2.arn}"
}
