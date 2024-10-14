output "bucket_name" {
  description = "Bucket name"
  value       = module.s3.id
}

output "endpoint" {
  description = "Website endpoint"
  value       = module.s3.website_endpoint
}
