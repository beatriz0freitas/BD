-- =============================================
-- Procedimentos
-- Caso de Estudo: AgroAuto
-- =============================================

-- =============================================
-- procedimentos para REQUISITOS DE CONTROLO
-- =============================================

-- RC03 -> Clientes que mais tratores alugaram depois de certa data
DROP PROCEDURE IF EXISTS ClientesMaisAtivos;
DELIMITER $$

CREATE PROCEDURE ClientesMaisAtivos (
	IN pDataInicio DATE)
BEGIN
    SELECT 
		Cliente.idCliente, 
		nomeCompleto, 
        COUNT(*) AS totalAlugueres
    FROM AgroAuto.Aluguer
    JOIN AgroAuto.Cliente ON Aluguer.idCliente = Cliente.idCliente
    WHERE dataInicio >= pDataInicio
    GROUP BY Cliente.idCliente, nomeCompleto
    ORDER BY totalAlugueres DESC
    LIMIT 10;
END $$

DELIMITER ;

-- CALL ClientesMaisAtivos('2025-04-02');


-- RC05 -> alugueres realizados entre determinadas datas por parte de qualquer funcionário
DROP PROCEDURE IF EXISTS RegistosAlugueresFuncionario;
DELIMITER $$
CREATE PROCEDURE RegistosAlugueresFuncionario (
    IN pDataInicio DATE,
    IN pDataFim DATE
)
BEGIN
    SELECT idFuncionario, COUNT(*) AS totalAlugueres
    FROM AgroAuto.Aluguer
    WHERE dataInicio BETWEEN pDataInicio AND pDataFim
    GROUP BY idFuncionario;
END $$

DELIMITER ;

-- CALL RegistosAlugueresFuncionario('2025-05-20', '2025-05-24');

-- RC08 -> lucro total dos alugueres efetuados num dado período de tempo
DROP PROCEDURE IF EXISTS LucroTotalAlugueres;
DELIMITER $$
CREATE PROCEDURE LucroTotalAlugueres (
    IN pDataInicio DATE,
    IN pDataFim DATE
)
BEGIN
    SELECT 
		SUM(precoTotal) AS lucroTotal
    FROM AgroAuto.Aluguer
    WHERE dataInicio BETWEEN pDataInicio AND pDataFim;
END $$

DELIMITER ;

-- CALL LucroTotalAlugueres('2025-05-20', '2025-05-24');


-- RC14 -> consultar o histórico de alugueres de qualquer cliente
DROP PROCEDURE IF EXISTS HistoricoAlugueresCliente;
DELIMITER $$

CREATE PROCEDURE HistoricoAlugueresCliente(IN pidCliente INT)
BEGIN
    SELECT 
        Aluguer.idCliente, 
        Cliente.nomeCompleto, 
        Aluguer.idAluguer, 
        Aluguer.dataInicio, 
        Aluguer.dataTermino
    FROM AgroAuto.Aluguer
    JOIN AgroAuto.Cliente ON Aluguer.idCliente = Cliente.idCliente
    WHERE Aluguer.idCliente = pidCliente
    ORDER BY Aluguer.dataInicio DESC;
END $$

DELIMITER ;

/*
INSERT INTO AgroAuto.Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento, estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
VALUES
('2025-04-02', '2025-04-12', 600.00, 'Dinheiro', 'Concluido', 'APronto', 6, 2, 1);

CALL HistoricoAlugueresCliente(6);
*/

-- =============================================
-- procedimento COM TRANSACAO
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

/*
CALL registarNovoAluguer('2025-06-01', '2025-06-07', 'CartaoCredito', 'APronto', 1, 2, 3);
SELECT * FROM Aluguer WHERE idCliente = 1 ORDER BY idAluguer DESC;

CALL registarNovoAluguer(
    '2025-06-10', '2025-06-15',  
    'CartaoCredito', 'APronto',  
    2, 2, 4  -- `idTrator` já ocupado - nao deve criar
);
SELECT * FROM Aluguer WHERE idCliente = 2 ORDER BY idAluguer DESC;

CALL registarNovoAluguer('2025-06-16', '2025-06-22', 'Dinheiro', 'EmPrestacoes', 3, 5, 1 );
SELECT * FROM Aluguer WHERE idCliente = 3 ORDER BY idAluguer DESC;
*/

