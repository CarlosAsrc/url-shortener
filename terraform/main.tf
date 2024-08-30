terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"

  ecs_task_execution_role_name = "ecsTaskExecutionRole"
  ecs_instance_role_name       = "ecsInstanceRole"
  ecs_instance_profile_name    = "${var.app_name}_ecs_instance_profile"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "ecs" {
  source = "./modules/ecs"

  vpc_id                 = module.vpc.vpc_id
  subnets                = module.vpc.public_subnets
  execution_role_arn     = module.iam.ecs_task_execution_role_arn
  ecs_cluster_name       = var.ecs_cluster_name
  ecs_task_family        = var.task_family_name
  ecs_service_name       = var.ecs_service_name
  container_image        = var.container_image
  security_groups        = [module.vpc.ecs_sg]
  desired_count          = var.desired_count
  auto_scaling_group_arn = module.ec2.auto_scaling_group_arn

}

module "ec2" {
  source = "./modules/ec2"

  subnets          = module.vpc.public_subnets
  security_groups  = [module.vpc.ecs_sg]
  vpc_id           = module.vpc.vpc_id
  desired_count    = var.desired_count
  min_count        = var.min_count
  max_count        = var.max_count
  instance_profile = module.iam.ecs_instance_profile_arn
  ecs_cluster_name = var.ecs_cluster_name
  instance_type    = var.ecs_instance_type
}
