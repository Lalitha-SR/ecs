resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}
resource "aws_ecs_task_definition" "this" {
  family                   = var.task_family
  network_mode             = var.network_mode
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role

  container_definitions = templatefile("${path.module}/task_container_def.json", {
    container_image    = var.container_image
    container_name     = var.container_name
    containerPort      = var.containerPort
    container_protocol = var.container_protocol
    log_group          = "/ecs/${var.task_family}"
    region             = var.region
  })
}

resource "aws_ecs_service" "this" {
  count           = var.enable_service ? 1 : 0
  name            = "${var.task_family}-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public.id]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}