resource "aws_security_group" "nat-securitygroup" {  
  name        = "nat"
  description = "Allow traffic to pass from the private subnet to the internet"
  vpc_id      = "${aws_vpc.zephyrvpc.id}"
 

  ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["172.31.16.0/20","172.31.32.0/20","172.31.48.0/20"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
		cidr_blocks = ["172.31.16.0/20","172.31.32.0/20","172.31.48.0/20"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["172.31.0.0/16"]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "NAT securitygroup"
    }


 }

resource "aws_instance" "nat" {
    ami = "ami-40d1f038"
    availability_zone = "us-west-2a"
    instance_type = "t2.micro"
       key_name = "newpair"
    subnet_id = "${aws_subnet.zephyrps1.id}"
    associate_public_ip_address = true
	vpc_security_group_ids = ["${aws_security_group.nat-securitygroup.id}"]
	source_dest_check = false
	depends_on = ["aws_security_group.nat-securitygroup"]
    tags {
        Name = "Nat Instance"
    }
}

resource "aws_eip" "nat" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}



