-- =============================================
-- Indices
-- Caso de Estudo: AgroAuto
-- =============================================

-- Índices para junções na tabela Aluguer
CREATE INDEX idx_aluguer_idCliente ON Aluguer(idCliente);
CREATE INDEX idx_aluguer_idFuncionario ON Aluguer(idFuncionario);
CREATE INDEX idx_aluguer_idTrator ON Aluguer(idTrator);
-- Índice para consultar por data de inicio e estado de pagamento nos alugueres
CREATE INDEX idx_aluguer_data_estado ON Aluguer(dataInicio, estadoPagamento);

-- Índice para consultar tratores por preço
CREATE INDEX idx_trator_precoDiario ON Trator(precoDiario);
-- Índice para consultar tratores por marca
CREATE INDEX idx_trator_marca ON Trator(marca);
-- Índice para verificar tratores livres para aluguer
CREATE INDEX idx_trator_estado ON Trator(estado);
-- Índice para junção na tabela Trator
CREATE INDEX idx_trator_idStand ON Trator(idStand);

-- Índice para junção na tabela Funcionário
CREATE INDEX idx_funcionario_idStand ON Funcionario(idStand);
