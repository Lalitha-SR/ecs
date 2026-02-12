terraform {
  backend "s3" {
    bucket         = "dev-state-18"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true 
    # dynamodb_table = "terraform-locks"
  }
}
