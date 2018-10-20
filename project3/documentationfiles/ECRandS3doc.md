# Creating ECR and S3 with Terraform

In this guide you will learn how to create an Elastic Cluster Repository using terraform. 

[project3.tf]

creating an ECR 

```tf

resource "aws_ecr_repository" "zephyrecr" {
	name = "zephyrecr"
}

```

Creating a S3 Bucket

```tf
resource "aws_s3_bucket" "zephyrbucketp3" {
  bucket = "zephyrbucketp3"

  versioning {
    enabled = true
  }
  lifecycle {
		prevent_destroy = true
	}
  }

```