resource "aws_security_group" "zephyralbsg" {  
  name        = "zephyralbsg"
  description = "allow port 80 access"
  vpc_id      = "${aws_vpc.zephyrvpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
        Name = "zephyr alb"
    }
  
 }
 resource "aws_alb" "zephyralb"{
 name = "zephyralb"
 internal = false
 security_groups = ["${aws_security_group.zephyralbsg.id}"]
 depends_on = ["aws_security_group.zephyralbsg"]
 subnets = ["${aws_subnet.zephyrps1.id}","${aws_subnet.zephyrps2.id}","${aws_subnet.zephyrps3.id}"]
 }
 
 resource "aws_alb_target_group" "zephyralbtg" {
	name	= "zephyralbtg"
	vpc_id	= "${aws_vpc.zephyrvpc.id}"
	port	= "80"
	protocol	= "HTTP"
	depends_on = ["aws_alb.zephyralb"]
	health_check {
                path = "/"
                port = "80"
                protocol = "HTTP"
                healthy_threshold = 5
                unhealthy_threshold = 2
                interval = 30
                timeout = 5
                matcher = "200"
        }
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.zephyralb.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.zephyralbtg.arn}"
  }
}
resource "aws_alb_target_group_attachment" "zephyralbattach1" {
  target_group_arn = "${aws_alb_target_group.zephyralbtg.arn}"
  target_id        = "${aws_instance.linux1.id}"
  port             = 80
  depends_on = ["aws_alb.zephyralb"]
}
resource "aws_alb_target_group_attachment" "zephyralbattach2" {
  target_group_arn = "${aws_alb_target_group.zephyralbtg.arn}"
  target_id        = "${aws_instance.linux2.id}"
  port             = 80
  depends_on = ["aws_alb.zephyralb"]
}
resource "aws_route53_record" "alias_route53_record" {
  zone_id = "Z1GFVUABNAOPNR"
   name    = "zephyr90.com"
  type    = "A"

  alias {
    name                   = "${aws_alb.zephyralb.dns_name}"
    zone_id                = "${aws_alb.zephyralb.zone_id}"
    evaluate_target_health = true
  }
}