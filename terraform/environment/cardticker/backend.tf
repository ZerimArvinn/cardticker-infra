terraform {
  backend "s3" {
    bucket         = "cardticker-terraform-state"   
    key            = "cardticker/terraform.tfstate" 
    region         = "us-east-1"                    
    encrypt        = true
    dynamodb_table = "terraform-state-lock"              
  }
}