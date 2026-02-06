provider "aws" {
  region  = "us-east-1"
  profile = "scratch-developer"
}

module "ecr" {
  source          = "./modules/ecr"
  repository_name = var.ecr_repo_name
}

module "ecs_fargate_task" {
  source = "./modules/ecs-fargate-task"

  cluster_name    = var.cluster_name
  task_family     = var.task_family
  execution_role  = var.execution_role_arn

  enable_service = true
  desired_count  = 1

  container_image    = "${module.ecr.repository_url}:latest"
  container_name     = var.container_name
  containerPort      = 8080
  container_protocol = var.container_protocol
}
