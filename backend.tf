terraform {
  backend "s3" {
    bucket       = "terraform-bucket-ie"
    key          = "dev/asg.tfstate"
    region       = "eu-west-2"
    use_lockfile = true
    encrypt      = true
  }
}