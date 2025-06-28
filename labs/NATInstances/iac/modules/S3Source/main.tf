resource "random_pet" "suffix" {
  length = 3
}

resource "aws_s3_bucket" "resources" {
  force_destroy = true
  bucket        = "${var.labName}-${random_pet.suffix.id}"
}

resource "aws_s3_object" "app_binary" {
  bucket = aws_s3_bucket.resources.id
  key    = "labs/NATInstances/package/AppInstance"
  source = var.app_package_path
  etag   = filemd5(var.app_package_path)

  content_type = "application/octet-stream"
}
