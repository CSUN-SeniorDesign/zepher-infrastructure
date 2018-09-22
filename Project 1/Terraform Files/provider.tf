resource "aws_vpc" "zephyrvpc" {
  cidr_block       = "172.31.0.0/16"
  instance_tenancy = "default"

  tags {
    Name = "zephyrvpc"
  }
}
resource "aws_internet_gateway" "zephyrgw" {
  vpc_id = "${aws_vpc.zephyrvpc.id}"

  tags {
    Name = "zephyrgw"
  }
}
resource "aws_subnet" "zephyrps1" {
  vpc_id     = "${aws_vpc.zephyrvpc.id}"
  cidr_block = "172.31.0.0/22"
  availability_zone = "us-west-2a"

  tags {
    Name = "zephyrps1"
  }
}
resource "aws_subnet" "zephyrps2" {
  vpc_id     = "${aws_vpc.zephyrvpc.id}"
  cidr_block = "172.31.4.0/22"
  availability_zone = "us-west-2b"


  tags {
    Name = "zephyrps2"
  }
}
resource "aws_subnet" "zephyrps3" {
  vpc_id     = "${aws_vpc.zephyrvpc.id}"
  cidr_block = "172.31.8.0/22"
    availability_zone = "us-west-2c"


  tags {
    Name = "zephyrps3"
  }
}
resource "aws_route_table" "zephyrprt" {
  vpc_id = "${aws_vpc.zephyrvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.zephyrgw.id}"
  }


  tags {
    Name = "zephyrprt"
  }
}
resource "aws_route_table_association" "zephyrpa1" {
  subnet_id      = "${aws_subnet.zephyrps1.id}"
  route_table_id = "${aws_route_table.zephyrprt.id}"
}
resource "aws_route_table_association" "zephyrpa2" {
  subnet_id      = "${aws_subnet.zephyrps2.id}"
  route_table_id = "${aws_route_table.zephyrprt.id}"
}
resource "aws_route_table_association" "zephyrpa3" {
  subnet_id      = "${aws_subnet.zephyrps3.id}"
  route_table_id = "${aws_route_table.zephyrprt.id}"
}
resource "aws_subnet" "zephyrprs1" {
  vpc_id     = "${aws_vpc.zephyrvpc.id}"
  cidr_block = "172.31.16.0/20"
    availability_zone = "us-west-2a"


  tags {
    Name = "zephyrprs1"
  }
}
resource "aws_subnet" "zephyrprs2" {
  vpc_id     = "${aws_vpc.zephyrvpc.id}"
  cidr_block = "172.31.32.0/20"
    availability_zone = "us-west-2b"


  tags {
    Name = "zephyrprs2"
  }
}
resource "aws_subnet" "zephyrprs3" {
  vpc_id     = "${aws_vpc.zephyrvpc.id}"
  cidr_block = "172.31.48.0/20"
    availability_zone = "us-west-2c"


  tags {
    Name = "zephyrprs3"
  }
}
resource "aws_route_table" "zephyrprrt" {
  vpc_id = "${aws_vpc.zephyrvpc.id}"
	route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }
  tags {
    Name = "zephyrprrt"
  }
}
resource "aws_route_table_association" "zephyrpra1" {
  subnet_id      = "${aws_subnet.zephyrprs1.id}"
  route_table_id = "${aws_route_table.zephyrprrt.id}"
}
resource "aws_route_table_association" "zephyrpra2" {
  subnet_id      = "${aws_subnet.zephyrprs2.id}"
  route_table_id = "${aws_route_table.zephyrprrt.id}"
}
resource "aws_route_table_association" "zephyrpra3" {
  subnet_id      = "${aws_subnet.zephyrprs3.id}"
  route_table_id = "${aws_route_table.zephyrprrt.id}"
}