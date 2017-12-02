terraform {
  backend "s3" {
    encrypt = "true"
    bucket  = "terraform-demo-claytonsilva"
    key     = "terraform.tfstate"
    region  = "us-west-2"

    # lock_table = "terraform_locks"
    # role_arn   = "arn:aws:iam::xxx:role/yyy"
    profile = "pagarme"
  }
}
