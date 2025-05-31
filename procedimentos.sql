-- =============================================
-- Procedimentos
-- Caso de Estudo: AgroAuto
-- =============================================
DROP PROCEDURE IF EXISTS registarNovoAluguer;
DELIMITER $$

CREATE PROCEDURE registarNovoAluguer (
    IN pdataInicio DATE,
    IN pdataTermino DATE,
    IN pmetodoPagamento ENUM('CartaoCredito', 'Dinheiro'),
    IN ptipoPagamento ENUM('APronto', 'EmPrestacoes'),
    IN pidCliente INT,
    IN pidTrator INT,
    IN pidFuncionario INT
)
BEGIN
    -- Manipulação de erros
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    -- Verifica disponibilidade do trator
    IF NOT EXISTS (SELECT 1 FROM Trator WHERE idTrator = pidTrator AND estado = 'Livre') THEN
        ROLLBACK;
		-- SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trator não está disponível para aluguer.';
    END IF;

    -- Inserir aluguer sem calcular preço
    INSERT INTO Aluguer (
        dataInicio, dataTermino, precoTotal, metodoPagamento,
        estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario
    )
    VALUES (
        pdataInicio, pdataTermino, 0, pmetodoPagamento, IF(ptipoPagamento = 'APronto', 'Concluido', 'EmAtraso'), 
		ptipoPagamento, pidCliente, pidTrator, pidFuncionario
    );

    -- Atualiza preço usando a função
    SET @novoId = LAST_INSERT_ID();
    UPDATE Aluguer
    SET precoTotal = calcularCustoAluguer(@novoId)
    WHERE idAluguer = @novoId;

    COMMIT;
END $$

DELIMITER ;


CALL registarNovoAluguer('2025-06-01', '2025-06-07', 'CartaoCredito', 'APronto', 1, 2, 3);
