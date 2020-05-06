
variable "app_path" {
  description = "Path to application"
  type        = string
  default     = "../../../../app"
}

variable "aws_iam_role" {
  description = "lambda IAM role ARN"
  type        = string
  default     = "arn:aws:iam::885834442506:role/service-role/MyLambdaExecutionRole"
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

