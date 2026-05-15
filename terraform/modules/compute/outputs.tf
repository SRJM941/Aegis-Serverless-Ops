output "api_gateway_url" {
  value       = aws_apigatewayv2_stage.default.invoke_url
  description = "Base URL of the HTTP API"
}

output "lambda_function_arn" {
  value       = aws_lambda_function.api.arn
  description = "ARN of the Lambda function"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.items.name
  description = "Name of the DynamoDB table"
}

output "dynamodb_table_arn" {
  value       = aws_dynamodb_table.items.arn
  description = "ARN of the DynamoDB table"
}