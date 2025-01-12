resource "aws_api_gateway_rest_api" "api" {
  name        = "barberia-api"
  description = "API Gateway para la barberia"
}
#Metodos para obtener barberos
resource "aws_api_gateway_resource" "barberos_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "barberos"
}
# Crear un método (GET) , get barberos
resource "aws_api_gateway_method" "barberos_method_g" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.barberos_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "barberos_g_integracion" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.barberos_resource.id
  http_method             = aws_api_gateway_method.barberos_method_g.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.obtener_barberos.invoke_arn

  depends_on = [aws_api_gateway_method.barberos_method_g]
}
# Crear un recurso raíz
resource "aws_api_gateway_resource" "reservas_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "reserva"
}

# Crear un método (GET) , get reservas
resource "aws_api_gateway_method" "reserva_method_g" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.reservas_resource.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.reserva_id" = true
  }
}
# crear reserva
resource "aws_api_gateway_method" "reserva_method_p" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.reservas_resource.id
  http_method   = "POST"
  authorization = "NONE"
}
# delete reserva
resource "aws_api_gateway_method" "reserva_method_d" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.reservas_resource.id
  http_method   = "DELETE"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.reserva_id" = true
  }
}

# Integrar el método con la Lambda
resource "aws_api_gateway_integration" "reserva_g_integracion" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.reservas_resource.id
  http_method             = aws_api_gateway_method.reserva_method_g.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.obtener_reserva.invoke_arn
  request_parameters = {
    "integration.request.querystring.reserva_id" = "method.request.querystring.reserva_id"
  }
  request_templates = {
    "application/json" = <<EOF
    {
      "reserva_id": "$input.params('reserva_id')"
    }
    EOF
  }
}

resource "aws_api_gateway_integration" "reserva_p_integracion" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.reservas_resource.id
  http_method             = aws_api_gateway_method.reserva_method_p.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.crear_reserva.invoke_arn

  request_templates = {
    "application/json" = <<EOF
    {
      "cliente_id": "$input.json('$.cliente_id')",
      "barbero_id": "$input.json('$.barbero_id')",
      "fecha_reserva": "$input.json('$.fecha_reserva')"
    }
    EOF
  }
}

resource "aws_api_gateway_integration" "reserva_d_integracion" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.reservas_resource.id
  http_method             = aws_api_gateway_method.reserva_method_d.http_method
  integration_http_method = "DELETE"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.eliminar_reserva.invoke_arn
  request_parameters = {
    "integration.request.querystring.reserva_id" = "method.request.querystring.reserva_id"
  }
  request_templates = {
    "application/json" = <<EOF
    {
      "reserva_id": "$input.params('reserva_id')"
    }
    EOF
  }
}

#Metodos para actualizar la reserva
resource "aws_api_gateway_method" "update_reserva_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.reservas_resource.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "reserva_update_integracion" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.reservas_resource.id
  http_method             = aws_api_gateway_method.update_reserva_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.actualizar_reserva.invoke_arn

  request_templates = {
    "application/json" = <<EOF
    {
      "reserva_id": "$input.json('$.reserva_id')",
      "barbero_id": "$input.json('$.barbero_id')",
      "fecha_reserva": "$input.json('$.fecha_reserva')"
    }
    EOF
  }
}

#Metodos necesarios para la busqueda por cliente
resource "aws_api_gateway_resource" "reservas_resource_c" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "reservas"
}

resource "aws_api_gateway_method" "reserva_method_g_cliente" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.reservas_resource_c.id
  http_method   = "GET"
  authorization = "NONE"
  request_parameters = {
    "method.request.querystring.cliente_id" = true
  }
}

resource "aws_api_gateway_integration" "reserva_g_cliente_integracion" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.reservas_resource_c.id
  http_method             = aws_api_gateway_method.reserva_method_g_cliente.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.obtener_reserva.invoke_arn
  request_parameters = {
    "integration.request.querystring.reserva_id" = "method.request.querystring.cliente_id"
  }
  request_templates = {
    "application/json" = <<EOF
    {
      "cliente_id": "$input.params('cliente_id')"
    }
    EOF
  }
}

# Crear la implementación del API
resource "aws_api_gateway_deployment" "deployment1" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "dev"

}
