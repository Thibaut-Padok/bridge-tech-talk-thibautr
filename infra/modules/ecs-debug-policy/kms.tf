resource "aws_kms_key" "this" {
  description             = "KMS key used to encrypt data for tasks"
  deletion_window_in_days = 30

  lifecycle {
    prevent_destroy = false
  }
}
