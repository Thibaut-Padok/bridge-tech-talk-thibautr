terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0"
    }
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Env         = local.env
      Region      = local.region
      OwnedBy     = "Padok"
      ManagedByTF = true
    }
  }
}

locals {
  name   = "website-s3"
  env    = "test"
  region = "eu-west-3"
}

module "s3" {
  source = "../../"

  name = local.name

  # Make the bucket public
  allow_public_policy     = true
  restrict_public_buckets = false

  # Add a public policy to let anyone access the website
  policy = data.aws_iam_policy_document.this.json

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  # Authorize HTTP
  attach_deny_insecure_transport_policy = false
  attach_require_latest_tls_policy      = false

  # Disable object versioning
  versioning = {}
}

resource "aws_s3_object" "index" {
  bucket       = module.s3.id
  key          = "index.html"
  content_type = "text/html"

  source = "./index.html"
}

resource "aws_s3_object" "error" {
  bucket       = module.s3.id
  key          = "error.html"
  content_type = "text/html"

  source = "./error.html"
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${local.name}/*"
    ]
  }
}
