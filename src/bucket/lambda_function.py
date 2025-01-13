import json

def lambda_handler(event, context):
    print("Evento recibido:", json.dumps(event))
    return {
        "statusCode": 200,
        "body": json.dumps("¡Archivo subido al bucket!")
    }
