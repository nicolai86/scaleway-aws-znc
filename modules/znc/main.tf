variable "aws_access_key_id" {}

variable "aws_secret_access_key" {}

variable "aws_s3_bucket_name" {}

variable "znc_container_image" {}

variable "sync_container_image" {}

variable "architecture" {
  default = "x86_64"
}

variable "instance_type" {
  default = "VC1S"
}

data "scaleway_bootscript" "docker" {
  architecture = "${var.architecture}"
  name_filter  = "docker #1"
}

data "scaleway_image" "docker" {
  architecture = "${var.architecture}"
  name_filter  = "Docker"
}

resource "scaleway_ip" "znc" {
  server = "${scaleway_server.znc.id}"
}

resource "scaleway_server" "znc" {
  name                = "znc"
  image               = "${data.scaleway_image.docker.id}"
  bootscript          = "${data.scaleway_bootscript.docker.id}"
  type                = "${var.instance_type}"
  tags                = ["znc"]
  dynamic_ip_required = true

  connection {
    type = "ssh"
    user = "root"
    host = "${self.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${var.znc_container_image} > /tmp/znc_container_image",
      "echo ${var.sync_container_image} > /tmp/sync_container_image",
      "echo ${var.aws_access_key_id} > /tmp/AWS_ACCESS_KEY_ID",
      "echo ${var.aws_secret_access_key} > /tmp/AWS_SECRET_ACCESS_KEY",
      "echo ${var.aws_s3_bucket_name} > /tmp/S3_BUCKET_NAME",
    ]
  }

  provisioner "remote-exec" {
    scripts = [
      "${path.module}/scripts/setup.sh",
    ]
  }
}

output "ip" {
  value = "${scaleway_ip.znc.ip}"
}
