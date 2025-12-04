resource "aws_cloudwatch_metric_alarm" "billing" {
  alarm_name          = "billing-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = 21600
  statistic           = "Maximum"
  threshold           = 100
  dimensions = {
    Currency = "INR"
  }
  alarm_actions = ["arn:aws:sns:us-east-1:ACCOUNT_ID:billing-topic"]
}
