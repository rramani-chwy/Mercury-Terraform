#
# VPC outputs.tf
#
###############################################################################
output "orc_vpc_id" {
  value = "${aws_vpc.platform_vpc.id}"
}

output "orc_vpc_name" {
  value = "${aws_vpc.platform_vpc.tags["Name"]}"
}

output "public_subnet" {
  value = "${var.public_subnets}"
}

output "public_subnet_ids" {
  value = "${data.aws_subnet_ids.public_subnet_ids.ids}"
}

output "public_subnet_cidr_blocks" {
  value = "${data.aws_subnet.public_subnets.*.cidr_block}"
}
