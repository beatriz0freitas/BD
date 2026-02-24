-- =============================================
-- Funções
-- Caso de Estudo: AgroAuto
-- =============================================

-- DROP FUNCTION IF EXISTS calcularCustoAluguer;
DELIMITER $$

CREATE FUNCTION calcularCustoAluguer(pIdAluguer INT) RETURNS DECIMAL(8,2)
DETERMINISTIC
BEGIN
    DECLARE precoTotal DECIMAL(8,2);
    
    SELECT (DATEDIFF(dataTermino, dataInicio) + 1) * precoDiario
    INTO precoTotal
    FROM Aluguer 
    JOIN Trator ON Aluguer.idTrator = Trator.idTrator
    WHERE Aluguer.idAluguer = pIdAluguer;

    RETURN precoTotal;
END$$

DELIMITER ;

-- SELECT calcularCustoAluguer(2);