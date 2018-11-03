Terraform Route 53 for Hosting Static Site

<h1>Setup for Route 53 for Hosting a Static site on AWS</h1>
Route 53 is a scalable Domain Name system web service. It helps connect the domain we provide the AWS infrastructures we setup such as EC2 instances or Amazon S3 buckets.

<h2>Overview:</h2>
By the end of this guide users will be able to create terraform files that will create Route 53 records that point to S3 buckets or Cloudfront distributions.
 
<h2>Prerequisites:</h2>

•	A machine

•	Terraform Installed

•	AWS access 


<h2>Guide:</h2>

<h3>Route 53</h3>
Terraform has documentation that has skeletons for what is required in this guide : https://www.terraform.io/docs/providers/aws/r/route53_record.html

Using the Route 53 skeleton for Aliases since that's what we need for them to point to our buckets or Cloudfront Distributions.

    resource "aws_route53_record" "www" {
      zone_id = "${aws_route53_zone.primary.zone_id}"
      name    = "example.com"
      type    = "A"

      alias {
        name                   = "${aws_elb.main.dns_name}"
        zone_id                = "${aws_elb.main.zone_id}"
        evaluate_target_health = true
      }
    }
    
"resource "aws_route53_record" "www" { " : This section will need to be modified to reflect the name or alias you're creating. Replacing the "www" to the alias you would like to create.

"zone_id = "${aws_route53_zone.primary.zone_id}" " : This is to connect to the Hosted zone in that you needed to create for your Domain. This ID can be found in your Hosted zone that is connected to the Domain you created.

"name    = "example.com" " : This section is the name of your Alias

"type    = "A" " : This is the type of record you're trying to create. You can find the type of records available on AWS but for now we are creating a type A record.

"name                   = "${aws_elb.main.dns_name}" " : This should be replaced with what you want to point to. Whether that is a Cloudfront Distribution that then points to a bucket or the Bucket itself.

"zone_id                = "${aws_elb.main.zone_id}" " : If using Cloudfront you will need to find the zone id that is associated with the Distribution.

"evaluate_target_health = true " " : This section is optional, true if you want Route 53 to respond to DNS queries using this resource record set by checking the health of the resource.

Using this Skeleton and replicating it for as many Alias's as you need in association with CircleCI and either a Cloudfront Distribution or S3 bucket to hose the content should be enough to host a static website on AWS.
