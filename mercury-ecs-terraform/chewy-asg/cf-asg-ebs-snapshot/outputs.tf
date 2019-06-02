output "asg_group_name" {
  value = "${aws_cloudformation_stack.ecs_asg.outputs["AsgName"]}"
}
