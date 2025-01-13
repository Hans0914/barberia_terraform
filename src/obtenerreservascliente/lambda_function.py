import boto3
import os
import json

# Inicializar el cliente de DynamoDB
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMO_TABLE']
barbero_table = os.environ['BARBERO_TABLE']
table = dynamodb.Table(table_name)
table_barbero = dynamodb.Table(barbero_table)

def lambda_handler(event, context):
    # Obtener el ID del cliente
    query_params = event['queryStringParameters']
    cliente_id = query_params['cliente_id']
    
    if not cliente_id:
        return {
            'statusCode': 400,
            'body': json.dumps('Falta el ID del cliente (cliente_id)')
        }
    
    # Escanear DynamoDB para buscar todas las reservas con el cliente_id
    try:
        response = table.scan(
            FilterExpression='cliente_id = :cliente_id',
            ExpressionAttributeValues={
                ':cliente_id': cliente_id
            }
        )
        
        reservas = response.get('Items', [])

        reservas_response = []
        # Obtener los nombres de los barberos asociados a las reservas
        for reserva in reservas:
            barbero_id = reserva['id_barbero']
            barbero_response = table_barbero.get_item(Key={'barbero_id': barbero_id})
            barbero = barbero_response.get('Item', {})
            
            reserva["nombre_barbero"] = barbero.get('nombre', 'Barbero no encontrado')
            reservas_response.append(reserva)
        return {
            'statusCode': 200,
            'body': json.dumps(reservas_response) if reservas_response else json.dumps('No se encontraron reservas')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error al obtener las reservas: {str(e)}')
        }
