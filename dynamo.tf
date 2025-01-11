resource "aws_dynamodb_table" "clientes_table" {
  name         = "barberia_clientes"
  billing_mode = "PAY_PER_REQUEST" 

  # Clave primaria
  hash_key = "id_cliente"
  
   # Atributos de la tabla
  attribute {
    name = "id_cliente"
    type = "S"
  }
}

resource "aws_dynamodb_table" "reservas_table" {
  name         = "barberia_reservas"
  hash_key     = "reserva_id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "reserva_id"
    type = "S"
  }
}

resource "aws_dynamodb_table" "barbero_table" {
  name         = "barberia_barberos"
  hash_key     = "barbero_id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "barbero_id"
    type = "S"
  }
}

