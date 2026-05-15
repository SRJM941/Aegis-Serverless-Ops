resource "aws_iam_role" "lambda_exec" {
  name = "${var.project}-lambda-exec"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Principal": { "Service": "lambda.amazonaws.com" },
    "Effect": "Allow"
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "dynamodb" {
  name = "${var.project}-dynamodb-access"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["dynamodb:PutItem","dynamodb:GetItem","dynamodb:Scan"],
    "Resource": "${var.dynamodb_table_arn}"
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.dynamodb.arn
}

