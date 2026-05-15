output "vpc_id" {
  value       = aws_vpc.main.id
  description = "ID of the created VPC"
}

output "public_subnet_ids" {
  value       = [for s in aws_subnet.public : s.id]
  description = "List of public subnet IDs"
}

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "ID of the public route table"
}

output "flow_log_id" {
  value = aws_flow_log.main.id
}