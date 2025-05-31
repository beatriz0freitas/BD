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

INSERT INTO Aluguer (dataInicio, dataTermino, precoTotal, metodoPagamento, estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
VALUES (CURDATE(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 500, 'Dinheiro', 'EmAtraso', 'APronto', 2, 1, 3);


SELECT *
FROM Aluguer
WHERE idTrator = 1;

SELECT *
FROM Trator;

SHOW TRIGGERS;

SHOW TRIGGERS FROM AgroAuto LIKE '%setTratorAlugado%';

SELECT * FROM information_schema.TRIGGERS WHERE TRIGGER_NAME = 'setTratorAlugado';

SHOW ERRORS;

SELECT USER();
SHOW GRANTS FOR CURRENT_USER;

SELECT idTrator, estado FROM Trator WHERE idTrator = 1;

UPDATE Aluguer 
SET estadoPagamento = 'Concluido', dataTermino = DATE_SUB(CURDATE(), INTERVAL 1 DAY)
WHERE idTrator = 1;
