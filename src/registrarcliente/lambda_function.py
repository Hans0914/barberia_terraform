import os
import boto3
import uuid
import json

# Inicializar el cliente DynamoDB
dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('DYNAMO_TABLE')
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # Extraer los datos del evento
    try:
        body = json.loads(event['body'])
        nombre = body['nombre']
        correo = body['correo']
        celular = body['celular']
    except KeyError as e:
        return {
            "statusCode": 400,
            "body": f"Falta el campo requerido: {str(e)}"
        }

    # Generar un ID único corto
    id_cliente = str(uuid.uuid4())[:8]  # ID de 8 caracteres

    # Crear el elemento a insertar
    item = {
        'id_cliente': id_cliente,
        'nombre': nombre,
        'correo': correo,
        'celular': celular
    }

    # Insertar el elemento en la tabla
    try:
        table.put_item(Item=item)
        return {
            "statusCode": 200,
            "body": f"Cliente creado con ID: {id_cliente}"
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Error al guardar en DynamoDB: {str(e)}"
        }