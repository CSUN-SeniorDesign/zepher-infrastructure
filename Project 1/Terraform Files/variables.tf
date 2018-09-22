variable "aws_access_key" {}

variable "aws_secret_key" {}
variable "region" {
        default = "us-west-2"
}
data "aws_availability_zones" "allzones" {}