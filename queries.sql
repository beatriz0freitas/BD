-- =============================================
-- Queries SQL
-- Caso de Estudo: AgroAuto
-- =============================================

-- RM02
SELECT * 
FROM TratoresAlugadosPorStandDiario 
ORDER BY idStand, marca;


-- RM04
DROP PROCEDURE IF EXISTS VerificaClienteAptoAluguer;
DELIMITER $$
CREATE PROCEDURE VerificaClienteAptoAluguer (
    IN pidClientePretendido INT,
    IN pdataTerminoPretendida DATE
)
BEGIN
    SELECT 
        idCliente,
        nomeCompleto,
        IF(dataValidadeCarta >= pdataTerminoPretendida AND habilitacao = 'T',
           'Apto', 'Não Apto') AS estadoAptidao
    FROM AgroAuto.Cliente
    WHERE idCliente = pidClientePretendido;
END $$
DELIMITER ;

CALL VerificaClienteAptoAluguer(1, '2035-08-01');


-- RM10
DROP PROCEDURE IF EXISTS FuncionariosComMaisAlugueresMes;
DELIMITER $$
CREATE PROCEDURE FuncionariosComMaisAlugueresMes (
    IN pDataInicioMes DATE,
    IN pDataFimMes DATE
)
BEGIN
    SELECT 
		F.idFuncionario, 
        F.nomeCompleto, 
        COUNT(A.idAluguer) AS totalAlugueres
    FROM AgroAuto.Funcionario F
    JOIN AgroAuto.Aluguer A ON F.idFuncionario = A.idFuncionario
    WHERE A.dataInicio BETWEEN pDataInicioMes AND pDataFimMes
    GROUP BY F.idFuncionario, F.nomeCompleto
    HAVING totalAlugueres = (
        SELECT 
			MAX(totalAlugueres)
        FROM (
            SELECT 
				idFuncionario, 
                COUNT(idAluguer) AS totalAlugueres
            FROM AgroAuto.Aluguer
            WHERE dataInicio BETWEEN pDataInicioMes AND pDataFimMes
            GROUP BY idFuncionario
        ) AS subquery
    );
END $$
DELIMITER ;

CALL FuncionariosComMaisAlugueresMes('2025-05-01', '2025-05-31');


-- RM11
DROP PROCEDURE IF EXISTS TotalAlugueresPorTrimestre;
DELIMITER $$
CREATE PROCEDURE TotalAlugueresPorTrimestre(
    IN pdataInicioTrimestre DATE,
    IN pdataFimTrimestre DATE
)
BEGIN
    SELECT COUNT(*) AS totalAlugueres
    FROM AgroAuto.Aluguer 
    WHERE dataInicio BETWEEN pdataInicioTrimestre AND pdataFimTrimestre;
END $$
DELIMITER ;

CALL TotalAlugueresPorTrimestre('2025-04-01', '2025-06-30');


-- RM12
SELECT * 
FROM TotalFaturadoPorStandMensal 
WHERE ano = 2025 AND mes = 5;

