variable "region" {
  description = "The AWS region to deploy the resources in."
  type        = string
  default     = "us-east-1"
}

variable "profile" {
  description = "The AWS CLI profile to use for authentication."
  type        = string
  default     = "default"
}

variable "app_name" {
  description = "The name of the application to be deployed."
  type        = string
  default     = "UrlShortener"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidrs" {
  description = "List of CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "ecs_cluster_name" {
  description = "The ECS cluster name."
  type        = string
  default     = "url-shortener-ecs-cluster"
}

variable "task_family_name" {
  description = "The task family name."
  type        = string
  default     = "url-shortener-task-family"
}

variable "ecs_service_name" {
  description = "The ECS service name."
  type        = string
  default     = "url-shortener-ecs-service"
}

variable "container_image" {
  description = "The container image."
  type        = string
  default     = "446343335231.dkr.ecr.us-east-1.amazonaws.com/url_shortener_images:latest"
}

variable "ecs_instance_type" {
  description = "The EC2 instance type for ECS instances."
  type        = string
  default     = "t2.micro"
}

variable "desired_count" {
  description = "The desired number of ECS instances."
  type        = number
  default     = 1
}

variable "max_count" {
  description = "The maximum number of ECS instances."
  type        = number
  default     = 2
}

variable "min_count" {
  description = "The minimum number of ECS instances."
  type        = number
  default     = 1
}
