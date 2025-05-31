-- =============================================
-- Vistas
-- Caso de Estudo: AgroAuto
-- =============================================


-- RC02: Trimestre com maior número de alugueres
CREATE VIEW view_trimestre_mais_alugado AS
SELECT 
    QUARTER(data_inicio) AS trimestre,
    COUNT(*) AS total_alugueres
FROM Aluguer
GROUP BY QUARTER(data_inicio)
ORDER BY total_alugueres DESC
LIMIT 1;

-- RC03: Clientes que mais alugaram a partir de determinada data
CREATE VIEW view_clientes_top_por_data AS
SELECT 
    id_cliente,
    COUNT(*) AS total_alugueres
FROM Aluguer
WHERE data_inicio >= '2025-01-01' -- Substituir na query conforme necessário
GROUP BY id_cliente
ORDER BY total_alugueres DESC;

-- RC04: Marca de tratores mais alugada no final de cada ano
CREATE VIEW view_marca_top_ano AS
SELECT 
    T.marca,
    COUNT(*) AS total_alugueres
FROM Aluguer A
JOIN Trator T ON A.id_trator = T.id_trator
WHERE YEAR(data_inicio) = 2024 -- Substituir na query conforme necessário
GROUP BY T.marca
ORDER BY total_alugueres DESC
LIMIT 1;

-- RC07: Funcionário com mais alugueres num dado mês
CREATE VIEW view_funcionario_top_mes AS
SELECT 
    id_funcionario,
    COUNT(*) AS total_alugueres
FROM Aluguer
WHERE MONTH(data_inicio) = 5 AND YEAR(data_inicio) = 2025 -- Ajustar na query
GROUP BY id_funcionario
ORDER BY total_alugueres DESC
LIMIT 1;

-- RC08: Lucro total dos alugueres num intervalo de tempo
CREATE VIEW view_lucro_total_periodo AS
SELECT 
    SUM(preco_total) AS lucro_total
FROM Aluguer
WHERE data_inicio BETWEEN '2025-01-01' AND '2025-03-31'; -- Ajustar conforme necessário

-- RC15: Valor total faturado por stand ao final de um mês
CREATE VIEW view_faturacao_stand_mes AS
SELECT 
    S.id_stand,
    S.nome,
    SUM(A.preco_total) AS faturado_mes
FROM Aluguer A
JOIN Trator T ON A.id_trator = T.id_trator
JOIN Stand S ON T.id_stand = S.id_stand
WHERE MONTH(data_inicio) = 5 AND YEAR(data_inicio) = 2025 -- Ajustar conforme necessário
GROUP BY S.id_stand, S.nome;






-- =============================================
-- RM02
-- =============================================
DROP VIEW IF EXISTS TratoresAlugadosPorStandDiario;

CREATE VIEW TratoresAlugadosPorStandDiario AS
SELECT DISTINCT
	CURRENT_DATE AS dataConsulta,
    s.idStand,
    t.idTrator,
    t.modelo,
    t.marca
FROM
    AgroAuto.Trator t
    JOIN AgroAuto.Stand s ON t.idStand = s.idStand
WHERE
    t.estado = 'Alugado' ;




-- =============================================
-- RM12
-- =============================================
DROP VIEW IF EXISTS TotalFaturadoPorStandMensal;
CREATE VIEW TotalFaturadoPorStandMensal AS
SELECT
    t.idStand,
    YEAR(a.dataInicio) AS ano,
    MONTH(a.dataInicio) AS mes,
    SUM(a.precoTotal) AS totalFaturado
FROM
    AgroAuto.Aluguer a
    JOIN AgroAuto.Trator t ON a.idTrator = t.idTrator
GROUP BY
    t.idStand, ano, mes;


 