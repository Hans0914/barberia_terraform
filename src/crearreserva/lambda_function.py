import boto3
import os
import uuid
import json
from datetime import datetime

# Inicializar el cliente de DynamoDB
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMO_TABLE']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # Datos de entrada de la solicitud
    body = json.loads(event['body'])
    cliente_id = body['cliente_id']
    fecha_reserva = body['fecha_reserva']
    barbero_id = body['barbero_id']
    
    if not cliente_id or not fecha_reserva or not barbero_id:
        return {
            'statusCode': 400,
            'body': json.dumps('Faltan datos requeridos: cliente_id, fecha_reserva o servicio')
        }
    
    # Crear una reserva con un ID único
    reserva_id = str(uuid.uuid4())
    fecha_creacion = datetime.now().isoformat()
    
    # Guardar la reserva en DynamoDB
    item = {
        'reserva_id': reserva_id,
        'cliente_id': cliente_id,
        'fecha_reserva': fecha_reserva,
        'id_barbero': barbero_id,
        'fecha_creacion': fecha_creacion
    }
    
    try:
        table.put_item(Item=item)
        return {
            'statusCode': 200,
            'body': json.dumps(f'Reserva creada con éxito. ID: {reserva_id}')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error al crear la reserva: {str(e)}')
        }