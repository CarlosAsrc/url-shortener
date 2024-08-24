output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs."
  value       = module.vpc.public_subnets
}


output "ecs_instance_profile_arn" {
  description = "The ARN of the IAM instance profile for ECS instances."
  value       = module.iam.ecs_instance_profile_arn
}

output "ecs_task_execution_role_arn" {
  description = "The ARN of the ECS task execution role."
  value       = module.iam.ecs_task_execution_role_arn
}

output "auto_scaling_group_arn" {
  description = "The DNS name of the Application Load Balancer."
  value       = module.ecs.alb_dns_name
}
