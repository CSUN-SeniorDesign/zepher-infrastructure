provider "aws" {
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
	region     = "${var.region}"
}
# Creating group administrators
resource "aws_iam_group" "zephyradmin" {
    name = "zephyradmin"
}

# Creating iam policy to give administrators access 
resource "aws_iam_policy_attachment" "zephyradmin-attach" {
    name = "zephyradmin-attach"
    groups = ["${aws_iam_group.zephyradmin.name}"]
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
# user

# create users
resource "aws_iam_user" "adminusr1" {
    name = "Danielp1"
}
resource "aws_iam_user" "adminusr2" {
    name = "Tonnyp1"
}
resource "aws_iam_user" "adminusr3" {
    name = "Haydenp1"
}
resource "aws_iam_user" "adminusr4" {
    name = "Neelp1"
}
# add users to a group :)

resource "aws_iam_group_membership" "zephyradmin-users" {
    name = "zephyradmin-users"
    users = [
        "${aws_iam_user.adminusr1.name}",
        "${aws_iam_user.adminusr2.name}",
		"${aws_iam_user.adminusr3.name}",
		"${aws_iam_user.adminusr4.name}",

    ]
    group = "${aws_iam_group.zephyradmin.name}"
}