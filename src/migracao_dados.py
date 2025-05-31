import mysql.connector
import csv
import json

# ---- CONEXÃO MYSQL ---- #

def conectar_mysql():
    return mysql.connector.connect(
        host="localhost",       # ou "127.0.0.1"
        port=3306,  
        user="root",
        password="Benfica4",
        database="AgroAuto"
    )

# ---- MIGRAÇÃO TRATORES (CSV) ---- #

def migrar_tratores():
    mysql_conn = conectar_mysql()
    cursor = mysql_conn.cursor()

    with open("tratores.csv", newline='', encoding="utf-8") as f:
        reader = csv.reader(f)
        next(reader)  # ignorar cabeçalho
        for row in reader:
            idTrator,modelo, marca, preco_diario, estado, id_stand = row
            cursor.execute("""
                INSERT INTO Trator (idTrator,modelo, marca, precoDiario, estado, idStand)
                VALUES (%s, %s, %s, %s, %s,%s)
            """, (idTrator,modelo, marca, float(preco_diario), estado, int(id_stand)))

    mysql_conn.commit()
    mysql_conn.close()
    print("Tratores migrados com sucesso.")

# ---- MIGRAÇÃO ALUGUERES (JSON) ---- #

def migrar_alugueres():
    with open("alugueres.json", "r", encoding="utf-8") as f:
        alugueres = json.load(f)

    mysql_conn = conectar_mysql()
    cursor = mysql_conn.cursor()

    for aluguer in alugueres:
        cursor.execute("""
            INSERT INTO Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento,
                                 estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            aluguer["dataInicio"],
            aluguer["dataTermino"],
            float(aluguer["precoTotal"]),
            aluguer["metodoPagamento"],
            aluguer["estadoPagamento"],
            aluguer["tipoPagamento"],
            int(aluguer["idCliente"]),
            int(aluguer["idTrator"]),
            int(aluguer["idFuncionario"])
        ))

    mysql_conn.commit()
    mysql_conn.close()
    print("Alugueres migrados com sucesso.")

# ---- MAIN ---- #

if __name__ == "__main__":
    try:
        migrar_tratores()
        #migrar_alugueres()
        print("Migração concluída com sucesso.")
    except Exception as e:
        print("Erro durante a migração:", e)
