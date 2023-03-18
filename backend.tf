terraform {
  backend "s3"{
    bucket = "devoops1451-terraform-state"
    key = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf_state_lock"
    encrypt = true
  }
}

