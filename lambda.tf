resource "aws_lambda_function" "registrar_cliente" {
  function_name = "barberia_registrar_cliente"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  timeout = 60

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
  runtime       = "python3.11"             # Versión del runtime de Python
  role          = aws_iam_role.lambda_role.arn # ARN del rol IAM que otorga permisos a Lambda
  handler       = "lambda_function.lambda_handler" # Punto de entrada de la función Lambda
  timeout = 60

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
  runtime       = "python3.11"             # Versión del runtime de Python
  role          = aws_iam_role.lambda_role.arn # ARN del rol IAM que otorga permisos a Lambda
  handler       = "lambda_function.lambda_handler" # Punto de entrada de la función Lambda
  timeout = 60

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
  runtime       = "python3.11"             # Versión del runtime de Python
  role          = aws_iam_role.lambda_role.arn # ARN del rol IAM que otorga permisos a Lambda
  handler       = "lambda_function.lambda_handler" # Punto de entrada de la función Lambda
  timeout = 60

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
  runtime       = "python3.11"             # Versión del runtime de Python
  role          = aws_iam_role.lambda_role.arn # ARN del rol IAM que otorga permisos a Lambda
  handler       = "lambda_function.lambda_handler" # Punto de entrada de la función Lambda
  timeout = 60

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
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  timeout = 60

  filename         = ("src/obtenerreservascliente/lambda_function.zip")
  source_code_hash = filebase64sha256("src/obtenerreservascliente/lambda_function.zip")

  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.reservas_table.name
      BARBERO_TABLE = aws_dynamodb_table.barbero_table.name
    }
  }
}

resource "aws_lambda_function" "obtener_cliente" {
  function_name = "barberia_obtener_cliente"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  timeout = 60

  filename         = ("src/obtener_cliente/lambda_function.zip")
  source_code_hash = filebase64sha256("src/obtener_cliente/lambda_function.zip")

  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.clientes_table.name
    }
  }
}
resource "aws_lambda_function" "obtener_barberos" {
  function_name = "barberia_obtener_barberos"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  timeout = 60

  filename         = ("src/obtenerbarberos/lambda_function.zip")
  source_code_hash = filebase64sha256("src/obtenerbarberos/lambda_function.zip")

  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.barbero_table.name
    }
  }
}

resource "aws_lambda_function" "cargar_bucket" {
  function_name = "cargar_bucket"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  timeout = 60

  filename         = ("src/bucket/lambda_function.zip")
  source_code_hash = filebase64sha256("src/bucket/lambda_function.zip")

  layers = [ aws_lambda_layer_version.numpy_layer_4.arn ]

  environment {
    variables = {
      DYNAMO_TABLE = aws_dynamodb_table.regresion_table.name
    }
  }
  }

# Crear layer 

data "archive_file" "lambda_layer_zip" {
  type        = "zip"
  source_dir  = "src/layers"
  output_path = "src/layers.zip"
}

resource "aws_lambda_layer_version" "numpy_layer_4" {
  layer_name          = "lambda_layer"
  description         = "Layer with NumPy"
  compatible_runtimes = ["python3.9","python3.11"] # Agrega las versiones que necesites
  filename            = data.archive_file.lambda_layer_zip.output_path

  lifecycle {
    create_before_destroy = true
  }
}
