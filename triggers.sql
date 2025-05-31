-- =============================================
-- Triggers
-- Caso de Estudo: AgroAuto
-- =============================================

-- Atualizar trator como "Alugado" no início do aluguer
DROP TRIGGER IF EXISTS setTratorAlugado;
DELIMITER $$

CREATE TRIGGER setTratorAlugado
AFTER INSERT ON Aluguer
FOR EACH ROW
BEGIN
    IF (SELECT estado FROM Trator WHERE idTrator = NEW.idTrator) <> 'Alugado' THEN
        UPDATE Trator
        SET estado = 'Alugado'
        WHERE idTrator = NEW.idTrator;
    END IF;
END$$

DELIMITER ;


-- Atualizar trator como "Livre" quando o aluguer termina
DROP TRIGGER IF EXISTS setTratorLivre;
DELIMITER $$

CREATE TRIGGER setTratorLivre
AFTER UPDATE ON Aluguer
FOR EACH ROW
BEGIN
    -- Apenas atualiza para 'Livre' se já passou o prazo E o pagamento está concluído
    IF NEW.estadoPagamento = 'Concluido' AND NEW.dataTermino < CURRENT_DATE THEN
        UPDATE Trator
        SET estado = 'Livre'
        WHERE idTrator = NEW.idTrator;
    END IF;
END$$

DELIMITER ;

