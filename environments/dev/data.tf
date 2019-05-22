#
# development - data.tf
#
###############################################################################
data "aws_vpc" "service_vpc" {
  tags {
    Name = "${var.vpc_name}"
  }
}

data "aws_subnet_ids" "public_subnet_ids" {
  vpc_id = "${data.aws_vpc.service_vpc.id}"

  tags = {
    Tier = "public"
  }
}

data "aws_subnet_ids" "private_subnet_ids" {
  vpc_id = "${data.aws_vpc.service_vpc.id}"

  tags = {
    Tier = "private"
  }
}

data "aws_route53_zone" "zone" {
  name         = "${var.dns_domain_name}"
  private_zone = false
}
