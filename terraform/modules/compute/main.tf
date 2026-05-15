resource "aws_dynamodb_table" "items" {
  name         = "${var.project}-items"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  # TFSEC FIX: Encryption at rest enabled
  server_side_encryption {
    enabled = true
  }

  # TFSEC FIX: Point-in-time recovery enabled
  point_in_time_recovery {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true  # protection
  }

  tags = var.tags
}

resource "aws_lambda_function" "api" {
  filename         = "${path.module}/lambda_code.zip"
  function_name    = "${var.project}-handler"
  role             = var.lambda_role_arn
  handler          = "index.handler"
  runtime          = "python3.9"
  source_code_hash = filebase64sha256("${path.module}/lambda_code.zip")

  # TFSEC FIX: Active tracing via X-Ray enabled
  tracing_config {
    mode = "Active"
  }

  lifecycle {
    ignore_changes = [source_code_hash]
  }
}

resource "aws_apigatewayv2_api" "http" {
  name          = "${var.project}-api"
  protocol_type = "HTTP"
}

# TFSEC FIX: Dedicated Log Group for API Gateway Access Logs
resource "aws_cloudwatch_log_group" "api_gw_logs" {
  name              = "/aws/apigateway/${var.project}-access-logs"
  retention_in_days = 7
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http.id
  name        = "$default"
  auto_deploy = true

  # TFSEC FIX: Access Logging Block Configured
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_logs.arn
    format          = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      routeKey       = "$context.routeKey"
      status         = "$context.status"
      responseLength = "$context.responseLength"
    })
  }
}

resource "aws_apigatewayv2_integration" "lambda" {
  api_id           = aws_apigatewayv2_api.http.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.api.invoke_arn
}

resource "aws_apigatewayv2_route" "get_items" {
  api_id    = aws_apigatewayv2_api.http.id
  route_key = "GET /items"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http.execution_arn}/*/*"
}