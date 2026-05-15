variable "project" {
  type        = string
  description = "Project prefix name"
}

variable "dynamodb_table_arn" {
  type        = string
  description = "Target DynamoDB Table ARN to clear wildcard constraints"
}