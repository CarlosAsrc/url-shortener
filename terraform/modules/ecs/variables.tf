variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

variable "ecs_task_family" {
  description = "The family name for the ECS task definition."
  type        = string
}

variable "ecs_service_name" {
  description = "The name of the ECS service."
  type        = string
}

variable "cpu" {
  description = "CPU units for the ECS task."
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory (in MiB) for the ECS task."
  type        = number
  default     = 512
}

variable "container_image" {
  description = "The Docker image to use for the container."
  type        = string
}

variable "execution_role_arn" {
  description = "The ARN of the IAM role that allows ECS to make calls to other AWS services."
  type        = string
}

variable "task_role_arn" {
  description = "The ARN of the IAM role that allows ECS to make calls to other AWS services."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "public_subnets" {
  description = "The public subnets associated with the ECS deployment."
  type        = list(string)
}

variable "private_subnets" {
  description = "The private subnets associated with the ECS deployment."
  type        = list(string)
}

variable "security_groups" {
  description = "The security groups associated with the ECS service."
  type        = list(string)
}

variable "desired_count" {
  description = "The desired number of ECS service instances."
  type        = number
}

variable "auto_scaling_group_arn" {
  description = "value of the auto scaling group arn"
  type        = string
}
