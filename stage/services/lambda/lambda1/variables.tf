
variable "app_path" {
  description = "Path to application"
  type        = string
  default     = "../../../../app/lambda1/src"
}

variable "aws_iam_role" {
  description = "lambda IAM role ARN"
  type        = string
  default     = "arn:aws:iam::885834442506:role/service-role/MyLambdaExecutionRole"
}
