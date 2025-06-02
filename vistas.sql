-- =============================================
-- Vistas
-- Caso de Estudo: AgroAuto
-- =============================================

-- =============================================
-- vistas para REQUISITOS DE CONTROLO
-- =============================================

-- RC04 -> marca de tratores mais alugada no final de cada ano.
DROP VIEW IF EXISTS MarcaMaisAlugada;
CREATE VIEW MarcaMaisAlugada AS
SELECT 
    Trator.marca, 
    COUNT(*) AS totalAlugueres
FROM AgroAuto.Aluguer
JOIN AgroAuto.Trator ON Aluguer.idTrator = Trator.idTrator
WHERE YEAR(dataInicio) = YEAR(CURDATE()) -- Apenas ano atual
GROUP BY Trator.marca
HAVING totalAlugueres = (		-- para EMPATES
    SELECT MAX(totalAlugueres) FROM (
        SELECT COUNT(*) AS totalAlugueres
        FROM AgroAuto.Aluguer
        JOIN AgroAuto.Trator ON Aluguer.idTrator = Trator.idTrator
        WHERE YEAR(dataInicio) = YEAR(CURDATE())
        GROUP BY Trator.marca
    ) AS subquery
);

SELECT * FROM MarcaMaisAlugada;

-- RC11 -> lista de tratores disponíveis para alugar
DROP VIEW IF EXISTS TratoresDisponiveis;
CREATE VIEW TratoresDisponiveis AS
SELECT 
	idTrator, 
    modelo, 
    marca
FROM AgroAuto.Trator
WHERE estado = 'Livre';

-- SELECT * FROM TratoresDisponiveis;


-- =============================================
-- vistas para QUERIES
-- =============================================

-- RM02 -> lista agrupada por stand, com o identificador único e o modelo de todos os tratores alugados,
-- ordenados alfabeticamente pela marca do mesmo
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


-- RM12 -> valor total faturado em cada stand no final do mês
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


 