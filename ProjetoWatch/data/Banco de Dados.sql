-- 
CREATE TABLE IF NOT EXISTS dim_data (
    id_data SERIAL PRIMARY KEY,
    data DATE,
    ano INT,
    trimestre INT,
    mes INT,
    dia INT,
    semana INT,
    dia_da_semana VARCHAR(20),
    nome_do_mes VARCHAR(20)
);

-- 
CREATE TABLE dim_provedor (
    id_provedor INT PRIMARY KEY,
    nome VARCHAR(100),
    cnpj VARCHAR(20),
    estado VARCHAR(2),
    qtd_clientes INT
);

-- 
CREATE TABLE dim_usuario (
    id_usuario INT PRIMARY KEY,
    id_provedor INT,
    faixa_etaria VARCHAR(20),
    genero VARCHAR(20),
    cidade VARCHAR(50),
    nome VARCHAR(100),
    FOREIGN KEY (id_provedor) REFERENCES dim_provedor(id_provedor)
);

-- 
CREATE TABLE dim_conteudo (
    id_conteudo INT PRIMARY KEY,
    titulo VARCHAR(100),
    tipo VARCHAR(20),
    categoria VARCHAR(50),
    duracao_min INT
);

-- 
CREATE TABLE dim_dispositivo (
    id_dispositivo INT PRIMARY KEY,
    tipo VARCHAR(30),
    sistema_operacional VARCHAR(30)
);

-- 
CREATE TABLE fato_visualizacoes (
    id_visualizacao INT PRIMARY KEY,
    id_usuario INT,
    id_conteudo INT,
    id_dispositivo INT,
    data_hora_inicio TIMESTAMP,
    tempo_assistido_min INT,
    id_data INT,  -- relacionamento com a tabela dim_data
    id_provedor INT,  -- nova coluna para associar com dim_provedor
    FOREIGN KEY (id_usuario) REFERENCES dim_usuario(id_usuario),
    FOREIGN KEY (id_conteudo) REFERENCES dim_conteudo(id_conteudo),
    FOREIGN KEY (id_dispositivo) REFERENCES dim_dispositivo(id_dispositivo),
    FOREIGN KEY (id_data) REFERENCES dim_data(id_data),
    FOREIGN KEY (id_provedor) REFERENCES dim_provedor(id_provedor)  -- relacionamento com dim_provedor
);

--
CREATE TABLE fato_acessos (
    id_acesso INT PRIMARY KEY,
    id_usuario INT,
    id_dispositivo INT,
    data_login TIMESTAMP,
    data_logout TIMESTAMP,
    sucesso_login BOOLEAN,
    id_data INT,  -- relacionamento com a tabela dim_data
    id_provedor INT,  -- rova coluna para associar com dim_provedor
    FOREIGN KEY (id_usuario) REFERENCES dim_usuario(id_usuario),
    FOREIGN KEY (id_dispositivo) REFERENCES dim_dispositivo(id_dispositivo),
    FOREIGN KEY (id_data) REFERENCES dim_data(id_data),
    FOREIGN KEY (id_provedor) REFERENCES dim_provedor(id_provedor)  -- relacionamento com dim_provedor
);

-- 
CREATE TABLE fato_atendimentos (
    id_chamado INT PRIMARY KEY,
    id_usuario INT,
    id_provedor INT,
    status_abertura DATE,
    status_fechamento DATE,
    tempo_resolucao_min INT,
    id_data INT,  -- relacionamento com a tabela dim_data
    FOREIGN KEY (id_usuario) REFERENCES dim_usuario(id_usuario),
    FOREIGN KEY (id_provedor) REFERENCES dim_provedor(id_provedor),
    FOREIGN KEY (id_data) REFERENCES dim_data(id_data)
);

--  
CREATE TABLE fato_planos_contratados (
    id_plano INT PRIMARY KEY,
    id_usuario INT,
    tipo_plano VARCHAR(50),        -- basico, hd, 4k e familia
    preco DECIMAL(10,2),
    canais_inclusos INT,
    data_contratacao DATE,
    ativo BOOLEAN,
    id_data INT,  -- relacionamento com a tabela dim_data
    id_provedor INT,  -- nova coluna para associar com dim_provedor
    FOREIGN KEY (id_usuario) REFERENCES dim_usuario(id_usuario),
    FOREIGN KEY (id_data) REFERENCES dim_data(id_data),
    FOREIGN KEY (id_provedor) REFERENCES dim_provedor(id_provedor)  -- relacionamento com dim_provedor
);
