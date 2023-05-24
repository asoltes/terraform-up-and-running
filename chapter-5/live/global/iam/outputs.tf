output "firs_arn" {
    value = aws_iam_user.iam_usernames[0].arn
    description = "The ARN of first user"  
}

output "all_arns" {
    value = aws_iam_user.iam_usernames[*].arn
    description = "The ARN for all users"
  
}