output "api_gateway_url" {
  value       = module.compute.api_gateway_url
  description = "The base URL of the REST API"
}

output "lambda_function_arn" {
  value = module.compute.lambda_function_arn
}

output "vpc_id" {
  value = module.networking.vpc_id
}