-- =============================================
-- Comandos para testes
-- Caso de Estudo: AgroAuto
-- =============================================

-- teste Permissoes
SHOW GRANTS FOR 'admin'@'localhost';
SHOW GRANTS FOR 'dcosta'@'localhost';
SHOW GRANTS FOR 'fteixeira'@'localhost';
SHOW GRANTS FOR 'fvieira'@'localhost';

SELECT USER FROM mysql.user;
SELECT DEFAULT_ROLE FROM mysql.user;

SHOW GRANTS FOR CURRENT_USER();

SELECT * FROM information_schema.role_table_grants WHERE GRANTEE = 'funcionario';

SET ROLE 'funcionario';
SELECT CURRENT_ROLE();


-- teste estado a ser atualizado corretamente
SELECT 
    t.idTrator,
    t.modelo,
    t.estado,
    CASE 
        WHEN EXISTS (
            SELECT 1 
            FROM Aluguer a
            WHERE a.idTrator = t.idTrator
              AND (
                  CURRENT_DATE BETWEEN a.dataInicio AND a.dataTermino
                  OR (
                      a.estadoPagamento = 'EmAtraso'
                      AND a.dataTermino < CURRENT_DATE
                  )
              )
        )
        THEN 'Deveria estar Alugado'
        ELSE 'Deveria estar Livre'
    END AS estadoEsperado
FROM Trator t
ORDER BY t.idTrator;

-- teste trigger estado
INSERT INTO Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento, estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
VALUES (CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 500, 'Dinheiro', 'EmAtraso', 'APronto', 2, 1, 3);

SELECT *
FROM Aluguer
WHERE idTrator = 1;

SELECT *
FROM Trator;

SHOW TRIGGERS;
SELECT * FROM information_schema.TRIGGERS WHERE TRIGGER_NAME = 'setTratorAlugado';

SELECT idTrator, estado FROM Trator WHERE idTrator = 1;

UPDATE Aluguer 
SET estadoPagamento = 'Concluido', dataTermino = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE idTrator = 1;


-- mais entradas para query trimestre
INSERT INTO AgroAuto.Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento, estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
VALUES
('2025-01-10', '2025-01-20', 500.00, 'CartaoCredito', 'Concluido', 'APronto', 1, 3, 2),
('2025-02-05', '2025-02-15', 750.00, 'Dinheiro', 'Concluido', 'EmPrestacoes', 2, 5, 3),
('2025-03-12', '2025-03-22', 900.00, 'CartaoCredito', 'EmAtraso', 'APronto', 3, 1, 1);

INSERT INTO AgroAuto.Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento, estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
VALUES
('2025-04-02', '2025-04-12', 600.00, 'Dinheiro', 'Concluido', 'APronto', 4, 2, 1),
('2025-05-14', '2025-05-24', 1200.00, 'CartaoCredito', 'Concluido', 'EmPrestacoes', 5, 4, 2),
('2025-06-18', '2025-06-28', 1500.00, 'Dinheiro', 'EmAtraso', 'APronto', 6, 6, 3);

INSERT INTO AgroAuto.Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento, estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
VALUES
('2025-07-05', '2025-07-15', 850.00, 'CartaoCredito', 'Concluido', 'APronto', 2, 3, 2),
('2025-08-10', '2025-08-20', 950.00, 'Dinheiro', 'EmAtraso', 'EmPrestacoes', 4, 5, 3),
('2025-09-22', '2025-09-30', 1100.00, 'CartaoCredito', 'Concluido', 'APronto', 1, 1, 1);

INSERT INTO AgroAuto.Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento, estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
VALUES
('2025-10-08', '2025-10-18', 680.00, 'Dinheiro', 'Concluido', 'APronto', 3, 4, 1),
('2025-11-12', '2025-11-22', 1020.00, 'CartaoCredito', 'EmAtraso', 'EmPrestacoes', 6, 2, 2),
('2025-12-25', '2026-01-05', 1400.00, 'Dinheiro', 'Concluido', 'APronto', 5, 6, 3);

CALL TotalAlugueresPorTrimestre('2025-07-01', '2025-09-30'); -- Teste para o terceiro trimestre
CALL TotalAlugueresPorTrimestre('2025-10-01', '2025-12-31'); -- Teste para o quarto trimestre


