terraform {
  backend "s3" {
    bucket         = "barista-infra-state-bucket"
    key            = "terraform/state.tfstate"
    region         = "eu-west-2"
    encrypt        = true
  }
}