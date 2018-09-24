terraform {
  backend "s3" {
    bucket = "zephyrbuckets3"
    key    = "terraform.tfstate"
	dynamodb_table = "zephyrlock"

    region = "us-west-2"
  }
}