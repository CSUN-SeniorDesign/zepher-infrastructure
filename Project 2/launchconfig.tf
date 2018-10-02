resource "aws_launch_configuration" "ASG" {
name = "ASG"
image_id = "ami-0d427646adc2eaa7a"
instance_type = "t2.micro"
security_groups = ["${aws_security_group.linux-securitygroup.id}"]
key_name = "newpair"	
lifecycle {
   create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "bar" {
  name                 = "ubuntunginxdatadog"
  launch_configuration = "${aws_launch_configuration.ASG.name}"
  vpc_zone_identifier       = ["${aws_subnet.zephyrprs1.id}", "${aws_subnet.zephyrprs2.id}","${aws_subnet.zephyrprs3.id}"]

  min_size             = 1
  max_size             = 2

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = "${aws_autoscaling_group.bar.id}"
  alb_target_group_arn   = "${aws_alb_target_group.zephyralbtg.arn}"
}
