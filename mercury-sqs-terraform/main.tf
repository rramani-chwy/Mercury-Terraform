provider "aws" {
  region  = "${var.region}"
#  profile = "${var.account}"
}

# Init
terraform {
  backend "s3" {
    bucket         = "orcs-sandbox"
    dynamodb_table = "terraform"
    region         = "us-east-1"
  }
}

# Current Account ID
data "aws_caller_identity" "current" {}

# Provider aws was removed from the modules to enable multiple account configuration

resource "aws_sqs_queue" "dead_letter_queue" {
  count                      = "${length(var.queue_name)}.fifo"
  name                       = "${var.application_name}-${element(var.queue_name, count.index)}-${var.environment}-dlq"
  delay_seconds              = "${element(var.delay_seconds, count.index)}"
  max_message_size           = "${element(var.max_message_size, count.index)}"
  message_retention_seconds  = "${element(var.message_retention_seconds, count.index)}"
  receive_wait_time_seconds  = "${element(var.receive_wait_time_seconds, count.index)}"
  visibility_timeout_seconds = "${element(var.visibility_timeout_seconds, count.index)}"
  fifo_queue                  = true
  content_based_deduplication = true
}

resource "aws_sqs_queue" "main" {
  count                      = "${length(var.queue_name)}.fifo"
  name                       = "${var.application_name}-${element(var.queue_name, count.index)}-${var.environment}"
  delay_seconds              = "${element(var.delay_seconds, count.index)}"
  max_message_size           = "${element(var.max_message_size, count.index)}"
  message_retention_seconds  = "${element(var.message_retention_seconds, count.index)}"
  receive_wait_time_seconds  = "${element(var.receive_wait_time_seconds, count.index)}"
  visibility_timeout_seconds = "${element(var.visibility_timeout_seconds, count.index)}"
  fifo_queue                  = "${element(var.fifo_queue, count.index)}"
  content_based_deduplication = "${element(var.content_based_deduplication, count.index)}"
  #redrive_policy             = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead_letter_queue.*.arn}\",\"maxReceiveCount\": ${var.dlq_max_receive_count} }"
}
