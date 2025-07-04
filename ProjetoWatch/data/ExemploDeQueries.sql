
--query para total de acessos por mês
SELECT 
    d.mes, 
    COUNT(a.id_acesso) AS total_acessos
FROM 
    fato_acessos a
JOIN 
    dim_data d ON a.id_data = d.id_data
GROUP BY 
    d.mes;

--query para total de visualizações por categoria de conteúdo
SELECT 
    c.categoria, 
    COUNT(v.id_visualizacao) AS total_visualizacoes
FROM 
    fato_visualizacoes v
JOIN 
    dim_conteudo c ON v.id_conteudo = c.id_conteudo
GROUP BY 
    c.categoria;

--query para total de planos ativos por provedor
SELECT 
    p.nome AS provedor,
    COUNT(f.id_plano) AS total_planos_ativos
FROM 
    fato_planos_contratados f
JOIN 
    dim_provedor p ON f.id_provedor = p.id_provedor
WHERE 
    f.ativo = TRUE
GROUP BY 
    p.nome;

--query para taxa de cancelamento por provedor
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

--query para total de acessos por dispositivo
SELECT 
    d.tipo AS dispositivo, 
    COUNT(a.id_acesso) AS total_acessos
FROM 
    fato_acessos a
JOIN 
    dim_dispositivo d ON a.id_dispositivo = d.id_dispositivo
GROUP BY 
    d.tipo;

--query para usuários ativos por faixa etária
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

--query para total de planos contratados por tipo
SELECT 
    f.tipo_plano, 
    COUNT(f.id_plano) AS total_planos_contratados
FROM 
    fato_planos_contratados f
GROUP BY 
    f.tipo_plano;

--query para tempo total assistido por provedor
SELECT 
    p.nome AS provedor, 
    SUM(v.tempo_assistido_min) / 60 AS tempo_total_assistido_horas
FROM 
    fato_visualizacoes v
JOIN 
    dim_provedor p ON v.id_provedor = p.id_provedor
GROUP BY 
    p.nome;

--query para total de planos cancelados por mês
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

--query para total de usuários ativos por provedor
SELECT 
    p.nome AS provedor,
    COUNT(u.id_usuario) AS total_usuarios_ativos
FROM 
    dim_usuario u
JOIN 
    dim_provedor p ON u.id_provedor = p.id_provedor
JOIN 
    fato_acessos a ON u.id_usuario = a.id_usuario
WHERE 
    a.data_logout IS NOT NULL
GROUP BY 
    p.nome;