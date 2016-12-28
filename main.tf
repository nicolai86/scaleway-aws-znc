provider "aws" {}

variable "bucket_name" {}
variable "hosted_zone_id" {}
variable "hostname" {}

module "s3" {
  source = "./modules/s3"

  s3_bucket_name = "${var.bucket_name}"
}

provider "scaleway" {
  region = "ams1"
}

variable "znc_container_image" {
  default = "nicolai86/znc:b4b085dc2db69b58f2ad3bb4271ff3789e8301b5"
}
variable "sync_container_image" {
  default = "nicolai86/rclone-sync:v0.1.4"
}

module "znc" {
  source = "./modules/znc"

  aws_access_key_id     = "${module.s3.aws_access_key_id}"
  aws_secret_access_key = "${module.s3.aws_secret_access_key}"
  aws_s3_bucket_name    = "${module.s3.aws_s3_bucket_name}"

  znc_container_image  = "${var.znc_container_image}"
  sync_container_image = "${var.sync_container_image}"
}

module "r53" {
  source = "./modules/r53"

  hosted_zone_id = "${var.hosted_zone_id}"
  service_ip     = "${module.znc.ip}"
  hostname       = "${var.hostname}"
}
