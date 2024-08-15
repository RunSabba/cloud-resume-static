output "DynamoDB_table_arn" {
  value = aws_dynamodb_table.state-lock-table.arn
}
output "tf_user_arn" {
  value = aws_iam_user.tf_user.arn
}