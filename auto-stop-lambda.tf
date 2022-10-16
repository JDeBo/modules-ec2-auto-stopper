resource "aws_iam_role" "iam_for_lambda" {
  name = "StopEC2LambdaRole-${var.use_case}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "AssumeRoleForLambda"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "ec2_lambda" {
  statement {
    sid       = "LambdaStopInstances"
    effect    = "Allow"
    actions   = ["ec2:StopInstances"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_lambda" {
  path        = "/"
  description = "LambdaStopEC2-${var.use_case}"
  policy      = data.aws_iam_policy_document.ec2_lambda.json
}

resource "aws_iam_role_policy_attachment" "ec2_lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.ec2_lambda.arn
}

resource "aws_iam_role_policy_attachment" "basic_execution" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "auto_stopper" {
  filename         = "${path.module}/auto_stopper.zip"
  function_name    = "auto_stop_ec2s_${var.use_case}"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.auto_stopper.output_base64sha256

  runtime = "python3.8"

  environment {
    variables = {
      EC2_INSTANCES = jsonencode(var.ec2_map)
    }
  }
  depends_on = [
    data.archive_file.auto_stopper
  ]
}

data "archive_file" "auto_stopper" {
  type        = "zip"
  source_file = "${path.module}/src/main.py"
  output_path = "${path.module}/auto_stopper.zip"
}