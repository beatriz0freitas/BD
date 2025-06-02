-- =============================================
-- Queries SQL
-- Caso de Estudo: AgroAuto
-- =============================================

-- RM02 -> Lista agrupada por stand, com o identificador único e o modelo de todos os tratores alugados, 
-- ordenados alfabeticamente pela marca do mesmo.
SELECT * 
FROM TratoresAlugadosPorStandDiario 
ORDER BY idStand, marca;


-- RM04 -> verificar se um cliente está apto a fazer um aluguer, verificando se a sua carta de condução é válida. 
-- É verificada se a data de validade desta é superior à data de término do aluguer e se a habilitação é do tipo T.
-- DROP PROCEDURE IF EXISTS VerificaClienteAptoAluguer;
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

-- CALL VerificaClienteAptoAluguer(1, '2035-08-01');


-- RM10 -> funcionário com mais alugueres num mês específico
-- DROP PROCEDURE IF EXISTS FuncionariosComMaisAlugueresMes;
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

-- CALL FuncionariosComMaisAlugueresMes('2025-05-01', '2025-05-31');


-- RM11 -> número de alugueres na empresa no último trimestre
-- DROP PROCEDURE IF EXISTS TotalAlugueresPorTrimestre;
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

-- CALL TotalAlugueresPorTrimestre('2025-04-01', '2025-06-30');


-- RM12 -> valor total faturado em cada stand no final do mês
SELECT * 
FROM TotalFaturadoPorStandMensal 
WHERE ano = 2025 AND mes = 5;

