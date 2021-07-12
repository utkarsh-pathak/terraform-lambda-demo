terraform {
  backend "s3" {
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
