resource "aws_cloudwatch_event_rule" "stop_instances" {
  name                = "StopInstance${var.use_case}"
  description         = "Stop instances nightly"
  schedule_expression = "cron(0 5 * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.stop_instances.name
  target_id = "StopInstance"
  arn       = aws_lambda_function.auto_stopper.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch${var.use_case}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auto_stopper.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_instances.arn
}