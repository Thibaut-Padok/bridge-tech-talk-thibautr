output "arn" {
  description = "Debug policy for ECS arn"
  value       = aws_iam_policy.task_debug_and_decrypt.arn
}
