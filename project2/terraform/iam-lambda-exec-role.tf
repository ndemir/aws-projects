resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com",
          "apigateway.amazonaws.com"
        ]
        
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda_ses_policy" {
  name = "lambda_ses_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ses:*",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda_ses_attachment" {
  name       = "lambda_ses_attachment"
  policy_arn = "${aws_iam_policy.lambda_ses_policy.arn}"
  roles      = ["${aws_iam_role.lambda_exec_role.name}"]
}

resource "aws_iam_policy_attachment" "lambda_AWSLambdaBasicExecutionRole_attachment" {
  name      = "lambda_AWSLambdaBasicExecutionRole_attachment"
  roles       = ["${aws_iam_role.lambda_exec_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
