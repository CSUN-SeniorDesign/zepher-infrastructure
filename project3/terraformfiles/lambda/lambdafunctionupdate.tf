resource "aws_lambda_function" "update-staging" {
  filename         = "lambdastaging.zip"
  function_name    = "update-staging"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "update-staging.main"
  source_code_hash = "${base64sha256(file("lambdastaging.zip"))}"
  runtime          = "python3.6"
}
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.update-staging.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${var.bucket-arn}"
}
resource "aws_s3_bucket_notification" "s3-bucket-notification" {
  bucket = "${aws_s3_bucket.zephyrbucketp3.id}"
  lambda_function{
    lambda_function_arn = "${aws_lambda_function.update-staging.arn}"
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".txt"
  }
  
  }
