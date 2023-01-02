data "archive_file" "send_email_zip" {
  type        = "zip"
  source_file = "../app/send_email.py"
  output_path = "/tmp/send_email.zip"
}

resource "aws_lambda_function" "send_email_func" {
  filename         = "${data.archive_file.send_email_zip.output_path}"
  function_name    = "send_email"
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  handler          = "send_email.send_email"
  runtime          = "python3.8"
  source_code_hash = "${data.archive_file.send_email_zip.output_base64sha256}"
}
#

data "archive_file" "send_verification_email_zip" {
  type        = "zip"
  source_file = "../app/send_verification_email.py"
  output_path = "/tmp/send_verification_email.zip"
}

resource "aws_lambda_function" "send_verification_email_func" {
  filename         = "${data.archive_file.send_verification_email_zip.output_path}"
  function_name    = "send_verification_email"
  role             = "${aws_iam_role.lambda_exec_role.arn}"
  handler          = "send_verification_email.send_verification_email"
  runtime          = "python3.8"
  source_code_hash = "${data.archive_file.send_verification_email_zip.output_base64sha256}"

}

resource "aws_lambda_permission" "lambda_permission_for_send_email" {
  statement_id  = "AllowAPIGWToInvoke_send_email"
  action        = "lambda:InvokeFunction"
  function_name = "send_email"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.email_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "lambda_permission_for_send_verification_email" {
  statement_id  = "AllowAPIGWToInvoke_send_verification_email"
  action        = "lambda:InvokeFunction"
  function_name = "send_verification_email"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.email_api.execution_arn}/*/*"
}