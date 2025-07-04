# ProjetoWatch

Simulação de Análise de Dados da plataforma de streaming **Watch**, utilizando a geração de dados com **Python**, banco de dados em **PostgreSQL**, e visualizações em **Power BI**. O repositório contém a criação do banco de dados, os dados para análise e o dashboard interativo para monitoramento de métricas da plataforma de streaming.

## Objetivo

Este projeto tem como objetivo simular a análise de dados de uma plataforma de streaming chamada **Watch**. Foram utilizados dados de visualizações, acessos, atendimentos e planos de assinatura para criar um modelo de banco de dados relacional, além de gerar visualizações e relatórios para monitoramento de métricas-chave.

O repositório inclui:
- **Banco de Dados**: Criação do banco no PostgreSQL com tabelas relacionadas.
- **Geração de Dados**: Script Python para gerar dados simulados e populá-los nas tabelas do banco.
- **Dashboard**: Relatório interativo criado no Power BI para visualização dos dados.
- **Consultas e Views**: Exemplos de consultas SQL e views para análise.

## Tecnologias Utilizadas

- **Python**: Utilizado para a geração de dados e integração com o banco de dados.
- **PostgreSQL**: Banco de dados relacional utilizado para armazenar os dados da plataforma.
- **Power BI**: Ferramenta de visualização de dados para criar o dashboard interativo.
- **Faker**: Biblioteca Python utilizada para gerar dados simulados de usuários, provedores, etc.
- **psycopg2**: Conector Python para integração com o PostgreSQL.
- **Git**: Para versionamento de código e colaboração.

## Como Rodar o Projeto

### Pré-requisitos

1. **Instalar Python** (se não tiver o Python instalado):
   - Faça o download e instale a versão mais recente do Python em [https://www.python.org/downloads/](https://www.python.org/downloads/).

2. **Instalar PostgreSQL** (se não tiver o banco instalado):
   - Faça o download e instale o PostgreSQL em [https://www.postgresql.org/download/](https://www.postgresql.org/download/).

3. **Criar e ativar o ambiente virtual (virtualenv)**:
   No terminal, dentro do diretório do projeto:
   ```bash
   python -m venv venv
   source venv/bin/activate   # no Windows: venv\Scripts\activate
4. **Instalar as Dependências**:
Após ativar o ambiente virtual, instale as bibliotecas necessárias:
  `pip install -r requirements.txt`

## Estrutura do Banco de Dados
O banco de dados consiste em várias tabelas dimensionais e tabelas de fatos:

dim_data: Contém dados relacionados ao tempo (data, mês, ano, etc).

dim_provedor: Contém informações sobre os provedores de streaming.

dim_usuario: Informações sobre os usuários da plataforma, incluindo faixa etária, gênero, etc.

dim_conteudo: Informações sobre os conteúdos disponíveis na plataforma (filmes, séries, etc).

dim_dispositivo: Detalhes sobre os dispositivos utilizados para acessar o conteúdo.

fato_visualizacoes: Tabela de fatos com dados sobre visualizações de conteúdo.

fato_acessos: Dados sobre acessos dos usuários à plataforma.

fato_atendimentos: Informações sobre atendimentos ao cliente.

fato_planos_contratados: Dados sobre os planos de assinatura contratados pelos usuários.

**LINK PARA O DIAGRAMA DO BANCO:** https://dbdiagram.io/d/Diagrama-ProjetoWatch-6867e200f413ba3508540b7b
**NA PASTA DATA TEM EXEMPLOS DE VIEWS E QUERIES A SEREM UTILIZADAS NO BANCO**

# COMO GERAR DADOS NO BANCO:

Gerar Dados no Banco

Rodar o script Python:

O script DataGenerator.py irá gerar dados simulados para preencher as tabelas do banco de dados.
`python src/DataGenerator.py`

# Conectar o Power BI

Conectar ao PostgreSQL: No Power BI, utilize a conexão nativa com PostgreSQL para carregar os dados diretamente do banco de dados.

Importar Tabelas: Importe as tabelas dimensionais e de fatos para o Power BI.

Imagens do Dashboard:
![exemplos dashboard](https://github.com/user-attachments/assets/22f142b0-db55-4098-af8c-bf25c4880d8d)
![exemplo dashboard 2](https://github.com/user-attachments/assets/a7bd7447-3320-487c-a70e-327e6a7eab5e)
![exemplo dashboard 3](https://github.com/user-attachments/assets/d21d4d0a-a05d-4111-8181-6e9eccf8d242)
![exemplo dashboard 4](https://github.com/user-attachments/assets/ab0c1ed9-fbfa-45ac-8f2a-7bb80ac808bc)
