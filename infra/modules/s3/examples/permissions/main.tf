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
  name   = "permissions-s3"
  env    = "test"
  region = "eu-west-3"
}

module "s3" {
  source = "../../"

  name = local.name

  policy = data.aws_iam_policy_document.this.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "this" {
  # Everyone can read the content
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${local.name}",
      "arn:aws:s3:::${local.name}/*"
    ]
  }

  # Full rights to current user
  statement {
    actions = ["s3:*"]
    principals {
      identifiers = [data.aws_caller_identity.current.arn]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${local.name}",
      "arn:aws:s3:::${local.name}/*"
    ]
  }
}
