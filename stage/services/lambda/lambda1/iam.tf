
# How to create a role for a lambda

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : "",
      },
    ],
  })
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = (file("${path.module}/iam_policy.json"))
  # policy = jsonencode(
  #   {
  #     "Version" : "2012-10-17",
  #     "Statement" : [
  #       {
  #         "Action" : [
  #           "logs:CreateLogGroup",
  #           "logs:CreateLogStream",
  #           "logs:PutLogEvents"
  #         ],
  #         "Resource" : "arn:aws:logs:*:*:*",
  #         "Effect" : "Allow"
  #       }
  #     ]
  #   }
  # )
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}
