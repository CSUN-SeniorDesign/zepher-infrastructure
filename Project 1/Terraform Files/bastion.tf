resource "aws_security_group" "bastion-securitygroup" {  
  name        = "bastion"
  description = "Allow SSH traffic to bastion"
  vpc_id      = "${aws_vpc.zephyrvpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 }

resource "aws_instance" "bastion" {
    ami = "ami-51537029"
    availability_zone = "us-west-2b"
    instance_type = "t2.micro"
    key_name = "newpair"
    subnet_id = "${aws_subnet.zephyrps2.id}"
    associate_public_ip_address = true
	vpc_security_group_ids  = ["${aws_security_group.bastion-securitygroup.id}"]
depends_on = ["aws_security_group.bastion-securitygroup"]
    tags {
        Name = "Bastion Instance"
    }
}




