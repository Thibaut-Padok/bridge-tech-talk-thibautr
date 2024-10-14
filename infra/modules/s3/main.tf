module "this" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  create_bucket = var.create_bucket

  bucket        = var.random_id ? null : var.name
  bucket_prefix = var.random_id ? var.name : null

  force_destroy = var.force_destroy

  expected_bucket_owner = var.expected_bucket_owner

  acceleration_status = var.acceleration_status

  # Disable ACL & force object ownership to bucket owner by default
  control_object_ownership = true
  object_ownership         = var.object_ownership == null ? ((var.acl != null || length(var.grant) > 0) ? "ObjectWriter" : "BucketOwnerEnforced") : var.object_ownership

  acl   = var.acl
  grant = var.grant
  owner = var.owner

  attach_policy = var.policy == null ? false : true
  policy        = var.policy

  attach_deny_insecure_transport_policy = var.attach_deny_insecure_transport_policy
  attach_require_latest_tls_policy      = var.attach_require_latest_tls_policy

  attach_elb_log_delivery_policy = var.attach_elb_log_delivery_policy
  attach_lb_log_delivery_policy  = var.attach_lb_log_delivery_policy

  cors_rule = var.cors_rule

  block_public_acls       = !var.allow_public_acls
  block_public_policy     = !var.allow_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets

  request_payer = var.request_payer

  website = var.website

  versioning = var.versioning
  logging    = var.logging

  lifecycle_rule = var.lifecycle_rule

  server_side_encryption_configuration = var.server_side_encryption_configuration

  object_lock_enabled       = var.object_lock_enabled
  object_lock_configuration = var.object_lock_configuration

  tags = var.tags
}
