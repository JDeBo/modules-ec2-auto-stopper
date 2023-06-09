resource "aws_cloudwatch_event_rule" "stop_instances" {
  name                = "${local.action}Instance${local.id}"
  description         = "${local.action} instances"
  schedule_expression = "cron(${var.cron_schedule})"
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.stop_instances.name
  target_id = "${local.action}Instance"
  arn       = aws_lambda_function.auto_stopper.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch${local.id}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auto_stopper.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_instances.arn
}