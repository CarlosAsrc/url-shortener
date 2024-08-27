variable "subnets" {
  description = "The subnets associated with the ECS service."
  type        = list(string)
}

variable "security_groups" {
  description = "The security groups associated with the ECS service."
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "desired_count" {
  description = "The desired number of ECS service instances."
  type        = number
}

variable "min_count" {
  description = "The min number of ECS service instances."
  type        = number
}

variable "max_count" {
  description = "The max number of ECS service instances."
  type        = number
}

variable "instance_profile" {
  description = "The IAM instance profile"
  type        = string
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

variable "instance_type" {
  description = "The type of the EC2 instance."
  type        = string
}
