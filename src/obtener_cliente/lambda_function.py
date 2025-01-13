import boto3
import os
import json

# Inicializar el cliente de DynamoDB
dynamodb = boto3.resource('dynamodb')
table_name = os.environ['DYNAMO_TABLE']
table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    # Obtener el ID del cliente
    query_params = event['queryStringParameters']
    celular = query_params['celular']
    
    if not celular:
        return {
            'statusCode': 400,
            'body': json.dumps('Falta el celular del cliente (celular)')
        }
    
    # Escanear DynamoDB para buscar todas las reservas con el celular
    try:
        response = table.scan(
            FilterExpression='celular = :celular',
            ExpressionAttributeValues={
                ':celular': celular
            }
        )
        
        clientes = response.get('Items', [])
        return {
            'statusCode': 200,
            'body': json.dumps(clientes[0]) if clientes else json.dumps('No se encontro cliente')
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error al obtener las reservas: {str(e)}')
        }
