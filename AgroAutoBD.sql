-- =============================================
-- Base de Dados: AgroAuto
-- Caso de Estudo: AgroAuto
-- =============================================

DROP SCHEMA IF EXISTS `AgroAuto` ;

CREATE SCHEMA IF NOT EXISTS `AgroAuto`;
USE `AgroAuto` ;

-- -----------------------------------------------------
-- Table `AgroAuto`.`Cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AgroAuto`.`Cliente` ;

CREATE TABLE IF NOT EXISTS `AgroAuto`.`Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `nomeCompleto` VARCHAR(100) NOT NULL,
  `dataNascimento` DATE NOT NULL,
  `NIF` VARCHAR(9) NOT NULL,
  `numeroDocumento` VARCHAR(8) NOT NULL,
  `dataValidadeDocumento` DATE NOT NULL,
  `rua` VARCHAR(100) NOT NULL,
  `localidade` VARCHAR(75) NOT NULL,
  `codigoPostal` VARCHAR(10) NOT NULL,
  `numeroTelemovel` VARCHAR(9) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `dataValidadeCarta` DATE NOT NULL,
  `habilitacao` VARCHAR(75) NOT NULL,
  `dataValidadeCartao` DATE NULL,
  `numeroCartao` VARCHAR(19) NULL,
  `CVV` VARCHAR(3) NULL,
  PRIMARY KEY (`idCliente`));

-- -----------------------------------------------------
-- Table `AgroAuto`.`Stand`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AgroAuto`.`Stand` ;

CREATE TABLE IF NOT EXISTS `AgroAuto`.`Stand` (
  `idStand` INT NOT NULL ,
  `rua` VARCHAR(100) NULL,
  `localidade` VARCHAR(75) NULL,
  `codigoPostal` VARCHAR(75) NULL,
  `numeroTelefone` VARCHAR(9) NOT NULL,
  `email` VARCHAR(75) NOT NULL,
  PRIMARY KEY (`idStand`));

-- -----------------------------------------------------
-- Table `AgroAuto`.`Trator`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AgroAuto`.`Trator` ;

CREATE TABLE IF NOT EXISTS `AgroAuto`.`Trator` (
  `idTrator` INT NOT NULL AUTO_INCREMENT,
  `modelo` VARCHAR(75) NOT NULL,
  `marca` VARCHAR(75) NOT NULL,
  `precoDiario` DECIMAL(8,2) NOT NULL,
  `estado` ENUM('Livre', 'Alugado') NOT NULL,
  `idStand` INT NOT NULL,
  PRIMARY KEY (`idTrator`),
    FOREIGN KEY (`idStand`) REFERENCES `AgroAuto`.`Stand` (`idStand`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `AgroAuto`.`Funcionario`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AgroAuto`.`Funcionario` ;

CREATE TABLE IF NOT EXISTS `AgroAuto`.`Funcionario` (
  `idFuncionario` INT NOT NULL,
  `nomeCompleto` VARCHAR(75) NOT NULL,
  `numeroTelemovel` VARCHAR(9) NOT NULL,
  `idStand` INT NOT NULL,
  PRIMARY KEY (`idFuncionario`),
    FOREIGN KEY (`idStand`) REFERENCES `AgroAuto`.`Stand` (`idStand`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table `AgroAuto`.`Aluguer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `AgroAuto`.`Aluguer` ;

CREATE TABLE IF NOT EXISTS `AgroAuto`.`Aluguer` (
  `idAluguer` INT NOT NULL AUTO_INCREMENT,
  `dataInicio` DATE NOT NULL,
  `dataTermino` DATE NOT NULL,
  `precoTotal` DECIMAL(8,2) NOT NULL,
  `metodoPagamento` ENUM('CartaoCredito', 'Dinheiro') NOT NULL,
  `estadoPagamento` ENUM('EmAtraso', 'Concluido') NOT NULL,
  `tipoPagamento` ENUM('APronto', 'EmPrestacoes') NOT NULL,
  `idCliente` INT NOT NULL,
  `idTrator` INT NOT NULL,
  `idFuncionario` INT NOT NULL,
  PRIMARY KEY (`idAluguer`),
    FOREIGN KEY (`idCliente`) REFERENCES `AgroAuto`.`Cliente` (`idCliente`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
    FOREIGN KEY (`idTrator`) REFERENCES `AgroAuto`.`Trator` (`idTrator`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION,
    FOREIGN KEY (`idFuncionario`) REFERENCES `AgroAuto`.`Funcionario` (`idFuncionario`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION);


