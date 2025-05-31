-- =============================================
-- Queries SQL
-- Caso de Estudo: AgroAuto
-- =============================================

-- =============================================
-- RM02
-- =============================================
SELECT * 
FROM TratoresAlugadosPorStandDiario 
ORDER BY idStand, marca;


-- =============================================
-- RM04
-- =============================================
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

CALL VerificaClienteAptoAluguer(3, '2025-08-01');



-- =============================================
-- RM10
-- =============================================
DELIMITER $$

CREATE PROCEDURE FuncionariosComMaisAlugueresMes (
    IN pDataInicioMes DATE,
    IN pDataFimMes DATE
)
BEGIN
    WITH Totais AS (
        SELECT 
            A.idFuncionario,
            COUNT(*) AS totalAlugueres
        FROM AgroAuto.Aluguer A
        WHERE 
            A.dataInicio BETWEEN pDataInicioMes AND pDataFimMes
        GROUP BY A.idFuncionario
    ),
    Maximo AS (
        SELECT MAX(totalAlugueres) AS maxAlugueres FROM Totais
    )
    SELECT T.idFuncionario
    FROM Totais T
    JOIN Maximo M ON T.totalAlugueres = M.maxAlugueres;
END $$

DELIMITER ;


CALL FuncionariosComMaisAlugueresMes('2025-05-01', '2025-05-31');


-- =============================================
-- RM11
-- =============================================
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

CALL TotalAlugueresPorTrimestre('2024-04-01', '2024-06-30');


-- =============================================
-- RM12
-- =============================================
SELECT * 
FROM TotalFaturadoPorStandMensal 
WHERE ano = 2025 AND mes = 5;

