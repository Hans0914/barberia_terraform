import boto3
import os

# Inicializar el cliente de DynamoDB
dynamodb = boto3.resource("dynamodb")
table_name = os.environ["DYNAMO_TABLE"]
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # Obtener el ID de la reserva a eliminar
    reserva_id = event.get("reserva_id")
    
    if not reserva_id:
        return {
            "statusCode": 400,
            "body": "Falta el ID de la reserva (reserva_id)"
        }
    
    # Eliminar la reserva de DynamoDB
    try:
        response = table.delete_item(
            Key={
                "reserva_id": reserva_id
            },
            ReturnValues="ALL_OLD"
        )
        
        # Verificar si se eliminó un elemento
        if "Attributes" in response:
            return {
                "statusCode": 200,
                "body": f"Reserva eliminada con éxito: {response['Attributes']}"
            }
        else:
            return {
                "statusCode": 404,
                "body": f"No se encontró la reserva con ID: {reserva_id}"
            }
    except Exception as e:
        return {
            "statusCode": 500,
            "body": f"Error al eliminar la reserva: {str(e)}"
        }
