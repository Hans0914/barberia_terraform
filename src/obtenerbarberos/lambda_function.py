import boto3
import os

# Inicializar el cliente de DynamoDB
dynamodb = boto3.resource("dynamodb")
table_name = os.environ["DYNAMO_TABLE"]
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # Obtener el ID del cliente
    barbero_id = event.get("barbero_id")
    
    if not barbero_id:
        return {
            "statusCode": 400,
            "body": "Falta el ID del cliente (barbero_id)"
        }
    
    # Escanear DynamoDB para buscar todas las barberos con el barbero_id
    try:
        response = table.scan(
            FilterExpression="barbero_id = :barbero_id",
            ExpressionAttributeValues={
                ":barbero_id": barbero_id
            }
        )
        
        barberos = response.get("Items", [])
        return {
            "statusCode": 200,
            "body": barberos
        }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Error al obtener las barberos: {str(e)}"
        }
