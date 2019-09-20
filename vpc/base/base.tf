resource "aws_vpc" "default" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.region}"
    VPC  = "${var.region}"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "${var.region}_${aws_vpc.default.id}"
    VPC  = "${var.region}_${aws_vpc.default.id}"
  }
}

/*
  Public Subnet
*/
resource "aws_subnet" "router_a_subnet_g1" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.subnet_public_a}"
  availability_zone = "${var.availability_zone_a}"

  tags = {
    Name = "subnet_public"
    VPC  = "${var.region}_${var.availability_zone_a}_public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

  tags = {
    Name = "Public Subnets"
    VPC  = "${var.region}_${aws_vpc.default.id}"
  }
}

resource "aws_route_table_association" "public_rt_public_a" {
  subnet_id      = "${aws_subnet.router_a_subnet_g1.id}"
  route_table_id = "${aws_route_table.public.id}"
}

/*
  Private Subnet
*/
resource "aws_subnet" "router_a_subnet_g2" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.subnet_private_a}"
  availability_zone = "${var.availability_zone_a}"

  tags = {
    Name = "subnet_private"
    VPC  = "${var.region}_${var.availability_zone_a}_private"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "route table private"
    VPC  = "${var.region}_${aws_vpc.default.id}_private"
  }
}

resource "aws_route_table_association" "private_rt_private_a" {
  subnet_id      = "${aws_subnet.router_a_subnet_g2.id}"
  route_table_id = "${aws_route_table.private.id}"
}

/*
  Security Groups - SG_SSH_IPSEC, SG_SSH, SG_All_Traffic
*/
resource "aws_security_group" "SG_SSH_IPSEC" {
  name        = "SG_SSH_IPSEC"
  description = "Allow Traffic into the CSR1000v"

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "50"
    cidr_blocks = ["${var.cidr_block}"]
  }

  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "SG_SSH_IPSEC"
    VPC  = "${var.region}"
  }
}

resource "aws_security_group" "SG_SSH" {
  name        = "SG_SSH"
  description = "Only SSH incoming"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "SG_SSH"
    VPC  = "${var.region}"
  }
}

resource "aws_security_group" "SG_All_Traffic" {
  name        = "SG_All_Traffic"
  description = "Allow Traffic into the G2 CSR1000v"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "SG_All_Traffic"
    VPC  = "${var.region}"
  }
}
