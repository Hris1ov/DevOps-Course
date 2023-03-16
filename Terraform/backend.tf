form {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.30.0"
    }
  }
  backend "s3" {
    bucket         = "devops1451"
    key            = "test_key"
    region         = us-east-1
    profile = "int"
  }
  required_version = ">= 1.1.0"
}
