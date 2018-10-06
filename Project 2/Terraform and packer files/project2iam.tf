resource "aws_iam_group" "circleci" {
    name = "circleci"
}
resource "aws_iam_user" "zephyr1" {
    name = "zephyr1"
}
resource "aws_iam_group_membership" "new-users" {
    name = "new-users"
    users = [
        "${aws_iam_user.zephyr1.name}"
    ]
    group = "${aws_iam_group.circleci.name}"
}
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
resource "aws_iam_role_policy_attachment" "attachingpolicy" {
    role       = "${aws_iam_role.role.name}"
    policy_arn = "${aws_iam_policy.getpolicyforec2.arn}"
}
