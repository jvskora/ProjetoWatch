from faker import Faker
import psycopg2
import random
from datetime import datetime, timedelta, date

# configuração da conexão
DB_HOST = 'localhost'
DB_NAME = 'watch_streaming_db'
DB_USER = 'postgres'
DB_PASSWORD = '123'

conn = psycopg2.connect(
    host=DB_HOST,
    dbname=DB_NAME,
    user=DB_USER,
    password=DB_PASSWORD
)
cur = conn.cursor()
fake = Faker('pt_BR')

# mapear data para id_data
def map_data_to_id(data):
    cur.execute("SELECT id_data FROM dim_data WHERE data = %s;", (data,))
    result = cur.fetchone()
    return result[0] if result else None

# limpar todas as tabelas para rodar o código novamente
cur.execute("""
    TRUNCATE TABLE
        fato_visualizacoes,
        fato_acessos,
        fato_atendimentos,
        fato_planos_contratados,
        dim_usuario,
        dim_provedor,
        dim_conteudo,
        dim_dispositivo,
        dim_data
    RESTART IDENTITY CASCADE;
""")
conn.commit()

# criar dim_data
start_date = date(2024, 1, 1)
end_date = date(2025, 12, 31)
current_date = start_date
while current_date <= end_date:
    cur.execute("""
        INSERT INTO dim_data (data, ano, trimestre, mes, dia, semana, dia_da_semana, nome_do_mes)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
    """, (
        current_date,
        current_date.year,
        (current_date.month - 1) // 3 + 1,
        current_date.month,
        current_date.day,
        int(current_date.strftime('%U')),
        current_date.strftime('%A'),
        current_date.strftime('%B')
    ))
    current_date += timedelta(days=1)
conn.commit()

# criar provedores
provedores = [
    ('StreamMax', '12345678000101', 'SP', 2000),
    ('MegaPlay', '23456789000112', 'RJ', 1800),
    ('NetView', '34567890000123', 'MG', 1500),
    ('PlayNow', '45678901000134', 'RS', 1700),
    ('SuperTV', '56789012000145', 'BA', 1300),
    ('UltraFlix', '67890123000156', 'SC', 1100),
    ('BrasilStream', '78901234000167', 'PR', 1250),
    ('FastView', '89012345000178', 'PE', 1400),
    ('NowPlus', '90123456000189', 'DF', 900),
    ('InfinityPlay', '01234567000190', 'CE', 1000)
]
for i, (nome, cnpj, estado, qtd) in enumerate(provedores, start=1):
    cur.execute("""
        INSERT INTO dim_provedor (id_provedor, nome, cnpj, estado, qtd_clientes)
        VALUES (%s, %s, %s, %s, %s);
    """, (i, nome, cnpj, estado, qtd))

# criar usuários
for i in range(1, 1001):
    id_provedor = random.choices(range(1, 11), weights=[20,18,15,14,10,8,7,5,2,1])[0]
    faixa_etaria = random.choices(['18-24','25-34','35-44','45-54','55+'], weights=[30,35,20,10,5])[0]
    genero = random.choice(['Masculino', 'Feminino', 'Outro'])
    nome = fake.name_male() if genero == 'Masculino' else fake.name_female() if genero == 'Feminino' else fake.name()
    cidade = fake.city()
    cur.execute("""
        INSERT INTO dim_usuario (id_usuario, id_provedor, nome, faixa_etaria, genero, cidade)
        VALUES (%s, %s, %s, %s, %s, %s);
    """, (i, id_provedor, nome, faixa_etaria, genero, cidade))

# criar dispositivos
dispositivos = [('Smartphone', 'Android'), ('Smart TV', 'Tizen'), ('Notebook', 'Windows 11'), ('Tablet', 'iOS'), ('PC', 'Linux')]
for i, (tipo, sistema) in enumerate(dispositivos, start=1):
    cur.execute("INSERT INTO dim_dispositivo (id_dispositivo, tipo, sistema_operacional) VALUES (%s, %s, %s);", (i, tipo, sistema))

