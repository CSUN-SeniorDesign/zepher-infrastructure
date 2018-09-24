resource "aws_s3_bucket" "zephyrbucket" {
  bucket = "zephyrbuckets3"

  versioning {
    enabled = true
  }
  lifecycle {
		prevent_destroy = true
	}
  }
  resource "aws_dynamodb_table" "zephyrlock" {
  name = "zephyrlock"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}