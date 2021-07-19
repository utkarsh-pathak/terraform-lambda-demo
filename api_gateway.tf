# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "hello_lambda_api"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}

resource "aws_api_gateway_method" "proxy_root" {   
  rest_api_id   = aws_api_gateway_rest_api.api.id   
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id   
  http_method   = "ANY"   
  authorization = "NONE"
  }

resource "aws_api_gateway_integration" "lambda_root" {   
  rest_api_id = aws_api_gateway_rest_api.api.id   
  resource_id = aws_api_gateway_method.proxy_root.resource_id   
  http_method = aws_api_gateway_method.proxy_root.http_method
   integration_http_method = "POST"   
   type                    = "AWS_PROXY"   
   uri                     = aws_lambda_function.lambda.invoke_arn
   }

resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.api.id
   stage_name  = "test"
}