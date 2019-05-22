
# Launch configuration used by autoscaling group
resource "aws_launch_configuration" "config" {
  name_prefix          = "${var.name}-config-"
  image_id             = "${var.ecs_ami}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_name}"              # Need SRE to configure
  iam_instance_profile = "${var.iam_instance_profile}"
  security_groups      = ["${var.aws_security_groups}"]
  user_data            = "${var.instance_user_data}"

  lifecycle {
    create_before_destroy = true
  }

  ebs_block_device {
    device_name           = "${var.ebs_device_name}"
    volume_type           = "${var.ebs_vol_type}"
    volume_size           = "${var.ebs_vol_size}"
    delete_on_termination = "${var.ebs_delete_on_termination}"
    snapshot_id           = "${var.ebs_snapshot_id}"
  }
}

# Creates an autoscaling group with an UpdatePolicy for rolling launch config updates
# See:
# - https://aws.amazon.com/premiumsupport/knowledge-center/auto-scaling-group-rolling-updates/
# - https://github.com/hashicorp/terraform/issues/1552#issuecomment-191847434
# - http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-group.html
#
# Possible opportunity for an active wait/notify approach, instead of using an arbitrary UpdatePolicy pauseTime.
# See: http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-waitcondition.html
resource "aws_cloudformation_stack" "ecs_asg" {
  name = "${var.name}"

  template_body = <<EOF
{
  "Resources": {
    "Asg": {
      "Type": "AWS::AutoScaling::AutoScalingGroup",
      "Properties": {
        "VPCZoneIdentifier": ["${join("\",\"", split(",", var.ecs_subnets))}"],
        "LaunchConfigurationName": "${aws_launch_configuration.config.name}",
        "MinSize": "${var.asg_min_size}",
        "MaxSize": "${var.asg_max_size}",
        "HealthCheckGracePeriod": "${var.health_check_grace_period}",
        "TerminationPolicies": ["${join("\",\"", var.asg_termination_policies)}"],
        "MetricsCollection": [{
          "Granularity" : "${var.asg_metrics_granularity}",
          "Metrics" : ["${join("\",\"", var.asg_metrics)}"]
        }],
        "Tags": [{
            "ResourceType": "auto-scaling-group",
            "ResourceId": "Asg",
            "PropagateAtLaunch": true,
            "Value": "${var.name}-asg",
            "Key": "Name"
          }, {
            "ResourceType": "auto-scaling-group",
            "ResourceId": "Asg",
            "PropagateAtLaunch": true,
            "Value": "${var.environment}",
            "Key": "environment"
          }, {
            "ResourceType": "auto-scaling-group",
            "ResourceId": "Asg",
            "PropagateAtLaunch": true,
            "Value": "${var.ecs_cluster_name}",
            "Key": "ecs_cluster_name"
          }]
      },
      "UpdatePolicy": {
        "AutoScalingRollingUpdate": {
          "MinInstancesInService": "${var.asg_update_policy_min_instances}",
          "MaxBatchSize": "${var.asg_update_policy_max_batch}",
          "PauseTime": "${var.asg_update_policy_pause_time}",
          "SuspendProcesses": ["${join("\",\"", var.asg_update_policy_suspend_processes)}"]
        }
      }
    }
  },
  "Outputs": {
    "AsgName": {
      "Description": "The name of the auto scaling group",
      "Value": {"Ref": "Asg"}
    }
  }
}
EOF

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    update = "${var.update_time_out}"
  }
}

resource "aws_autoscaling_lifecycle_hook" "asg_terminate_hook" {
  count = "${length(var.asg_lifecycle_sqs_arn) > 0 && length(var.asg_lifecycle_role_arn) > 0 ? 1 : 0}"
  autoscaling_group_name = "${aws_cloudformation_stack.ecs_asg.outputs["AsgName"]}"
  lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
  name = "${var.name}-asg-terminate-hook-${var.environment}"
  default_result = "CONTINUE"
  heartbeat_timeout = "${var.asg_terminate_lifecycle_heartbeat_timeout}"

  notification_target_arn = "${var.asg_lifecycle_sqs_arn}"
  role_arn = "${var.asg_lifecycle_role_arn}"
}

resource "aws_autoscaling_lifecycle_hook" "asg_launch_hook" {
  count = "${length(var.asg_lifecycle_sqs_arn) > 0 && length(var.asg_lifecycle_role_arn) > 0 ? 1 : 0}"
  autoscaling_group_name = "${aws_cloudformation_stack.ecs_asg.outputs["AsgName"]}"
  lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  name = "${var.name}-asg-launch-hook-${var.environment}"
  default_result = "CONTINUE"
  heartbeat_timeout = "${var.asg_launch_lifecycle_heartbeat_timeout}"

  notification_target_arn = "${var.asg_lifecycle_sqs_arn}"
  role_arn = "${var.asg_lifecycle_role_arn}"
}
