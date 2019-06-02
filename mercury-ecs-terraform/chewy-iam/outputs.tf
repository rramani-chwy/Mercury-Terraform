output "iam_instance_profile" {
  value = "${element(concat(aws_iam_instance_profile.profile.*.id, list("")), 0)}"
}

output "role_name" {
  value = "${aws_iam_role.role.name}"
}

output "role_arn" {
  value = "${aws_iam_role.role.arn}"
}
