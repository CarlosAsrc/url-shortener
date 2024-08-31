variable "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution role."
  type        = string
}

variable "ecs_instance_role_name" {
  description = "Name of the ECS instance role."
  type        = string
}

variable "ecs_instance_profile_name" {
  description = "Name of the IAM instance profile for ECS instances."
  type        = string
}

variable "ecs_task_role_name" {
  description = "Name of the ECS task role."
  type        = string
}

variable "ecs_task_policy_name" {
  description = "Name of the ECS task policy."
  type        = string
}

variable "ecs_instance_policy_name" {
  description = "Name of the ECS instance policy."
  type        = string
}
