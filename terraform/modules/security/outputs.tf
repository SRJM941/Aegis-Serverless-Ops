output "lambda_role_arn" {
  value       = aws_iam_role.lambda_exec.arn
  description = "ARN of the Lambda execution role"
}

output "lambda_role_name" {
  value       = aws_iam_role.lambda_exec.name
  description = "Name of the Lambda execution role"
}