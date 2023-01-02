# Create the API Gateway
resource "aws_api_gateway_rest_api" "email_api" {
  name = "email_api"
}

# Create a resource for the "send_email" function
resource "aws_api_gateway_resource" "send_email_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.email_api.id}"
  parent_id = "${aws_api_gateway_rest_api.email_api.root_resource_id}"
  path_part = "send_email"

}

# Create a POST method for the "send_email" resource
resource "aws_api_gateway_method" "send_email_method" {
  rest_api_id = "${aws_api_gateway_rest_api.email_api.id}"
  resource_id = "${aws_api_gateway_resource.send_email_resource.id}"
  http_method = "POST"
  authorization = "NONE"

}

# Create an integration for the "send_email" method
resource "aws_api_gateway_integration" "send_email_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.email_api.id}"
  resource_id = "${aws_api_gateway_resource.send_email_resource.id}"
  http_method = "${aws_api_gateway_method.send_email_method.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "${aws_lambda_function.send_email_func.invoke_arn}"

}

# Create a resource for the "send_verification_email" function
resource "aws_api_gateway_resource" "send_verification_email_resource" {
  rest_api_id = "${aws_api_gateway_rest_api.email_api.id}"
  parent_id = "${aws_api_gateway_rest_api.email_api.root_resource_id}"
  path_part = "send_verification_email"
}

# Create a POST method for the "send_verification_email" resource
resource "aws_api_gateway_method" "send_verification_email_method" {
  rest_api_id = "${aws_api_gateway_rest_api.email_api.id}"
  resource_id = "${aws_api_gateway_resource.send_verification_email_resource.id}"
  http_method = "POST"
  authorization = "NONE"
}

# Create an integration for the "send_verification_email" method
resource "aws_api_gateway_integration" "send_verification_email_integration" {
  rest_api_id = "${aws_api_gateway_rest_api.email_api.id}"
  resource_id = "${aws_api_gateway_resource.send_verification_email_resource.id}"
  http_method = "${aws_api_gateway_method.send_verification_email_method.http_method}"
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "${aws_lambda_function.send_verification_email_func.invoke_arn}"
}

# Create a deployment for the API Gateway
resource "aws_api_gateway_deployment" "api_gateway_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.email_api.id}"
  stage_name = "prod"

  depends_on = [
    aws_api_gateway_integration.send_email_integration,
    aws_api_gateway_integration.send_verification_email_integration,
  ]
}

output "api_url" {
  value = "${aws_api_gateway_deployment.api_gateway_deployment.invoke_url}"
}
