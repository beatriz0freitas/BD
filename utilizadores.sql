-- =============================================
-- Gestão de Utilizadores e Permissões
-- Caso de Estudo: AgroAuto
-- =============================================

-- -----------------------------------------------------
-- Funcionario
-- -----------------------------------------------------
DROP ROLE IF EXISTS 'funcionario';
CREATE ROLE 'funcionario';

GRANT SELECT, UPDATE ON AgroAuto.Cliente TO 'funcionario';
GRANT SELECT, UPDATE ON AgroAuto.Aluguer TO 'funcionario';
GRANT SELECT ON AgroAuto.TratoresDisponiveis TO 'funcionario';
GRANT SELECT ON AgroAuto.TratoresAlugadosPorStandDiario TO 'funcionario';

GRANT EXECUTE ON PROCEDURE AgroAuto.HistoricoAlugueresCliente TO 'funcionario';

-- DROP USER IF EXISTS 'dcosta'@'localhost';
CREATE USER 'dcosta'@'localhost' IDENTIFIED BY 'senhaDiogo123!';
-- DROP USER IF EXISTS 'fteixeira'@'localhost';
CREATE USER 'fteixeira'@'localhost' IDENTIFIED BY 'senhaFatima123!';
-- DROP USER IF EXISTS 'fvieira'@'localhost';
CREATE USER 'fvieira'@'localhost' IDENTIFIED BY 'senhaFabio123!';

GRANT 'funcionario' TO 'dcosta'@'localhost';
SET DEFAULT ROLE 'funcionario' TO 'dcosta'@'localhost';

GRANT 'funcionario' TO 'fteixeira'@'localhost';
SET DEFAULT ROLE 'funcionario' TO 'fteixeira'@'localhost';

GRANT 'funcionario' TO 'fvieira'@'localhost';
SET DEFAULT ROLE 'funcionario' TO 'fvieira'@'localhost';

-- -----------------------------------------------------
-- Administrador
-- -----------------------------------------------------
-- DROP ROLE IF EXISTS 'administrador';
CREATE ROLE 'administrador';

-- DROP USER IF EXISTS 'admin'@'localhost';
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'Admin123!';

GRANT 'funcionario' TO 'administrador';

GRANT SELECT ON AgroAuto.Funcionario TO 'administrador';
GRANT SELECT ON AgroAuto.MarcaMaisAlugada TO 'administrador';
GRANT SELECT ON AgroAuto.TotalFaturadoPorStandMensal TO 'administrador';

GRANT EXECUTE ON PROCEDURE AgroAuto.ClientesMaisAtivos TO 'administrador';
GRANT EXECUTE ON PROCEDURE AgroAuto.TotalAlugueresPorTrimestre TO 'administrador';
GRANT EXECUTE ON PROCEDURE AgroAuto.FuncionariosComMaisAlugueresMes TO 'administrador';
GRANT EXECUTE ON PROCEDURE AgroAuto.LucroTotalAlugueres TO 'administrador';
GRANT EXECUTE ON PROCEDURE AgroAuto.RegistosAlugueresFuncionario TO 'administrador';
GRANT EXECUTE ON PROCEDURE AgroAuto.VerificaClienteAptoAluguer TO 'administrador';
GRANT EXECUTE ON PROCEDURE AgroAuto.registarNovoAluguer TO 'administrador';

GRANT 'administrador' TO 'admin'@'localhost';
SET DEFAULT ROLE 'administrador' TO 'admin'@'localhost';
