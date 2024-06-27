provider "aws" {
  region = var.aws_region
}

# Create an S3 bucket
resource "aws_s3_bucket" "tsunami_output_bucket" {
  bucket = var.bucket_name
}

# Create an IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-s3-event-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach IAM policy for Lambda to access S3 and SES
resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "lambda-s3-ses-access"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaFullAccess"  # Adjust policy as needed
}

# Create a Lambda function
resource "aws_lambda_function" "tsunami_output_alert_lambda" {
  filename      = "tsunami_alert_lambda.zip"
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"

  environment {
    variables = {
      SES_REGION = var.aws_region
    }
  }

  # Assuming your Lambda function code is in tsunami_alert_lambda.zip
  source_code_hash = filebase64sha256("tsunami_alert_lambda.zip")
}

# Configure SES to send emails
resource "aws_ses_email_identity" "sender_email" {
  email = var.sender_email
}

# Lambda permission to send SES emails
resource "aws_lambda_permission" "allow_ses_send_email" {
  statement_id  = "AllowExecutionFromSES"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tsunami_output_alert_lambda.arn
  principal     = "ses.amazonaws.com"

  source_arn = aws_ses_email_identity.sender_email.arn
}

# S3 bucket notification configuration
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.tsunami_output_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.tsunami_output_alert_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "tsunami-output-"
    filter_suffix       = ".json"
  }
}
