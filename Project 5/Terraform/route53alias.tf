resource "aws_route53_record" "alias_route53_record" {
  zone_id = "Z1GFVUABNAOPNR"
   name    = "zephyr90.com"
  type    = "A"
	alias {
    name = "${aws_cloudfront_distribution.www_distribution.domain_name}"
    zone_id ="${aws_cloudfront_distribution.www_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "alias_route53_record" {
  zone_id = "Z1GFVUABNAOPNR"
   name    = "www.zephyr90.com"
  type    = "A"
	alias {
    name = "${aws_cloudfront_distribution.www_distribution.domain_name}"
    zone_id ="${aws_cloudfront_distribution.www_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "alias_route53_record" {
  zone_id = "Z1GFVUABNAOPNR"
   name    = "blog.zephyr90.com"
  type    = "A"
	alias {
    name = "${aws_cloudfront_distribution.www_distribution.domain_name}"
    zone_id ="${aws_cloudfront_distribution.www_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

