
--view para visualizações por provedor
CREATE VIEW vw_visualizacoes_provedor AS
SELECT 
    p.nome AS provedor, 
    COUNT(v.id_visualizacao) AS total_visualizacoes
FROM 
    fato_visualizacoes v
JOIN 
    dim_provedor p ON v.id_provedor = p.id_provedor
GROUP BY 
    p.nome;


--view para total de acessos por mês
CREATE VIEW vw_acessos_por_mes AS
SELECT 
    d.mes, 
    COUNT(a.id_acesso) AS total_acessos
FROM 
    fato_acessos a
JOIN 
    dim_data d ON a.id_data = d.id_data
GROUP BY 
    d.mes
ORDER BY 
    d.mes;

--view para a taxa de cancelamento por provedor
CREATE VIEW vw_taxa_cancelamento_provedor AS
SELECT 
    p.nome AS provedor,
    ROUND(
        (COUNT(CASE WHEN f.ativo = FALSE THEN 1 END) / 
        NULLIF(COUNT(f.id_plano), 0)) * 100, 2
    ) AS taxa_cancelamento
FROM 
    fato_planos_contratados f
JOIN 
    dim_provedor p ON f.id_provedor = p.id_provedor
GROUP BY 
    p.nome;

--view para usuários ativos por faixa etária

CREATE VIEW vw_usuarios_ativos_faixa_etaria AS
SELECT 
    u.faixa_etaria, 
    COUNT(u.id_usuario) AS total_usuarios_ativos
FROM 
    dim_usuario u
JOIN 
    fato_acessos a ON u.id_usuario = a.id_usuario
WHERE 
    a.data_logout IS NOT NULL
GROUP BY 
    u.faixa_etaria;

CREATE VIEW vw_planos_por_tipo AS
SELECT 
    f.tipo_plano,
    COUNT(f.id_plano) AS total_planos_contratados
FROM 
    fato_planos_contratados f
GROUP BY 
    f.tipo_plano;

-- view para planos contratados por tipo
CREATE VIEW vw_planos_por_tipo AS
SELECT 
    f.tipo_plano,
    COUNT(f.id_plano) AS total_planos_contratados
FROM 
    fato_planos_contratados f
GROUP BY 
    f.tipo_plano;

--view para tempo total assistido por provedor

CREATE VIEW vw_tempo_total_assistido_provedor AS
SELECT 
    p.nome AS provedor, 
    SUM(v.tempo_assistido_min) / 60 AS tempo_total_assistido_horas
FROM 
    fato_visualizacoes v
JOIN 
    dim_provedor p ON v.id_provedor = p.id_provedor
GROUP BY 
    p.nome;

--view para total de planos cancelados por mês
CREATE VIEW vw_planos_cancelados_mes AS
SELECT 
    d.mes, 
    COUNT(f.id_plano) AS total_planos_cancelados
FROM 
    fato_planos_contratados f
JOIN 
    dim_data d ON f.id_data = d.id_data
WHERE 
    f.ativo = FALSE
GROUP BY 
    d.mes;

--view para total de usuários por dispositivo
CREATE VIEW vw_usuarios_por_dispositivo AS
SELECT 
    d.tipo AS dispositivo, 
    COUNT(u.id_usuario) AS total_usuarios
FROM 
    dim_dispositivo d
JOIN 
    fato_acessos a ON d.id_dispositivo = a.id_dispositivo
JOIN 
    dim_usuario u ON a.id_usuario = u.id_usuario
GROUP BY 
    d.tipo;

--view para visualizações por categoria de conteúdo
CREATE VIEW vw_visualizacoes_categoria AS
SELECT 
    c.categoria, 
    COUNT(v.id_visualizacao) AS total_visualizacoes
FROM 
    fato_visualizacoes v
JOIN 
    dim_conteudo c ON v.id_conteudo = c.id_conteudo
GROUP BY 
    c.categoria;

--view para total de usuários por provedor e faixa etária
CREATE VIEW vw_usuarios_por_provedor_faixa_etaria AS
SELECT 
    p.nome AS provedor,
    u.faixa_etaria,
    COUNT(u.id_usuario) AS total_usuarios
FROM 
    dim_usuario u
JOIN 
    dim_provedor p ON u.id_provedor = p.id_provedor
GROUP BY 
    p.nome, u.faixa_etaria;

