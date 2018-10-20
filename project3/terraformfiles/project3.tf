# Neel Creating new bucket for project 3
resource "aws_s3_bucket" "zephyrbucketp3" {
  bucket = "zephyrbucketp3"

  versioning {
    enabled = true
  }
  lifecycle {
		prevent_destroy = true
	}
  }
  
# Creating new Elastic Container Repository
resource "aws_ecr_repository" "zephyrecr" {
	name = "zephyrecr"
}


resource "aws_ecs_cluster" "zephyrecscluster" {
	name = "zephyrecscluster"
}
