#
# bastion - main.tf
#
###############################################################################
locals {
  prefix = "${terraform.workspace == "default" ? var.environment : terraform.workspace}"
}

resource "aws_launch_configuration" "bastion_launch_cfg" {
  name_prefix          = "${var.bastion_name_prefix}-launch-cfg-"
  image_id             = "${var.bastion_image_id}"
  instance_type        = "${var.bastion_instance_type}"
  iam_instance_profile = "${aws_iam_instance_profile.bastion_instance_profile.id}"

  root_block_device {
    volume_type           = "${var.bastion_root_vol_type}"
    volume_size           = "${var.bastion_root_vol_size}"
    delete_on_termination = true
  }

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  security_groups = [
    "${aws_security_group.bastion_sg.id}",
  ]

  key_name                    = "${aws_key_pair.ecs_key_pair.key_name}"
  associate_public_ip_address = "true"
  user_data                   = "${file(format("%s/%s",path.module, "firstboot/cloud-init.sh"))}"
}

resource "aws_autoscaling_group" "bastion_asg" {
  name             = "${aws_launch_configuration.bastion_launch_cfg.name}-asg"
  max_size         = "${var.bastion_asg_max_size}"
  min_size         = "${var.bastion_asg_min_size}"
  desired_capacity = "${var.bastion_asg_desired_size}"

  vpc_zone_identifier = [
    "${var.bastion_vpc_zone_subnet_ids}",
  ]

  launch_configuration = "${aws_launch_configuration.bastion_launch_cfg.id}"
  health_check_type    = "ELB"

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${var.bastion_name_prefix}"
  }

  tag {
    key                 = "Environment"
    propagate_at_launch = true
    value               = "${var.environment}"
  }

  tag {
    key                 = "Terraform"
    propagate_at_launch = true
    value               = "true"
  }
}

resource "aws_key_pair" "ecs_key_pair" {
  key_name   = "${local.prefix}-${var.bastion_ssh_key_name}"
  public_key = "${var.bastion_ssh_public_key}"
}

resource "aws_iam_role" "bastion_instance_role" {
  name               = "${var.bastion_name_prefix}-instance-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.bastion_instance_policy.json}"
}

resource "aws_iam_role_policy_attachment" "bastion_instance_role_attachment" {
  role       = "${aws_iam_role.bastion_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "bastion_role_ssm_attachment" {
  role       = "${aws_iam_role.bastion_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name_prefix = "${var.bastion_name_prefix}-instance-profile"
  path        = "/"
  role        = "${aws_iam_role.bastion_instance_role.id}"

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

resource "aws_security_group" "bastion_sg" {
  name_prefix = "${var.bastion_name_prefix}"
  vpc_id      = "${data.aws_vpc.bastion_vpc.id}"
  description = "Bastion host security group"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = "${var.bastion_sg_chewy_cidrs}"
  }

  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  tags {
    Name        = "${var.bastion_name_prefix}-sg"
    Environment = "${var.environment}"
    Terraform   = true
  }
}
