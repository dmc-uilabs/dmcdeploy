resource "aws_s3_bucket" "b2" {
    bucket = "dmc-restServices-distribution"
    acl = "public-read-write"
   


    versioning {
        enabled = true
    }
}


