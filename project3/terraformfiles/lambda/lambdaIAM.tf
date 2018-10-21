resource "aws_iam_role" "lambda" {
  name = "lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambdapolicy" {
  name        = "lambdapolicy"
  path        = "/"
  description = "IAM policy for Lambda to update ECS and read S3"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:*",
        "logs:*",
        "cloudwatch:*",
        "ecs:*",
        "ecr:*",
        "lambda:*",
        "iam:PassRole",
        "events:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambdaattachpolicy" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.lambdapolicy.arn}"
}
