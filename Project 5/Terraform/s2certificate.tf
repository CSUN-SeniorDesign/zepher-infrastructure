provider "aws" {
	region ="us-west-2"
}

resource "aws_s3_bucket" "zephyrbucket" {
	bucket = "zephyr90.com"
	
	  versioning {
	    enabled = true
	  }
	  lifecycle {
			prevent_destroy = true
		}
	}
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::zephyr90.com/*"
        }
    ]
}
POLICY

  
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
}

resource "aws_acm_certificate" "certificate" {
  domain_name       = "zephyr90.com"
  validation_method = "EMAIL"
  subject_alternative_names = ["www.zephyr90.com","blog.zephyr90.com"]
}

