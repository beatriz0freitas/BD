import mysql.connector
import psycopg2
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


# ---- CONEXÃO POSTGRESQL ---- #
def conectar_postgres():
    return psycopg2.connect(
        host="localhost",
        port=5432,
        user="SrPires",
        password="Pires",
        dbname="agroautoolivença"
    )


# ---- MIGRAÇÃO A PARTIR DE POSTGRESQL ---- #
def migrar_de_postgres_clientes(id_stand):
    pg_conn = conectar_postgres()
    pg_cursor = pg_conn.cursor()
    pg_cursor.execute('SET search_path TO "AgroAuto";')
    pg_cursor.execute("""
    SELECT 
        "nomeCompleto", 
        "dataNascimento", 
        "NIF", 
        "numeroDocumento", 
        "dataValidadeDocumento", 
        "rua", 
        "localidade", 
        "codigoPostal", 
        "numeroTelemovel", 
        "email", 
        "dataValidadeCarta", 
        "habilitacao", 
        "dataValidadeCartao", 
        "numeroCartao", 
        "CVV" 
    FROM "Cliente"
    """)


    mysql_conn = conectar_mysql()
    mysql_cursor = mysql_conn.cursor()

    for row in pg_cursor.fetchall():
        mysql_cursor.execute("""
            INSERT INTO Cliente (nomeCompleto, dataNascimento, NIF, numeroDocumento, dataValidadeDocumento, rua, localidade, codigoPostal,
                                 numeroTelemovel, email, dataValidadeCarta, habilitacao, dataValidadeCartao, numeroCartao, CVV)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, row)

    mysql_conn.commit()
    mysql_conn.close()
    pg_conn.close()
    print(f"Clientes migrados de PostgreSQL para stand {id_stand}.")

def migrar_de_postgres_tratores(id_stand):
    pg_conn = conectar_postgres()
    pg_cursor = pg_conn.cursor()
    pg_cursor.execute('SET search_path TO "AgroAuto";')
    
    pg_cursor.execute("""
        SELECT 
            "modelo", 
            "marca", 
            "precoDiario", 
            "estado" 
        FROM "Trator"
    """)

    mysql_conn = conectar_mysql()
    mysql_cursor = mysql_conn.cursor()

    for row in pg_cursor.fetchall():
        modelo, marca, precoDiario, estado = row
        mysql_cursor.execute("""
            INSERT INTO Trator (modelo, marca, precoDiario, estado, idStand)
            VALUES (%s, %s, %s, %s, %s)
        """, (modelo, marca, precoDiario, estado, id_stand))

    mysql_conn.commit()
    mysql_conn.close()
    pg_conn.close()
    print(f"Tratores migrados de PostgreSQL para stand {id_stand}.")

def migrar_de_postgres_funcionarios(id_stand):
    pg_conn = conectar_postgres()
    pg_cursor = pg_conn.cursor()
    pg_cursor.execute('SET search_path TO "AgroAuto";')
    pg_cursor.execute('SELECT "nomeCompleto", "numeroTelemovel" FROM "Funcionario"')


    mysql_conn = conectar_mysql()
    mysql_cursor = mysql_conn.cursor()

    for row in pg_cursor.fetchall():
        nome, tel = row
        mysql_cursor.execute("SELECT idFuncionario FROM Funcionario WHERE numeroTelemovel = %s", (tel,))
        if mysql_cursor.fetchone():
            print(f"Funcionário '{nome}' com nº {tel} já existe. A ignorar.")
            continue

        mysql_cursor.execute("""
            INSERT INTO Funcionario (nomeCompleto, numeroTelemovel, idStand)
            VALUES (%s, %s, %s)
        """, (nome, tel, id_stand))

    mysql_conn.commit()
    mysql_conn.close()
    pg_conn.close()
    print(f"Funcionários migrados de PostgreSQL para stand {id_stand}.")

def migrar_de_postgres_alugueres(id_stand):
    pg_conn = conectar_postgres()
    pg_cursor = pg_conn.cursor()
    pg_cursor.execute('SET search_path TO "AgroAuto";')
    pg_cursor.execute("""
    SELECT 
        "dataInicio",
        "dataTermino", 
        "precoTotal", 
        "metodoPagamento",
       "estadoPagamento", 
        "tipoPagamento", 
        "idCliente", 
        "idTrator", 
        "idFuncionario"
    FROM "Aluguer"
    """)



    mysql_conn = conectar_mysql()
    mysql_cursor = mysql_conn.cursor()

    for row in pg_cursor.fetchall():
        mysql_cursor.execute("""
            INSERT INTO Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento,
                                 estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, row)

    mysql_conn.commit()
    mysql_conn.close()
    pg_conn.close()
    print(f"Alugueres migrados de PostgreSQL para stand {id_stand}.")


# ---- MIGRAÇÃO CSV ---- #

