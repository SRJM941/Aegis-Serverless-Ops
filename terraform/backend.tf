terraform {
  backend "s3" {
    bucket         = "rahul-infra-tfstate-78e28aec" # Aapka output bucket
    key            = "dev/terraform.tfstate"       # Path inside bucket
    region         = "ap-south-1"                  # Mumbai
    encrypt        = true
    dynamodb_table = "rahul-infra-tf-locks"        # Jo bootstrap ne banayi
  }
}