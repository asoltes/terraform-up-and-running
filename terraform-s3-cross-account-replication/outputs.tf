output "source_bucket" {
  value = aws_s3_bucket.source_bucket.arn
}

output "destination_bucket" {
  value = aws_s3_bucket.destination_bucket.arn
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
