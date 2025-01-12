resource "aws_lambda_function" "registrar_cliente" {
  function_name = "barberia_registrar_cliente"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  timeout = 10

  # Sube el archivo ZIP
  filename      = "src/registrarcliente/lambda_function.zip"
  source_code_hash = filebase64sha256("src/registrarcliente/lambda_function.zip")

  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.clientes_table.name
    }
  }
}

resource "aws_lambda_function" "crear_reserva" {
  function_name = "barberia_crear_reserva" # Nombre único de la función Lambda
  runtime       = "python3.12"             # Versión del runtime de Python
  role          = aws_iam_role.lambda_role.arn # ARN del rol IAM que otorga permisos a Lambda
  handler       = "lambda_function.lambda_handler" # Punto de entrada de la función Lambda

  # Ruta al archivo ZIP del código fuente
  filename         = "src/crearreserva/lambda_function.zip"
  source_code_hash = filebase64sha256("src/crearreserva/lambda_function.zip")

  # Variables de entorno para la función Lambda
  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.reservas_table.name # Nombre de la tabla DynamoDB para las reservas
    }
  }
}

resource "aws_lambda_function" "actualizar_reserva" {
  function_name = "barberia_actualizar_reserva" # Nombre único de la función Lambda
  runtime       = "python3.12"             # Versión del runtime de Python
  role          = aws_iam_role.lambda_role.arn # ARN del rol IAM que otorga permisos a Lambda
  handler       = "lambda_function.lambda_handler" # Punto de entrada de la función Lambda

  # Ruta al archivo ZIP del código fuente
  filename         = "src/actualizar_reserva/lambda_function.zip"
  source_code_hash = filebase64sha256("src/actualizar_reserva/lambda_function.zip")

  # Variables de entorno para la función Lambda
  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.reservas_table.name # Nombre de la tabla DynamoDB para las reservas
    }
  }
}


resource "aws_lambda_function" "obtener_reserva" {
  function_name = "barberia_obtener_reserva" # Nombre único de la función Lambda
  runtime       = "python3.12"             # Versión del runtime de Python
  role          = aws_iam_role.lambda_role.arn # ARN del rol IAM que otorga permisos a Lambda
  handler       = "lambda_function.lambda_handler" # Punto de entrada de la función Lambda

  # Ruta al archivo ZIP del código fuente
  filename         = "src/obtener_reserva/lambda_function.zip"
  source_code_hash = filebase64sha256("src/obtener_reserva/lambda_function.zip")

  # Variables de entorno para la función Lambda
  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.reservas_table.name # Nombre de la tabla DynamoDB para las reservas
    }
  }
}

resource "aws_lambda_function" "eliminar_reserva" {
  function_name = "barberia_eliminar_reserva" # Nombre único de la función Lambda
  runtime       = "python3.12"             # Versión del runtime de Python
  role          = aws_iam_role.lambda_role.arn # ARN del rol IAM que otorga permisos a Lambda
  handler       = "lambda_function.lambda_handler" # Punto de entrada de la función Lambda

  # Ruta al archivo ZIP del código fuente
  filename         = "src/eliminar_reserva/lambda_function.zip"
  source_code_hash = filebase64sha256("src/eliminar_reserva/lambda_function.zip")

  # Variables de entorno para la función Lambda
  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.reservas_table.name # Nombre de la tabla DynamoDB para las reservas
    }
  }
}


resource "aws_lambda_function" "obtener_reservas_cliente" {
  function_name = "barberia_obtener_reservas_cliente"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"

  filename         = ("src/obtenerreservascliente/lambda_function.zip")
  source_code_hash = filebase64sha256("src/obtenerreservascliente/lambda_function.zip")

  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.reservas_table.name
    }
  }
}

resource "aws_lambda_function" "obtener_barberos" {
  function_name = "barberia_obtener_barberos"
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"

  filename         = ("src/obtenerbarberos/lambda_function.zip")
  source_code_hash = filebase64sha256("src/obtenerbarberos/lambda_function.zip")

  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.barbero_table.name
    }
  }
}
