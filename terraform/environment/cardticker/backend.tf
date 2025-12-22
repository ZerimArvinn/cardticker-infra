terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"    # <== replace me
    key            = "cardticker/terraform.tfstate" # path in the bucket
    region         = "us-east-1"                    # <== replace me
    encrypt        = true
    dynamodb_table = "terraform-locks"              # optional: provide a lock table
  }
}