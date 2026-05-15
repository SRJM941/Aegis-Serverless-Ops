resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.tags, { Name = "${var.project}-vpc" })
}

resource "aws_subnet" "public" {
  for_each = { for idx, az in var.azs : idx => az }
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.key)
  availability_zone = each.value
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "${var.project}-public-${each.value}" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "${var.project}-igw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, { Name = "${var.project}-public-rt" })
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# IAM role for VPC Flow Logs
resource "aws_iam_role" "flow_log_role" {
  name = "${var.project}-flow-log-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "vpc-flow-logs.amazonaws.com" }
    }]
  })
  tags = var.tags
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_role_policy" "flow_log_policy" {
  name = "${var.project}-flow-log-policy"
  role = aws_iam_role.flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "${aws_cloudwatch_log_group.flow_log.arn}:*" # Fix Result #2 Wildcard constraint
    }]
  })
}
#tfsec:ignore:aws-cloudwatch-log-group-customer-key
resource "aws_cloudwatch_log_group" "flow_log" {
  name              = "/aws/vpc/flow-log/${var.project}"
  retention_in_days = 7
  tags              = var.tags
}

resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
  tags            = var.tags
}