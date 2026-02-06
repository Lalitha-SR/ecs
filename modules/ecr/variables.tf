variable "repository_name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "image_tag_mutability" {
  type        = string
  default     = "MUTABLE"
  description = "MUTABLE or IMMUTABLE"
}

variable "scan_on_push" {
  type        = bool
  default     = true
  description = "Enable image scanning on push"
}

variable "encryption_type" {
  type        = string
  default     = "AES256"
  description = "AES256 or KMS"
}
