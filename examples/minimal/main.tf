module "druid" {
  source = "git@github.com:vidoomymedia/terraform-aws-druid.git"

  aws_access_key     = "your-aws-access-key"
  aws_secret_key     = "your-aws-secret-key"
  aws_region         = "eu-west-2"
  aws_bucket_storage = "vidoomy-druid-segments"
  aws_bucket_index   = "vidoomy-druid-indexes"
}
