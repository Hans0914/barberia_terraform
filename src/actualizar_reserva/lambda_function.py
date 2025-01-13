import boto3
import os
from datetime import datetime
import json

# Inicializar el cliente de DynamoDB
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMO_TABLE']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # Datos de entrada de la solicitud
    body = json.loads(event['body'])
    reserva_id = body['reserva_id']
    nuevo_barbero = body['barbero_id']
    nueva_fecha_reserva = body['fecha_reserva']
    
    if not reserva_id or not nueva_fecha_reserva or not nuevo_barbero:
        return {
            'statusCode': 400,
            'body': json.dumps('Faltan datos requeridos: reserva_id o fecha_reserva o barbero_id')
        }

    # Actualizar la reserva en DynamoDB
    try:
        response = table.update_item(
            Key={
                'reserva_id': reserva_id
            },
            UpdateExpression='set fecha_reserva = :nueva_fecha, id_barbero = :nuevo_barbero',
            ExpressionAttributeValues={
                ':nueva_fecha': nueva_fecha_reserva,
                ':nuevo_barbero': nuevo_barbero
            },
            ReturnValues='UPDATED_NEW'
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps(f'Reserva actualizada exitosamente: {response['Attributes']}')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error al actualizar la reserva: {str(e)}')
        }
