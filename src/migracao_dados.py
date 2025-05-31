import sqlite3
import mysql.connector
import csv
import json

# ---- CONEXÕES ---- #

def conectar_mysql():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="1234",
        database="AgroAuto"
    )

def conectar_sqlite():
    return sqlite3.connect('clientes.db')


# ---- MIGRAÇÃO CLIENTES (SQLite) ---- #

def migrar_clientes():
    sqlite_conn = conectar_sqlite()
    mysql_conn = conectar_mysql()

    cursor_sqlite = sqlite_conn.cursor()
    cursor_mysql = mysql_conn.cursor()

    cursor_sqlite.execute("""
        SELECT NIF, nomeCompleto, numeroTelemovel, dataNascimento,
               numeroDocumento, dataValidadeDocumento, rua,
               localidade, CodigoPostal, email, dataValidadeCarta,
               habilitacao, dataValidadeCartao, numeroCartao, CVV
        FROM Cliente
    """)
    clientes = cursor_sqlite.fetchall()

    for cliente in clientes:
        try:
            cursor_mysql.execute("""
                INSERT INTO Cliente (NIF, nomeCompleto, numeroTelemovel, dataNascimento,
                                     numeroDocumento, dataValidadeDocumento, rua,
                                     localidade, CodigoPostal, email, dataValidadeCarta,
                                     habilitacao, dataValidadeCartao, numeroCartao, CVV)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE
                    nomeCompleto = VALUES(nomeCompleto),
                    numeroTelemovel = VALUES(numeroTelemovel),
                    email = VALUES(email)
            """, cliente)
        except mysql.connector.Error as err:
            print(f"Erro ao migrar cliente com NIF {cliente[0]}: {err}")

    mysql_conn.commit()
    print("Clientes migrados com sucesso.")

    sqlite_conn.close()
    mysql_conn.close()



# ---- MIGRAÇÃO TRATORES (CSV) ---- #

def migrar_tratores():
    mysql_conn = conectar_mysql()
    cursor = mysql_conn.cursor()

    with open("tratores.csv", newline='', encoding="utf-8") as f:
        reader = csv.reader(f)
        next(reader)  # ignorar cabeçalho
        for row in reader:
            modelo, marca, preco_diario, estado, id_stand = row
            cursor.execute("""
                INSERT INTO Trator (modelo, marca, preco_diario, estado, id_stand)
                VALUES (%s, %s, %s, %s, %s)
            """, (modelo, marca, float(preco_diario), estado, int(id_stand)))

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
        migrar_clientes()
        migrar_tratores()
        migrar_alugueres()
        print("Migração concluída com sucesso.")
    except Exception as e:
        print("Erro durante a migração:", e)
