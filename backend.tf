terraform {
  backend "s3" {
    bucket         = "terraform--project-maria-sv"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-west-3"
    # dynamodb_table = "terraform-project"
    use_lockfile  = true
    encrypt        = true
  }
}