def migrar_clientes_csv(ficheiro, id_stand):
    with open(ficheiro, newline='', encoding="utf-8") as f:
        reader = csv.DictReader(f)
        conn = conectar_mysql()
        cursor = conn.cursor()
        for linha in reader:
            cursor.execute("""
                INSERT INTO Cliente (nomeCompleto, dataNascimento, NIF, numeroDocumento, dataValidadeDocumento, rua, localidade, codigoPostal,
                                     numeroTelemovel, email, dataValidadeCarta, habilitacao, dataValidadeCartao, numeroCartao, CVV)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                linha["nomeCompleto"], linha["dataNascimento"], linha["NIF"], linha["numeroDocumento"],
                linha["dataValidadeDocumento"], linha["rua"], linha["localidade"], linha["codigoPostal"],
                linha["numeroTelemovel"], linha["email"], linha["dataValidadeCarta"], linha["habilitacao"],
                linha["dataValidadeCartao"], linha["numeroCartao"], linha["CVV"]
            ))
        conn.commit()
        conn.close()
        print(f"Clientes CSV migrados com sucesso para stand {id_stand}.")


def migrar_tratores_csv(ficheiro, id_stand):
    with open(ficheiro, newline='', encoding="utf-8") as f:
        reader = csv.DictReader(f)
        conn = conectar_mysql()
        cursor = conn.cursor()
        for linha in reader:
            cursor.execute("""
                INSERT INTO Trator (modelo, marca, precoDiario, estado, idStand)
                VALUES (%s, %s, %s, %s, %s)
            """, (linha["modelo"], linha["marca"], float(linha["precoDiario"]), linha["estado"], id_stand))
        conn.commit()
        conn.close()
        print(f"Tratores CSV migrados com sucesso para stand {id_stand}.")


def migrar_alugueres_csv(ficheiro, id_stand):
    with open(ficheiro, newline='', encoding="utf-8") as f:
        reader = csv.DictReader(f)
        conn = conectar_mysql()
        cursor = conn.cursor()
        for linha in reader:
            cursor.execute("""
                INSERT INTO Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento,
                                     estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                linha["dataInicio"], linha["dataTermino"], float(linha["precoTotal"]),
                linha["metodoPagamento"], linha["estadoPagamento"], linha["tipoPagamento"],
                linha["idCliente"], linha["idTrator"], linha["idFuncionario"]
            ))
        conn.commit()
        conn.close()
        print(f"Alugueres CSV migrados com sucesso para stand {id_stand}.")

def migrar_funcionarios_csv(ficheiro, id_stand):
    import csv

    with open(ficheiro, newline='', encoding="utf-8") as f:
        reader = csv.DictReader(f)
        conn = conectar_mysql()
        cursor = conn.cursor()

        for linha in reader:
            nome = linha["nomeCompleto"]
            tel = linha["numeroTelemovel"]

            cursor.execute("SELECT idFuncionario FROM Funcionario WHERE numeroTelemovel = %s", (tel,))
            if cursor.fetchone():
                print(f"Funcionário '{nome}' com nº {tel} já existe. A ignorar.")
                continue

            cursor.execute("""
                INSERT INTO Funcionario (nomeCompleto, numeroTelemovel, idStand)
                VALUES (%s, %s, %s)
            """, (nome, tel, id_stand))

        conn.commit()
        conn.close()
        print(f"Funcionários CSV migrados com sucesso para stand {id_stand}.")




# ---- MIGRAÇÃO JSON ---- #

def migrar_tratores_json(ficheiro, id_stand):
    with open(ficheiro, encoding="utf-8") as f:
        tratores = json.load(f)
        conn = conectar_mysql()
        cursor = conn.cursor()
        for t in tratores:
            cursor.execute("""
                INSERT INTO Trator (modelo, marca, precoDiario, estado, idStand)
                VALUES (%s, %s, %s, %s, %s)
            """, (t["modelo"], t["marca"], float(t["precoDiario"]), t["estado"], id_stand))
        conn.commit()
        conn.close()
        print(f"Tratores JSON migrados com sucesso para stand {id_stand}.")


def migrar_clientes_json(ficheiro, id_stand):
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
        print(f"Clientes JSON migrados com sucesso para stand {id_stand}.")



def migrar_alugueres_json(ficheiro, id_stand):
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
        print(f"Alugueres JSON migrados com sucesso para stand {id_stand}.")



def migrar_funcionarios_json(ficheiro, id_stand):
    import json

    with open(ficheiro, encoding="utf-8") as f:
        funcionarios = json.load(f)
        conn = conectar_mysql()
        cursor = conn.cursor()

        for f in funcionarios:
            nome = f["nomeCompleto"]
            tel = f["numeroTelemovel"]

            cursor.execute("SELECT idFuncionario FROM Funcionario WHERE numeroTelemovel = %s", (tel,))
            if cursor.fetchone():
                print(f"Funcionário '{nome}' com nº {tel} já existe. A ignorar.")
                continue

            cursor.execute("""
                INSERT INTO Funcionario (nomeCompleto, numeroTelemovel, idStand)
                VALUES (%s, %s, %s)
            """, (nome, tel, id_stand))

        conn.commit()
        conn.close()
        print(f"Funcionários JSON migrados com sucesso para stand {id_stand}.")


# ---- ASSOCIAÇÃO STAND FONTE DE DADOS ---- #
stands_migracao = {
    1: "bd",
    2: "csv",
    3: "json"
}


# ---- CHAMADA DAS MIGRAÇÕES ---- #
if __name__ == "__main__":
    for id_stand, tipo in stands_migracao.items():
        print(f"\n>>> A migrar dados para stand {id_stand} usando {tipo.upper()}")

        if tipo == "csv":
            migrar_clientes_csv(f"csv/clientes.csv", id_stand)
            migrar_tratores_csv(f"csv/tratores.csv", id_stand)
            migrar_funcionarios_csv(f"csv/funcionarios.csv", id_stand)
            migrar_alugueres_csv(f"csv/alugueres.csv", id_stand)

        elif tipo == "json":
            migrar_clientes_json(f"json/clientes.json", id_stand)
            migrar_tratores_json(f"json/tratores.json", id_stand)
            migrar_funcionarios_json(f"json/funcionarios.json", id_stand)
            migrar_alugueres_json(f"json/alugueres.json", id_stand)

        elif tipo == "bd":
            migrar_de_postgres_clientes(id_stand)
            migrar_de_postgres_tratores(id_stand)
            migrar_de_postgres_funcionarios(id_stand)
            migrar_de_postgres_alugueres(id_stand)

    print("\n>>> Todas as migrações foram concluídas com sucesso.")