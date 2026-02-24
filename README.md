# BD - AgroAuto: Sistema de Gestão de Alugueres de Tratores

> **Projeto de Bases de Dados** · Universidade do Minho · Licenciatura em Engenharia Informática · 2024/2025

A **AgroAuto** é uma empresa de aluguer de tratores agrícolas fundada pelo Sr. Artur Pires, natural de Olivença (Alentejo). Com a expansão da empresa para **3 stands** em diferentes regiões do país, surgiu a necessidade de centralizar e modernizar a gestão dos alugueres, que até então era feita de forma fragmentada e heterogénea entre as filiais.

| Componente | Tecnologia |
|------------|------------|
| Base de Dados Central | **MySQL** |
| Modelação Conceptual | **BRModelo** (notação Chen) |
| Migração de Dados | **Python** |
| Fonte de Dados 1 (Olivença) | **PostgreSQL** |
| Fonte de Dados 2 (Lamego) | **CSV** |
| Fonte de Dados 3 | **JSON** |

---

## Funcionalidades Implementadas

#### Views (Vistas SQL)

| View | Descrição |
|------|-----------|
| `MarcaMaisAlugada` | Marca de tratores mais alugada no final de cada ano |
| `TratoresDisponiveis` | Lista de tratores disponíveis para alugar em tempo real |
| `TotalFaturadoPorStandMensal` | Valor total faturado por stand em cada mês |

#### Stored Procedures

| Procedure | Descrição |
|-----------|-----------|
| `ClientesMaisAtivos` | Clientes que mais tratores alugaram após uma data |
| `RegistosAlugueresFuncionario` | Número de alugueres por funcionário num intervalo de datas |
| `LucroTotalAlugueres` | Lucro total gerado pelos alugueres num período |
| `HistoricoAlugueresCliente` | Histórico completo de alugueres de um cliente |
| `registarNovoAluguer` | Registo seguro de um novo aluguer com validações e transações |
| `VerificaClienteAptoAluguer` | Verifica se um cliente está apto a alugar até uma data |
| `FuncionariosComMaisAlugueresMes` | Funcionário com mais alugueres num dado mês |
| `TotalAlugueresPorTrimestre` | Total de alugueres realizados num trimestre |

#### Triggers

| Trigger | Evento | Descrição |
|---------|--------|-----------|
| `setTratorAlugado` | INSERT em Aluguer | Atualiza automaticamente o estado do trator para "Alugado" |
| `setTratorLivre` | Fim de Aluguer | Restaura automaticamente o estado do trator para "Livre" |

#### Função Armazenada

| Função | Descrição |
|--------|-----------|
| `calcularCustoAluguer` | Calcula automaticamente o custo total de um aluguer com base no preço diário e duração |

#### Controlo de Acesso

O sistema implementa um modelo de segurança baseado em **privilégios mínimos**, com dois perfis de utilizador:

- **Administrador** — acesso total à gestão da base de dados, relatórios e dados sensíveis
- **Funcionário** — acesso limitado à consulta de clientes, tratores e registos de alugueres

#### Migração de Dados

O processo de migração consolidou dados de 3 fontes distintas na base de dados MySQL central, utilizando Python:

```
Stand Olivença (PostgreSQL) ──▶ ┐
Stand Lamego   (CSV)        ──▶ ├──▶ Script Python ──▶ MySQL Central
Stand (JSON)                ──▶ ┘
```

---

## Como Executar

### Pré-requisitos
- MySQL Server instalado e a correr
- Python 3.x com as bibliotecas: `mysql-connector-python`, `psycopg2`, `csv`, `json`
- Acesso à base de dados PostgreSQL do Stand de Olivença (para migração)

### 1. Criar a base de dados
```sql
CREATE DATABASE AgroAuto;
USE AgroAuto;
```

### 2. Executar a migração de dados
```bash
python3 src/migracao_dados.py
```

### 3. Verificar a migração
```sql
SELECT COUNT(*) FROM Cliente;
SELECT COUNT(*) FROM Trator;
SELECT COUNT(*) FROM Aluguer;
```

---
**Universidade do Minho · Escola de Engenharia · Unidade Curricular de Bases de Dados · Ano Letivo 2024/2025**