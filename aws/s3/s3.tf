
resource "aws_s3_bucket" "b9" {
    bucket = "db-web-bucket"
    acl = "private"
    

    tags {
        Name = "My db bucket"
        Environment = "Dev"

    }
}
