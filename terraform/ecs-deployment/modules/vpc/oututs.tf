output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.ecs_vpc.id
}

output "public_subnets" {
  description = "The IDs of the public subnets."
  value       = aws_subnet.public.*.id
}

output "public_route_table_id" {
  description = "The ID of the public route table."
  value       = aws_route_table.public_rt.id
}

output "ecs_sg" {
  description = "The security group for the ECS service"
  value       = aws_security_group.ecs_sg.id
}
