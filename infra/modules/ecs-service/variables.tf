variable "region" {
  description = "The region."
  type        = string
}

variable "cluster" {
  description = "The ECS cluster instance config."
  type = object({
    id   = string
    name = string
  })
}

variable "config" {
  description = "The ECS container configuration."
  type = object({
    name = string
    containers = map(object({
      name        = string
      image       = string
      port        = optional(number, null)
      secrets     = optional(map(string), {})
      environment = optional(map(string), {})
      mount_efs   = optional(bool, false)
      firelens    = optional(bool, false)
    }))
    cpu                      = number
    memory                   = number
    desired_count            = number
    newrelic_license_key_arn = optional(string, null)
    new_relic_log_collection = optional(bool, false)
  })
}

variable "vpc_id" {
  description = "The VPC id."
  type        = string
}

variable "private_subnets_ids" {
  description = "The VPC private subnets ids list."
  type        = list(string)
}

variable "lb" {
  description = "ECS load balancer connexion configuration."
  type = object({
    enabled           = bool
    lb_arn            = string
    target_group_arn  = string
    security_group_id = string
  })
  default = {
    enabled           = false
    lb_arn            = null
    target_group_arn  = null
    security_group_id = null
  }
}

variable "debug_policy_arn" {
  description = "The output of the ecs-debug-policy module"
  type        = string
  default     = ""
}

variable "remote_debug_enabled" {
  description = "To open network flux to activate remote debug"
  type        = bool
  default     = false
}

variable "bastion_sg" {
  description = "bastion security group id, to open network connections"
  type        = string
  default     = ""
}
