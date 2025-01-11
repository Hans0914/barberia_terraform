import boto3
import os

# Inicializar el cliente de DynamoDB
dynamodb = boto3.resource("dynamodb")
table_name = os.environ["DYNAMO_TABLE"]
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # Obtener el ID del cliente
    cliente_id = event.get("cliente_id")
    
    if not cliente_id:
        return {
            "statusCode": 400,
            "body": "Falta el ID del cliente (cliente_id)"
        }
    
    # Escanear DynamoDB para buscar todas las reservas con el cliente_id
    try:
        response = table.scan(
            FilterExpression="cliente_id = :cliente_id",
            ExpressionAttributeValues={
                ":cliente_id": cliente_id
            }
        )
        
        reservas = response.get("Items", [])
        return {
            "statusCode": 200,
            "body": reservas
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Error al obtener las reservas: {str(e)}"
        }
