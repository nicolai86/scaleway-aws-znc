variable "s3_bucket_name" {}

resource "aws_s3_bucket" "znc-data" {
  bucket = "${var.s3_bucket_name}"
  acl    = "private"

  tags {
    Name = "ZNC Data"
  }
}

resource "aws_iam_user" "znc" {
  name = "znc-sync"
}

resource "aws_iam_access_key" "znc-sync" {
  user = "${aws_iam_user.znc.name}"
}

resource "aws_iam_user_policy" "znc" {
  name = "s3"
  user = "${aws_iam_user.znc.name}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket_name}",
                "arn:aws:s3:::${var.s3_bucket_name}/*"
            ]
        }
   ]
}
EOF
}

output "aws_s3_bucket_name" {
  value = "${var.s3_bucket_name}"
}

output "aws_access_key_id" {
  value = "${aws_iam_access_key.znc-sync.id}"
}

output "aws_secret_access_key" {
  value = "${aws_iam_access_key.znc-sync.secret}"
}
