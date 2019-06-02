# IAM role and policies
resource "aws_iam_role" "role" {
  name               = "${var.name}_role"
  assume_role_policy = "${var.role}"
}

# service scheduler role
resource "aws_iam_role_policy" "role_policy" {
  name     = "${var.name}_role_policy"
  policy   = "${var.role_policy}"
  role     = "${aws_iam_role.role.id}"
}

# for apps using Storage GW File share S3 buckets
resource "aws_iam_role_policy" "extra_policies" {
  count    = "${length(var.extra_policies)}"
  name     = "${var.name}-${element(var.extra_policy_names, count.index)}"
  policy   = "${element(var.extra_policies, count.index)}"
  role     = "${aws_iam_role.role.id}"
}

# IAM profile to be used in auto-scaling launch configuration
resource "aws_iam_instance_profile" "profile" {
  count = "${var.create_instance_profile == "true" ? 1 : 0}"
  name = "${var.name}_profile"
  path = "/"
  role = "${aws_iam_role.role.name}"
}
