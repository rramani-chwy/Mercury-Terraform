#
# ecs-service - variables.tf
#
###############################################################################
variable "name" {}

variable "environment" {
  description = "enivorment identifier"
}

variable "vpc_id" {}

variable "iam_service_role_name" {}

variable "desired_task_count" {}

variable "load_balancer_arn" {}

variable "ecs_cluster_id" {}

variable "container_name" {}

variable "image" {}

variable "image_repo_secret_arn" {}

variable "db_host" {}

variable "db_port" {}

variable "inbound_messages" {}

variable "deadletter_inbound_messages" {}

variable "outbound_messages" {}

variable "deadletter_outbound_messages" {}

variable "order_release_details" {}