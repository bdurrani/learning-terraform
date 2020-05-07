
variable "app_path" {
  description = "Path to application"
  type        = string
  default     = "../../../../app"
}

variable "role_arn" {
  description = "lambda IAM role ARN"
  type        = string
}

variable "repo_path" {
  description = "Path to application"
  type        = string
  default     = "/home/bdurrani/terraform/app"
}


variable "lambda_name" {
  description = "Name of the lambda"
  type        = string
}

variable "lambda_timeout" {
  description = "Timeout for lamda in seconds"
  type        = number
}

variable "package_name" {
  type        = string
  description = "Name of package to deploy"
}

