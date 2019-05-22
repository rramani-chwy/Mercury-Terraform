#
# bastion - data.tf
#
###############################################################################
data "aws_vpc" "bastion_vpc" {
  tags {
    Name = "sandbox-oms"
  }
}

data "aws_iam_policy_document" "bastion_instance_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

data "aws_security_group" "security_group" {
  id = "${aws_security_group.bastion_sg.id}"
}
