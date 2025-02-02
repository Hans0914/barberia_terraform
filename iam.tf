resource "aws_iam_role" "lambda_role" {
  name = "barberia_lambdas_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
  ] })
}

resource "aws_iam_policy" "lambda_dynamo_policy" {
  name        = "barberia_lambda_dynamo_policy"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
       {
        # Permisos para usar la capa Lambda
        Action = [
          "lambda:GetLayerVersion"
        ]
        Effect = "Allow"
        Resource = "arn:aws:lambda:us-east:490004613297:layer:lambda_layer:*"
      }
    ]})
}

resource "aws_iam_role_policy_attachment" "lambda_dynamo_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamo_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowAPIGatewayInvokeAll"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.registrar_cliente.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
  depends_on = [ aws_lambda_function.registrar_cliente ]
}

resource "aws_lambda_permission" "api_gateway_permission12" {
  statement_id  = "AllowAPIGatewayInvokeAll"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.obtener_cliente.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
  depends_on = [ aws_lambda_function.obtener_cliente ]
}

resource "aws_lambda_permission" "api_gateway_permission1" {
  statement_id  = "AllowAPIGatewayInvokeAll"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.obtener_reservas_cliente.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
  depends_on = [ aws_lambda_function.obtener_reservas_cliente ]
}
resource "aws_lambda_permission" "api_gateway_permission2" {
  statement_id  = "AllowAPIGatewayInvokeAll"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.obtener_reserva.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
  depends_on = [ aws_lambda_function.obtener_reserva ]
}
resource "aws_lambda_permission" "api_gateway_permission3" {
  statement_id  = "AllowAPIGatewayInvokeAll"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.obtener_barberos.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
  depends_on = [ aws_lambda_function.obtener_barberos ]
}
resource "aws_lambda_permission" "api_gateway_permission4" {
  statement_id  = "AllowAPIGatewayInvokeAll"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.crear_reserva.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
  #depends_on = [ aws_lambda_function.crear_reserva ]
}
resource "aws_lambda_permission" "api_gateway_permission5" {
  statement_id  = "AllowAPIGatewayInvokeAll"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.actualizar_reserva.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
  depends_on = [ aws_lambda_function.actualizar_reserva ]
}
resource "aws_lambda_permission" "api_gateway_permission6" {
  statement_id  = "AllowAPIGatewayInvokeAll"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.eliminar_reserva.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
  depends_on = [ aws_lambda_function.eliminar_reserva ]
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cargar_bucket.function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.bucket.arn
  depends_on = [ aws_lambda_function.cargar_bucket ]
}
