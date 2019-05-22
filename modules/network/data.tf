#
# VPC data.tf
#
###############################################################################
data "aws_subnet_ids" "public_subnet_ids" {
  vpc_id = "${aws_vpc.platform_vpc.id}"

  depends_on = [
    "aws_subnet.public_subnet_01",
    "aws_subnet.public_subnet_02",
  ]
}

data "aws_subnet" "public_subnets" {
  count = "${data.aws_subnet_ids.public_subnet_ids.count}"
  id    = "${data.aws_subnet_ids.public_subnet_ids.ids[count.index]}"
}

data "aws_availability_zones" "available" {}
