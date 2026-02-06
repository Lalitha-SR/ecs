variable "cluster_name" {}
variable "task_family" {}

variable "network_mode" {
  default = "awsvpc"
}

variable "cpu" {
  default = 256
}

variable "memory" {
  default = 512
}

variable "execution_role" {
  description = "IAM execution role ARN for ECS task execution"
}

variable "enable_service" {
  type    = bool
  default = false
}

variable "desired_count" {
  default = 1
}

variable "container_name" {}
variable "containerPort" {}
variable "container_protocol" {}
variable "container_image" {}

variable "cidr_block" {
  default = "10.0.0.0/24"
}

variable "public_cidr_block" {
  default = "10.0.0.0/28"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "region" {
  default = "us-east-1"
}
