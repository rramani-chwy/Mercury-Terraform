output "dlq_queue_id" {
  value = "${aws_sqs_queue.dead_letter_queue.*.id}"
}

output "dlq_queue_arn" {
  value = "${aws_sqs_queue.dead_letter_queue.*.arn}"
}

output "dlq_queue_name" {
  value = "${aws_sqs_queue.dead_letter_queue.*.name}"
}

output "main_queue_id" {
  value = "${aws_sqs_queue.main.*.id}"
}

output "main_queue_arn" {
  value = "${aws_sqs_queue.main.*.arn}"
}

output "main_queue_name" {
  value = "${aws_sqs_queue.main.*.name}"
}
