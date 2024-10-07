import mysql.connector
import json
import time
from datetime import timedelta  
import datetime  

def connect_to_database():
    try:
        connection = mysql.connector.connect(
            host='localhost',
            user='root',
            password='', 
            database='transporte_onibus'
        )
        
        if connection.is_connected():
            cursor = connection.cursor()
            cursor.execute('SELECT * FROM linhas_onibus')  
            rows = cursor.fetchall()
            cursor.close()
            connection.close()

           
            data = []
            for row in rows:
                
                horario = row[2]  
                if isinstance(horario, timedelta):
                    total_seconds = int(horario.total_seconds())
                    hours, remainder = divmod(total_seconds, 3600)
                    minutes, _ = divmod(remainder, 60)
                    horario_str = f"{hours:02}:{minutes:02}"
                else:
                    horario_str = str(horario) 

                data.append({
                    'id': row[0],  
                    'codigo_onibus': row[1],  
                    'horario': horario_str,  
                    'marca': row[3],  
                    'placa': row[4],  
                    'local': row[5],
                    'vai_passar': row[6]
                })
                
            return data  

    except mysql.connector.Error as err:
        print(f'Erro: {err}')
        return []

def save_data_to_json(data):
    with open('dados_onibus.json', 'w') as f:
        json.dump(data, f)

while True:
    dados = connect_to_database()
    
    if dados:
        save_data_to_json(dados)
        print("Dados atualizados com sucesso.")
    else:
        print("Nenhum dado encontrado ou erro na conexão.")

    time.sleep(240)  