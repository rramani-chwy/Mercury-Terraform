variable "environment" { default = "qa" }
#variable "account" {} ## in tfvars
variable "application_name" { default = "orcs" }
variable "contact" { default = "mkarnati_c@@chewy.com" }
variable "region" { default = "us-east-1" }

variable "queue_name" {  type = "list" default = ["maneesh"] }
variable "delay_seconds" {  type = "list" default = [90] }
variable "max_message_size" {  type = "list" default = [2048] }
variable "message_retention_seconds" {  type = "list" default = [86400] }
variable "receive_wait_time_seconds" {  type = "list" default = [10] }
variable "visibility_timeout_seconds" {  type = "list" default = [30] }
variable "dlq_max_receive_count" { type = "list" default = [3] }
variable "fifo_queue" { type = "list" default = [true] }
variable "content_based_deduplication" { type = "list" default = [true] }
