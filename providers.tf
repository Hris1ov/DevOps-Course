terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 4.18.0"
   }
 }

 backend "s3" {
   bucket = "devops_trainee_1451"
   key    = "state"
   region = "eu-central-1"
 }
}