# criar conteúdo
for i in range(1, 101):
    titulo = fake.sentence(nb_words=3).replace('.', '')
    tipo = random.choice(['Filme', 'Série', 'Documentário', 'Canal'])
    categoria = random.choice(['Ação','Drama','Comédia','Terror','Infantil','Esportes','Culinária'])
    duracao = random.randint(40, 160)
    cur.execute("""
        INSERT INTO dim_conteudo (id_conteudo, titulo, tipo, categoria, duracao_min)
        VALUES (%s, %s, %s, %s, %s);
    """, (i, titulo, tipo, categoria, duracao))

# criar planos contratados
for i in range(1, 1001):
    tipo_plano = random.choices(['Básico', 'HD', '4K', 'Família'], weights=[35, 35, 20, 10])[0]
    preco = {'Básico': 19.90, 'HD': 29.90, '4K': 39.90, 'Família': 49.90}[tipo_plano]
    canais = random.randint(25, 90)
    data_contratacao = fake.date_between(start_date=start_date, end_date=end_date)
    id_data = map_data_to_id(data_contratacao)
    ativo = random.choices([True, False], weights=[88,12])[0]
    cur.execute("""
        INSERT INTO fato_planos_contratados (id_plano, id_usuario, tipo_plano, preco, canais_inclusos, data_contratacao, ativo, id_data)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
    """, (i, i, tipo_plano, preco, canais, data_contratacao, ativo, id_data))

# criar acessos
for i in range(1, 3001):
    id_usuario = random.randint(1, 1000)
    id_dispositivo = random.randint(1, 5)
    login = fake.date_time_between(start_date=start_date, end_date=end_date - timedelta(days=1))
    logout = login + timedelta(minutes=random.randint(10, 240))
    id_data = map_data_to_id(login.date())
    sucesso = random.choices([True, False], weights=[95, 5])[0]
    cur.execute("""
        INSERT INTO fato_acessos (id_acesso, id_usuario, id_dispositivo, data_login, data_logout, sucesso_login, id_data)
        VALUES (%s, %s, %s, %s, %s, %s, %s);
    """, (i, id_usuario, id_dispositivo, login, logout, sucesso, id_data))

# criar visualizações
for i in range(1, 5001):
    id_usuario = random.randint(1, 1000)
    id_conteudo = random.randint(1, 100)
    id_dispositivo = random.randint(1, 5)
    inicio = fake.date_time_between(start_date=start_date, end_date=end_date)
    id_data = map_data_to_id(inicio.date())
    tempo = random.randint(10, 120)
    cur.execute("""
        INSERT INTO fato_visualizacoes (id_visualizacao, id_usuario, id_conteudo, id_dispositivo, data_hora_inicio, tempo_assistido_min, id_data)
        VALUES (%s, %s, %s, %s, %s, %s, %s);
    """, (i, id_usuario, id_conteudo, id_dispositivo, inicio, tempo, id_data))

# criar atendimentos
for i in range(1, 600):
    id_usuario = random.randint(1, 1000)
    id_provedor = random.randint(1, 10)
    abertura = fake.date_between(start_date=start_date, end_date=end_date - timedelta(days=7))
    id_data = map_data_to_id(abertura)
    if random.random() < 0.15:
        fechamento = None
        tempo = None
    else:
        fechamento = abertura + timedelta(days=random.randint(0, 7))
        tempo = (fechamento - abertura).days * 24 * 60
    cur.execute("""
        INSERT INTO fato_atendimentos (id_chamado, id_usuario, id_provedor, status_abertura, status_fechamento, tempo_resolucao_min, id_data)
        VALUES (%s, %s, %s, %s, %s, %s, %s);
    """, (i, id_usuario, id_provedor, abertura, fechamento, tempo, id_data))

#finalizar
conn.commit()
cur.close()
conn.close()
print("Dados Populados Com Sucesso")
