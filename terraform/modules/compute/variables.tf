variable "project" {
  description = "Project name used for naming resources"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the IAM role for Lambda execution"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}