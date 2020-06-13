resource "aws_s3_bucket" "charu" {
  bucket = "charu-cloud-bucket"
  acl    = "public-read"

  tags = {
    Name        = "My cloud bucket"
    Environment = "Prod"
  }
}
