-- =============================================
-- Povoamento inicial da base de dados
-- Caso de Estudo: AgroAuto
-- =============================================

USE `AgroAuto`;

-- Povoamento da tabela "Cliente"
INSERT INTO `AgroAuto`.`Cliente`
        (nomeCompleto, dataNascimento, NIF, numeroDocumento, dataValidadeDocumento, rua, localidade, CodigoPostal, numeroTelemovel, email,
        dataValidadeCarta, habilitacao, dataValidadeCartao, numeroCartao, CVV)
VALUES
('João Azevedo', '2005-06-15', '123456789', '98765432', '2030-12-31', 'Rua das Flores', 'Braga', '4700-123', '912345678', 'joao.azevedo@gmail.com',
 '2035-06-15', 'T', '2027-08-01', '1234123412341234', '123'),

('Maria Silva', '1990-02-20', '987654321', '12345678', '2028-10-10', 'Av. Central', 'Guimarães', '4800-456', '911234567', 'maria.silva@gmail.com',
 '2032-02-20', 'T', '2026-04-01', '4321432143214321', '456'),

('Pedro Santos', '1978-11-03', '246813579', '11223344', '2027-07-30', 'Rua dos Pescadores', 'Viana do Castelo', '4900-321', '913456789', 'pedro.santos@hotmail.com',
 '2028-11-03', 'B', '2025-12-31', '1111222233334444', '789'),

('Ana Freitas', '1995-04-18', '135792468', '55443322', '2029-03-15', 'Rua Nova', 'Porto', '4000-222', '914567890', 'ana.freitas@gmail.com',
 '2030-04-18', 'A', '2027-10-10', '5555666677778888', '321'),

('Miguel Moreira', '1982-09-12', '112358132', '99887766', '2031-05-05', 'Av. das Indústrias', 'Lisboa', '1000-000', '915678901', 'miguel.moreira5@gmail.com',
 '2033-09-12', 'T', '2028-09-01', '6666777788889999', '654'),

('Matilde Teixeira', '1998-12-25', '223344556', '66778899', '2032-11-11', 'Rua do Sol', 'Coimbra', '3000-111', '916789012', 'matilde2005.teixeira@gmail.com',
 '2035-12-25', 'B', '2029-06-30', '7777888899990000', '987');


-- Povoamento da tabela "Stand"
INSERT INTO `AgroAuto`.`Stand` (rua, localidade, codigoPostal, numeroTelefone, email)
VALUES
('Rua São Martinho da Bouça', 'Olivença', '4700-001', '253123123', 'olivença@agroauto.pt'),
('Rua Da Malha',              'Lamego',   '8000-002', '289456456', 'lamego@agroauto.pt'),
('Rua Do Porto Seguro',       'Sagres',   '7500-002', '247567456', 'sagres@agroauto.pt');


-- Povoamento da tabela "Funcionário" 
INSERT INTO `AgroAuto`.`Funcionario` (nomeCompleto, numeroTelemovel, idStand)
VALUES
('Diogo Costa',     '910000001', 1),
('Fátima Teixeira', '910000002', 2),
('Fábio Vieira',    '910000003', 3);

-- Povoamento da tabela "Trator"
INSERT INTO `AgroAuto`.`Trator` (modelo, marca, precoDiario, estado, idStand)
VALUES
('T8.410',     'New Holland',     250.00, 'Livre', 1),
('6145R',      'John Deere',      300.00, 'Alugado', 2),
('MF 8S.265',  'Massey Ferguson', 280.00, 'Alugado', 3),
('Arion 660',  'CLAAS',           260.00, 'Livre', 1),
('Maxxum 150', 'Case IH',         270.00, 'Alugado', 2),
('T7.290',     'New Holland',     310.00, 'Alugado', 3);

-- Povoamento da tabela "Aluguer"
INSERT INTO `AgroAuto`.`Aluguer`
	(dataInicio, dataTermino, precoTotal, metodoPagamento, estadoPagamento, tipoPagamento, idCliente, idTrator, idFuncionario)
VALUES
('2025-05-20', '2025-05-25', 1500.00, 'CartaoCredito', 'Concluido', 'APronto',      1, 1, 1),
('2025-05-20', '2025-05-22', 900.00, 'Dinheiro',       'Concluido', 'APronto',      2, 2, 2),
('2025-05-25', '2025-06-18', 7000.00, 'CartaoCredito',  'Concluido', 'EmPrestacoes', 3, 3, 3),
('2025-05-20', '2025-06-23', 10500.00, 'Dinheiro',       'Concluido', 'APronto',      5, 2, 2),
('2025-05-25', '2025-05-27', 930.00, 'CartaoCredito',  'EmAtraso',  'EmPrestacoes', 4, 6, 3),
('2025-05-28', '2025-06-11', 4050.00, 'Dinheiro',      'Concluido', 'APronto',      6, 5, 2);
