variable "service_ip" {}

variable "hosted_zone_id" {}

variable "hostname" {}

resource "aws_route53_record" "znc" {
  zone_id = "${var.hosted_zone_id}"
  name    = "${var.hostname}"
  type    = "A"
  ttl     = "300"
  records = ["${var.service_ip}"]
}
