#
# vpc.tf
#
###############################################################################
resource "aws_vpc" "platform_vpc" {
  cidr_block = "${var.cidr}"

  tags = {
    Name = "${var.name}-${var.env}"
  }
}

# Internet gateway for the public subnet
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.platform_vpc.id}"

  tags {
    Name = "${var.name}-www-gateway-${var.env}"
  }
}

# Public subnet
resource "aws_subnet" "public_subnet_01" {
  vpc_id            = "${aws_vpc.platform_vpc.id}"
  cidr_block        = "${var.public_subnets[0]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "${var.name}-www-subnet_01-${var.env}"
  }
}

# Public subnet 2
resource "aws_subnet" "public_subnet_02" {
  vpc_id            = "${aws_vpc.platform_vpc.id}"
  cidr_block        = "${var.public_subnets[1]}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "${var.name}-www-subnet_02-${var.env}"
  }
}

# Private subnet
resource "aws_subnet" "private_subnet_01" {
  vpc_id            = "${aws_vpc.platform_vpc.id}"
  cidr_block        = "${var.public_subnets[0]}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "${var.name}-subnet_01-${var.env}"
  }
}

# Private subnet 2
resource "aws_subnet" "private_subnet_02" {
  vpc_id            = "${aws_vpc.platform_vpc.id}"
  cidr_block        = "${var.public_subnets[1]}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "${var.name}-subnet_02-${var.env}"
  }
}

# Routing table for public subnet #1
resource "aws_route_table" "www_subnet_01_route_table" {
  vpc_id = "${aws_vpc.platform_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags {
    Name = "${var.name}-www-route-subnet_01-${var.env}"
  }
}

# Routing table for public subnet #2
resource "aws_route_table" "www_subnet_02_route_table" {
  vpc_id = "${aws_vpc.platform_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags {
    Name = "${var.name}-www-route-subnet_02-${var.env}"
  }
}

# Routing table for private subnet #1
resource "aws_route_table" "subnet_01_route_table" {
  vpc_id = "${aws_vpc.platform_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
  }

  tags {
    Name = "${var.name}-route-subnet_01-${var.env}"
  }
}

# Routing table for private subnet #2
resource "aws_route_table" "subnet_02_route_table" {
  vpc_id = "${aws_vpc.platform_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
  }

  tags {
    Name = "${var.name}-route-subnet_02-${var.env}"
  }
}

# Associate the routing table to public subnet 1
resource "aws_route_table_association" "subnet_01_route_table_assoc" {
  subnet_id      = "${aws_subnet.public_subnet_01.id}"
  route_table_id = "${aws_route_table.www_subnet_01_route_table.id}"
}

# Associate the routing table to public subnet 2
resource "aws_route_table_association" "subnet_02_route_table_assoc" {
  subnet_id      = "${aws_subnet.public_subnet_02.id}"
  route_table_id = "${aws_route_table.www_subnet_02_route_table.id}"
}

# Associate the routing table to public subnet 1
resource "aws_route_table_association" "subnet_03_route_table_assoc" {
  subnet_id      = "${aws_subnet.private_subnet_01.id}"
  route_table_id = "${aws_route_table.subnet_01_route_table.id}"
}

# Associate the routing table to public subnet 2
resource "aws_route_table_association" "subnet_04_route_table_assoc" {
  subnet_id      = "${aws_subnet.private_subnet_02.id}"
  route_table_id = "${aws_route_table.subnet_02_route_table.id}"
}
