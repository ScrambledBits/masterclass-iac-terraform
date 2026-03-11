# backend.tf - Estado en S3
terraform {
  backend "s3" {
    bucket         = "bootcamperu-tf-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    use_lockfile = true
  }
}
