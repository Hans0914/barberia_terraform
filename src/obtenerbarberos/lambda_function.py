import boto3
import os
import json
# Inicializar el cliente de DynamoDB
dynamodb = boto3.resource("dynamodb")
table_name = os.environ["DYNAMO_TABLE"]
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # Obtener el ID del cliente
    try:
        # Escanear la tabla para obtener todos los registros
        response = table.scan()
        barberos = response.get('Items', [])

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Lista de barberos obtenida exitosamente',
                'barberos': barberos
            })
        }
    except Exception as e:
        print(f"Error al obtener los barberos: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'message': 'Error interno del servidor'
            })
        }