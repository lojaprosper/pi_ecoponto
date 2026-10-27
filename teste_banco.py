
import os
import mysql.connector
from dotenv import load_dotenv

# Carregar configurações do arquivo .env
load_dotenv()

# Conectar ao banco configurado
conexao = mysql.connector.connect(
    host=os.getenv("MYSQL_HOST", "127.0.0.1"),
    port=int(os.getenv("MYSQL_PORT", "3306")),
    user=os.getenv("MYSQL_USER", "ecoia_leitura"),
    password=os.getenv("MYSQL_PASSWORD", ""),
    database=os.getenv("MYSQL_DATABASE", "ecopontos_sp")
)

# Criar cursor
cursor = conexao.cursor()

# Identificar o banco selecionado
cursor.execute("SELECT DATABASE()")
print("Banco conectado:", cursor.fetchone()[0])

# Listar todas as tabelas acessíveis
cursor.execute("SHOW TABLES")

tabelas = cursor.fetchall()

print("\nTabelas disponíveis:")

for tabela in tabelas:
    print("-", tabela[0])

print("\nTotal de tabelas:", len(tabelas))

# Encerrar conexão
cursor.close()
conexao.close()
