cluster_name = "fargate-example"
task_family = "fargate-ecs"
execution_role_arn = "arn:aws:iam::227224898353:role/dev-ecstaskexecution"

container_name    = "fargate1"
container_protocol = "tcp"

ecr_repo_name = "ecs-fargate"
