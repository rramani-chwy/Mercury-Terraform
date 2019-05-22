#
# SQS Queues
#

resource "aws_sqs_queue" "inbound_messages" {
  name                        = "inbound.fifo"
  content_based_deduplication = "true"
  delay_seconds               = "0"
  fifo_queue                  = "true"
  max_message_size            = "32768"
  message_retention_seconds   = "345600"
  receive_wait_time_seconds   = "20"
  redrive_policy              = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.deadletter_inbound_messages.arn}\",\"maxReceiveCount\":5}"
  visibility_timeout_seconds  = "120"
}

resource "aws_sqs_queue" "deadletter_inbound_messages" {
  name                        = "inbound-deadletter.fifo"
  content_based_deduplication = "true"
  delay_seconds               = "0"
  fifo_queue                  = "true"
  max_message_size            = "32768"
  message_retention_seconds   = "345600"
  receive_wait_time_seconds   = "20"
  visibility_timeout_seconds  = "120"
}

resource "aws_sqs_queue" "outbound_messages" {
  name                        = "outbound.fifo"
  content_based_deduplication = "true"
  delay_seconds               = "0"
  fifo_queue                  = "true"
  max_message_size            = "32768"
  message_retention_seconds   = "345600"
  receive_wait_time_seconds   = "20"
  redrive_policy              = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.deadletter_outbound_messages.arn}\",\"maxReceiveCount\":5}"
  visibility_timeout_seconds  = "120"
}

resource "aws_sqs_queue" "deadletter_outbound_messages" {
  name                        = "outbound-deadletter.fifo"
  content_based_deduplication = "true"
  delay_seconds               = "0"
  fifo_queue                  = "true"
  max_message_size            = "32768"
  message_retention_seconds   = "345600"
  receive_wait_time_seconds   = "20"
  visibility_timeout_seconds  = "120"
}
