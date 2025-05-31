-- =============================================
-- Gestão de Utilizadores e Permissões
-- Caso de Estudo: AgroAuto
-- =============================================

-- -----------------------------------------------------
-- Administrador
-- -----------------------------------------------------
DROP USER IF EXISTS 'admin'@'localhost';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Admin123!';

-- RC02 a RC08, RC14 e RC15: Consultas
-- RC12 e RC13: Alteração de cliente e aluguer
GRANT SELECT, UPDATE ON AgroAuto.Aluguer TO 'admin'@'localhost';
GRANT SELECT ON AgroAuto.Trator TO 'admin'@'localhost';
GRANT SELECT, UPDATE ON AgroAuto.Cliente TO 'admin'@'localhost';
GRANT SELECT ON AgroAuto.Funcionario TO 'admin'@'localhost';
GRANT SELECT ON AgroAuto.Stand TO 'admin'@'localhost';

-- -----------------------------------------------------
-- Funcionario
-- -----------------------------------------------------
DROP ROLE IF EXISTS 'funcionario';
CREATE ROLE 'funcionario';

-- RC09, RC10 e RC11: Consultas de clientes e tratores
-- RC12 e RC13: Alteração de alugueres e clientes
GRANT SELECT, UPDATE ON AgroAuto.Cliente TO 'funcionario';
GRANT SELECT ON AgroAuto.Trator TO 'funcionario';
GRANT SELECT, UPDATE ON AgroAuto.Aluguer TO 'funcionario';

DROP USER IF EXISTS 'dcosta'@'localhost';
CREATE USER 'dcosta'@'localhost' IDENTIFIED BY 'senhaDiogo123!';
DROP USER IF EXISTS 'fteixeira'@'localhost';
CREATE USER 'fteixeira'@'localhost' IDENTIFIED BY 'senhaFatima123!';
DROP USER IF EXISTS 'fvieira'@'localhost';
CREATE USER 'fvieira'@'localhost' IDENTIFIED BY 'senhaFabio123!';

GRANT 'funcionario' TO 'dcosta'@'localhost';
SET DEFAULT ROLE 'funcionario' TO 'dcosta'@'localhost';

GRANT 'funcionario' TO 'fteixeira'@'localhost';
SET DEFAULT ROLE 'funcionario' TO 'fteixeira'@'localhost';

GRANT 'funcionario' TO 'fvieira'@'localhost';
SET DEFAULT ROLE 'funcionario' TO 'fvieira'@'localhost';