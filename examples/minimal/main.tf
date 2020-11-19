module "druid" {
  source = "git@github.com:vidoomymedia/terraform-aws-druid.git"

  aws_access_key     = "AKIA5TXOPNC3I3TTZUNY"
  aws_secret_key     = "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"
  aws_region         = "eu-west-2"
  aws_bucket_storage = "vidoomy-druid-segments"
  aws_bucket_index   = "vidoomy-druid-indexes"
}
