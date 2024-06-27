variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "sender_email" {
  description = "Sender email address for SES"
  default     = "your-sender-email@example.com"
}

variable "bucket_name" {
  description = "Name for the S3 bucket"
  default     = "tsunami-output-bucket-name"
}

variable "lambda_function_name" {
  description = "Name for the Lambda function"
  default     = "tsunami-output-alert-function"
}
