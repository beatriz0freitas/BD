import mysql.connector
import csv
import json

# ---- CONEXÃO MYSQL ---- #
def conectar_mysql():
    return mysql.connector.connect(
        host="localhost",
        port=3306,
        user="root",
        password="Benfica4",
        database="AgroAuto"
    )

# ---- MIGRAÇÃO CLIENTES ---- #
def migrar_clientes_csv(ficheiro):
    with open(ficheiro, newline='', encoding="utf-8") as f:
        reader = csv.reader(f)
        next(reader)  # ignorar cabeçalho
        conn = conectar_mysql()
        cursor = conn.cursor()
        for linha in reader:
            cursor.execute("""
                INSERT INTO Cliente (nomeCompleto, dataNascimento, NIF, numeroDocumento, dataValidadeDocumento, rua, localidade, codigoPostal,
         numeroTelemovel, email, dataValidadeCarta, habilitacao, dataValidadeCartao, numeroCartao, CVV)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, linha)
        conn.commit()
        conn.close()
        print("Clientes CSV migrados com sucesso.")

def migrar_clientes_json(ficheiro):
    with open(ficheiro, encoding="utf-8") as f:
        clientes = json.load(f)
        conn = conectar_mysql()
        cursor = conn.cursor()
        for c in clientes:
            cursor.execute("""
                INSERT INTO Cliente (
                    nomeCompleto, dataNascimento, NIF, numeroDocumento,
                    dataValidadeDocumento, rua, localidade, CodigoPostal,
                    numeroTelemovel, email, dataValidadeCarta, habilitacao,
                    dataValidadeCartao, numeroCartao, CVV
                )
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                c["nomeCompleto"], c["dataNascimento"], c["NIF"], c["numeroDocumento"],
                c["dataValidadeDocumento"], c["rua"], c["localidade"], c["codigoPostal"],
                c["numeroTelemovel"], c["email"], c["dataValidadeCarta"], c["habilitacao"],
                c["dataValidadeCartao"], c["numeroCartao"], c["CVV"]
            ))
        conn.commit()
        conn.close()
        print("Clientes JSON migrados com sucesso.")

# ---- MIGRAÇÃO TRATORES ---- #
def migrar_tratores_csv(ficheiro):
    with open(ficheiro, newline='', encoding="utf-8") as f:
        reader = csv.reader(f)
        next(reader)
        conn = conectar_mysql()
        cursor = conn.cursor()
        for linha in reader:
            modelo, marca, preco, estado, id_stand = linha
            cursor.execute("""
                INSERT INTO Trator (modelo, marca, precoDiario, estado, idStand)
                VALUES (%s, %s, %s, %s, %s)
            """, (modelo, marca, float(preco), estado, int(id_stand)))
        conn.commit()
        conn.close()
        print("Tratores CSV migrados com sucesso.")

def migrar_tratores_json(ficheiro):
    with open(ficheiro, encoding="utf-8") as f:
        tratores = json.load(f)
        conn = conectar_mysql()
        cursor = conn.cursor()
        for t in tratores:
            cursor.execute("""
                INSERT INTO Trator (modelo, marca, precoDiario, estado, idStand)
                VALUES (%s, %s, %s, %s, %s)
            """, (t["modelo"], t["marca"], float(t["precoDiario"]), t["estado"], int(t["idStand"])))
        conn.commit()
        conn.close()
        print("Tratores JSON migrados com sucesso.")

# ---- MIGRAÇÃO ALUGUERES ---- #
def migrar_alugueres_csv(ficheiro):
    with open(ficheiro, newline='', encoding="utf-8") as f:
        reader = csv.reader(f)
        next(reader)
        conn = conectar_mysql()
        cursor = conn.cursor()
        for linha in reader:
            cursor.execute("""
                INSERT INTO Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento,
                                     estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, linha)
        conn.commit()
        conn.close()
        print("Alugueres CSV migrados com sucesso.")

def migrar_alugueres_json(ficheiro):
    with open(ficheiro, encoding="utf-8") as f:
        alugueres = json.load(f)
        conn = conectar_mysql()
        cursor = conn.cursor()
        for a in alugueres:
            cursor.execute("""
                INSERT INTO Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento,
                                     estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                a["dataInicio"], a["dataTermino"], float(a["precoTotal"]), a["metodoPagamento"],
                a["estadoPagamento"], a["tipoPagamento"], int(a["idCliente"]),
                int(a["idTrator"]), int(a["idFuncionario"])
            ))
        conn.commit()
        conn.close()
        print("Alugueres JSON migrados com sucesso.")

# ---- CHAMADA DAS MIGRAÇÕES ---- #
if __name__ == "__main__":
    try:
        # Clientes
        migrar_clientes_csv("csv/clientes.csv")
        migrar_clientes_json("json/clientes.json")

        # Tratores
        migrar_tratores_csv("csv/tratores.csv")
        migrar_tratores_json("json/tratores.json")

        # Alugueres
        migrar_alugueres_csv("csv/alugueres.csv")
        migrar_alugueres_json("json/alugueres.json")

        print("Todas as migrações concluídas.")
    except Exception as e:
        print("Erro durante migração:", e)
