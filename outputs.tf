output "lambda" {
  value = "${aws_lambda_function.lambda.qualified_arn}"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.apideploy.invoke_url}/${aws_api_gateway_resource.resource.path_part}"
}
