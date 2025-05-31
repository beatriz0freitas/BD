-- =============================================
-- Vistas
-- Caso de Estudo: AgroAuto
-- =============================================

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


 