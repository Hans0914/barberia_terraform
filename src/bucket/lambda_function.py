import os
import sys
import json
import boto3
import numpy as np
import csv
from io import StringIO
from decimal import Decimal

class RegresionMultiple():
  def __init__(self,X,Y):
    self.fil,self.col=X.shape
    self.X=X
    self.Y=Y
    self.A=self.Matriz()
    self.Sol=self.SMC()
  
  def Matriz(self):
    A=np.ones((self.fil,self.col+1))
    A[:,1:]=self.X
    return A
  
  def SMC(self):
    Sol=np.linalg.inv(self.A.T@self.A)@self.A.T@self.Y
    return Sol

  def Evaluar(self,Datos):
    y_hat=self.Sol[0,0]
    for i in range(self.col):
      y_hat += self.Sol[i+1,0] * Datos[:,i]
    return y_hat
  
  def ErrorCuadratico(self):
    y_hat=self.Evaluar(self.X)
    Error=sum((self.Y[:,0]-y_hat)**2)
    return Error
  
  def R2(self,y_hat,y,P="N"):
    y_bar=np.mean(y)
    n=len(y)
    if str(P)=="N":
      num=sum((y_hat-y_bar)**2)
      dem=sum((y[:,0]-y_bar)**2)
      R2=num/dem
    else: 
      num=sum((y_hat-y[:,0])**2)
      dem=sum((y[:,0]-y_bar)**2)
      R2=1-((n-1)/(n-P))*(num/dem)
    return R2

  def ValidacionCruzada(self,k,P="N"):
    indices = np.random.permutation(self.fil) #Se hace una permutación aleatoria de los (indices)individuos
    particiones = [indices[j::k] for j in range(k)]
    resultados = []
    for i in range(k):
      prueba = particiones[i]
      entrenamiento = np.concatenate([particiones[j] for j in range(k) if j != i])
      x_entrenamiento, y_entrenamiento = self.X[entrenamiento], self.Y[entrenamiento]
      x_prueba, y_prueba = self.X[prueba], self.Y[prueba]
      Modelo_i = RegresionMultiple(x_entrenamiento, y_entrenamiento)
      y_hat_prueba = Modelo_i.Evaluar(x_prueba)
      if str(P)=="N":
        R2 = Modelo_i.R2(y_hat_prueba, y_prueba)
      else:
        R2 = Modelo_i.R2(y_hat_prueba, y_prueba,P)
      resultados.append(R2)
    R2_promedio = sum(resultados)/len(resultados)
    return R2_promedio


# dynamodb = boto3.resource('dynamodb')
# table_name = os.environ['DYNAMO_TABLE']
# table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    print(json.dumps(event))
    # Configuración de servicios AWS
    s3_client = boto3.client('s3')
    dynamodb = boto3.resource('dynamodb')
    
    # Configurar bucket y tabla DynamoDB
    table_name = "regresion_T"  # Asegúrate de que este es el nombre correcto de la tabla DynamoDB
    table = dynamodb.Table(table_name)

    # Obtener información del archivo cargado desde el evento
    bucket_name = event['Records'][0]['s3']['bucket']['name']
    file_key = event['Records'][0]['s3']['object']['key']

    # Descargar el archivo CSV
    try:
        response = s3_client.get_object(Bucket=bucket_name, Key=file_key)
        lines = response['Body'].read().decode('utf-8').splitlines()
        print("Archivo descargado correctamente.")
        print("Lineas: " +str(lines))
            
        # Leer el CSV
        csv_reader = csv.reader(lines)
        print("Leyendo archivo CSV...")
        headers = next(csv_reader)  # Primera fila como encabezados
        data = np.array([list(map(float, row)) for row in csv_reader])  # Convertir datos a numpy

        print("Datos leídos:", data.shape)
        # Variables independientes (X) y dependiente (Y)
        X = data[:, :-1]  # Todas las columnas menos la última
        Y = data[:, -1:]  # Última columna
        print("Variables independientes (X):", X.shape)
        print("Variable dependiente (Y):", Y.shape)
        # Realizar regresión lineal múltiple
        modelo = RegresionMultiple(X, Y)
        y_hat = modelo.Evaluar(X)
        r2 = modelo.R2(y_hat, Y)

        # Preparar datos para DynamoDB
        item = {
            'ArchivoProcesado': file_key,  # Nombre del archivo como identificador
            'Coeficientes': {f'beta_{i}': Decimal(str(beta)) for i, beta in enumerate(modelo.Sol.flatten())},
            'R2': Decimal(str(r2))
        }

        print("Datos preparados para DynamoDB:", item)

        # Guardar resultados en DynamoDB
        try:
            table.put_item(Item=item)
            print(f"Resultados guardados: {item}")
        except Exception as e:
            print(f"Error al guardar en DynamoDB: {e}")
            return {"statusCode": 500, "body": "Error al guardar los resultados en DynamoDB."}

        return {"statusCode": 200, "body": "Modelo procesado correctamente y resultados almacenados en DynamoDB."}
    except Exception as e:
        print(f"Error al acceder al archivo: {e}")
        return {"statusCode": 500, "body": "Error al acceder al archivo."}