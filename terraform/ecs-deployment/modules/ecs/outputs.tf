output "ecs_cluster_id" {
  description = "The ID of the ECS cluster."
  value       = aws_ecs_cluster.ecs_cluster.id
}

output "alb_dns_name" {
  description = "The DNS name of the ALB."
  value       = aws_lb.ecs_alb.dns_name
}
