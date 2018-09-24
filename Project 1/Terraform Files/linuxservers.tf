
resource "aws_security_group" "linux-securitygroup" {  
  name        = "linux"
  description = "Allow SSH traffic to bastion"
  vpc_id      = "${aws_vpc.zephyrvpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 }

resource "aws_instance" "linux1" {
    ami = "ami-51537029"
    availability_zone = "us-west-2a"
    instance_type = "t2.micro"
        key_name = "newpair"
    subnet_id = "${aws_subnet.zephyrprs1.id}"
		vpc_security_group_ids = ["${aws_security_group.linux-securitygroup.id}"]
		
	depends_on = ["aws_security_group.linux-securitygroup"]
	

  
    tags {
        Name = "linux1 Instance"
    }
}
resource "aws_instance" "linux2" {
    ami = "ami-51537029"
    availability_zone = "us-west-2a"
    instance_type = "t2.micro"
    key_name = "newpair"
    subnet_id = "${aws_subnet.zephyrprs.id}"
    vpc_security_group_ids = ["${aws_security_group.linux-securitygroup.id}"]
		
	depends_on = ["aws_security_group.linux-securitygroup"]
	

  
    tags {
        Name = "linux2 Instance"
    }
}



