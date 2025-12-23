terraform {
  backend "s3" {
    bucket         = "golden-ami-tfstate-343"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
  }
}
