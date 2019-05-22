#
# ecs data.tf
#
###############################################################################
data "aws_iam_policy_document" "ecs-instance-policy" {
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

data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ecs.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${aws_iam_instance_profile.ecs-instance-profile.name}"

  depends_on = [
    "aws_iam_instance_profile.ecs-instance-profile",
  ]
}

data "aws_iam_role" "ecs-service-role" {
  name = "${aws_iam_role.ecs-service-role.name}"

  depends_on = [
    "aws_iam_role.ecs-service-role",
  ]
}

data "aws_iam_role" "ecs-instance-role" {
  name = "${aws_iam_role.ecs-instance-role.name}"

  depends_on = [
    "aws_iam_role.ecs-instance-role",
  ]
}

data "aws_security_group" "ecs_security_group" {
  id = "${aws_security_group.ecs_security_group.id}"
}

data "template_file" "init" {
  template = "${file(format("%s/%s",path.module, "templates/cloud-init.sh"))}"

  vars {
    cluster_name = "${aws_ecs_cluster.ecs_cluster.name}"
  }
}

data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = "${aws_ecs_cluster.ecs_cluster.name}"
}
