variable "cpu_utilization_high_threshold_percent" {
  type        = number
  default     = 80
}

variable "cpu_utilization_high_period_seconds" {
  type        = number
  default     = 300
}

variable "cpu_utilization_high_evaluation_periods" {
  type        = number
  default     = 2
}

variable "asg_cooldown_seconds" {
  type        = number
  default     = 300
}

variable "cpu_utilization_low_threshold_percent" {
  type        = number
  default     = 60
}

variable "cpu_utilization_low_period_seconds" {
  type        = number
  default     = 300
}

variable "cpu_utilization_low_evaluation_periods" {
  type        = number
  default     = 2
}
