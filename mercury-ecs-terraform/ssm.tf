
# Gather inventory from instances every 4 hours
resource "aws_ssm_association" "gather_inventory" {
  name = "AWS-GatherSoftwareInventory"

  targets {
    key = "tag:Name"
    values = ["${var.cluster_name}-${var.environment}-asg"]
  }

  schedule_expression = "rate(4 hours)"
}

# Every Tuesday morning (UTC) enter a maintenance window
resource "aws_ssm_maintenance_window" "patching" {
  name     = "${var.cluster_name}-${var.environment}-maintenance-window"
  schedule = "cron(0 1 ? * TUE *)"
  duration = 3
  cutoff   = 1
}

resource "aws_ssm_maintenance_window_target" "ecs_container_instances" {
  window_id     = "${aws_ssm_maintenance_window.patching.id}"
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Name"
    values = ["${var.cluster_name}-${var.environment}-asg"]
  }
}

# Scan and install system patches
resource "aws_ssm_maintenance_window_task" "system_patching" {
  window_id        = "${aws_ssm_maintenance_window.patching.id}"
  name             = "patch-os"
  description      = "Install System Patches"
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = "arn:aws:iam::953164603717:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  max_concurrency  = "1"
  max_errors       = "1"

  targets {
    key    = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.ecs_container_instances.id}"]
  }

  task_parameters {
    name   = "Operation"
    values = ["Install"]
  }
}

# Update SSM Agent
resource "aws_ssm_maintenance_window_task" "update_ssm_agent" {
  window_id        = "${aws_ssm_maintenance_window.patching.id}"
  name             = "update-ssm-agent"
  description      = "Update SSM Agent"
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-UpdateSSMAgent"
  priority         = 1
  service_role_arn = "arn:aws:iam::953164603717:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM"
  max_concurrency  = "1"
  max_errors       = "1"

  targets {
    key    = "WindowTargetIds"
    values = ["${aws_ssm_maintenance_window_target.ecs_container_instances.id}"]
  }
}
