output "bucket_name" {
  description = "Bucket name"
  value       = module.s3.id
}

output "bucket_domain_name" {
  description = "Bucket domain name"
  value       = module.s3.domain_name
}
