-- ============================================================
--  OFICINA MECÂNICA — Esquema Lógico Relacional
--  Autor  : Projeto DIO — Desafio de Banco de Dados
--  SGBD   : MySQL 8.x / MariaDB 10.6+
-- ============================================================

CREATE DATABASE IF NOT EXISTS oficina_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE oficina_db;

-- ------------------------------------------------------------
-- 1. CLIENTE
-- ------------------------------------------------------------
CREATE TABLE Cliente (
  id_cliente      INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  nome            VARCHAR(100)     NOT NULL,
  cpf             CHAR(11)         NOT NULL,
  telefone        VARCHAR(15)      NOT NULL,
  email           VARCHAR(120)         NULL,
  logradouro      VARCHAR(150)         NULL,
  cidade          VARCHAR(80)          NULL,
  uf              CHAR(2)              NULL,
  cep             CHAR(8)              NULL,
  data_cadastro   DATE             NOT NULL DEFAULT (CURRENT_DATE),
  CONSTRAINT pk_cliente      PRIMARY KEY (id_cliente),
  CONSTRAINT uq_cliente_cpf  UNIQUE      (cpf)
) COMMENT='Clientes da oficina (pessoa física)';

-- ------------------------------------------------------------
-- 2. VEÍCULO
-- ------------------------------------------------------------
CREATE TABLE Veiculo (
  id_veiculo      INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_cliente      INT UNSIGNED     NOT NULL,
  placa           VARCHAR(8)       NOT NULL,
  marca           VARCHAR(50)      NOT NULL,
  modelo          VARCHAR(80)      NOT NULL,
  ano_fabricacao  YEAR             NOT NULL,
  cor             VARCHAR(30)          NULL,
  km_atual        INT UNSIGNED         NULL,
  CONSTRAINT pk_veiculo       PRIMARY KEY (id_veiculo),
  CONSTRAINT uq_veiculo_placa UNIQUE      (placa),
  CONSTRAINT fk_veiculo_cliente
    FOREIGN KEY (id_cliente) REFERENCES Cliente (id_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE
) COMMENT='Veículos vinculados a clientes';

-- ------------------------------------------------------------
-- 3. EQUIPE
-- ------------------------------------------------------------
CREATE TABLE Equipe (
  id_equipe       INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  nome_equipe     VARCHAR(80)      NOT NULL,
  especialidade   VARCHAR(100)         NULL,
  CONSTRAINT pk_equipe PRIMARY KEY (id_equipe)
) COMMENT='Equipes de mecânicos';

-- ------------------------------------------------------------
-- 4. MECÂNICO
-- ------------------------------------------------------------
CREATE TABLE Mecanico (
  id_mecanico     INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_equipe       INT UNSIGNED         NULL,
  nome            VARCHAR(100)     NOT NULL,
  cpf             CHAR(11)         NOT NULL,
  especialidade   VARCHAR(100)         NULL,
  salario_base    DECIMAL(10,2)    NOT NULL,
  data_admissao   DATE             NOT NULL,
  CONSTRAINT pk_mecanico      PRIMARY KEY (id_mecanico),
  CONSTRAINT uq_mecanico_cpf  UNIQUE      (cpf),
  CONSTRAINT fk_mecanico_equipe
    FOREIGN KEY (id_equipe) REFERENCES Equipe (id_equipe)
    ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='Mecânicos da oficina';

-- ------------------------------------------------------------
-- 5. SERVIÇO (catálogo)
-- ------------------------------------------------------------
CREATE TABLE Servico (
  id_servico      INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  descricao       VARCHAR(150)     NOT NULL,
  categoria       VARCHAR(60)      NOT NULL,   -- ex.: 'Revisão', 'Elétrica', 'Funilaria'
  valor_mao_obra  DECIMAL(10,2)    NOT NULL,
  tempo_estimado_h DECIMAL(5,2)    NOT NULL,   -- horas estimadas
  CONSTRAINT pk_servico PRIMARY KEY (id_servico)
) COMMENT='Catálogo de serviços oferecidos';

-- ------------------------------------------------------------
-- 6. PEÇA
-- ------------------------------------------------------------
CREATE TABLE Peca (
  id_peca         INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  nome            VARCHAR(120)     NOT NULL,
  fabricante      VARCHAR(80)          NULL,
  numero_parte    VARCHAR(50)          NULL,
  preco_unitario  DECIMAL(10,2)    NOT NULL,
  estoque_qtd     INT UNSIGNED     NOT NULL DEFAULT 0,
  CONSTRAINT pk_peca PRIMARY KEY (id_peca)
) COMMENT='Estoque de peças';

-- ------------------------------------------------------------
-- 7. ORDEM DE SERVIÇO (OS)
-- ------------------------------------------------------------
CREATE TABLE OrdemServico (
  id_os           INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_veiculo      INT UNSIGNED     NOT NULL,
  id_equipe       INT UNSIGNED         NULL,
  data_emissao    DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  data_conclusao  DATETIME             NULL,
  status          ENUM(
                    'Aguardando Autorização',
                    'Autorizada',
                    'Em Execução',
                    'Aguardando Peça',
                    'Concluída',
                    'Cancelada'
                  ) NOT NULL DEFAULT 'Aguardando Autorização',
  observacao      TEXT                 NULL,
  desconto_pct    DECIMAL(5,2)     NOT NULL DEFAULT 0.00, -- 0-100
  CONSTRAINT pk_os PRIMARY KEY (id_os),
  CONSTRAINT fk_os_veiculo
    FOREIGN KEY (id_veiculo) REFERENCES Veiculo (id_veiculo)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_os_equipe
    FOREIGN KEY (id_equipe) REFERENCES Equipe (id_equipe)
    ON DELETE SET NULL ON UPDATE CASCADE
) COMMENT='Ordens de Serviço';

-- ------------------------------------------------------------
-- 8. OS ↔ SERVIÇO  (N:M)
-- ------------------------------------------------------------
CREATE TABLE OS_Servico (
  id_os           INT UNSIGNED     NOT NULL,
  id_servico      INT UNSIGNED     NOT NULL,
  qtd             INT UNSIGNED     NOT NULL DEFAULT 1,
  valor_cobrado   DECIMAL(10,2)    NOT NULL,  -- snapshot do valor no momento
  CONSTRAINT pk_os_servico PRIMARY KEY (id_os, id_servico),
  CONSTRAINT fk_osserv_os
    FOREIGN KEY (id_os)      REFERENCES OrdemServico (id_os)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_osserv_serv
    FOREIGN KEY (id_servico) REFERENCES Servico (id_servico)
    ON DELETE RESTRICT ON UPDATE CASCADE
) COMMENT='Serviços executados em cada OS';

-- ------------------------------------------------------------
-- 9. OS ↔ PEÇA  (N:M)
-- ------------------------------------------------------------
CREATE TABLE OS_Peca (
  id_os           INT UNSIGNED     NOT NULL,
  id_peca         INT UNSIGNED     NOT NULL,
  qtd             INT UNSIGNED     NOT NULL DEFAULT 1,
  preco_unitario  DECIMAL(10,2)    NOT NULL,  -- snapshot do preço
  CONSTRAINT pk_os_peca PRIMARY KEY (id_os, id_peca),
  CONSTRAINT fk_ospeca_os
    FOREIGN KEY (id_os)   REFERENCES OrdemServico (id_os)
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_ospeca_peca
    FOREIGN KEY (id_peca) REFERENCES Peca (id_peca)
    ON DELETE RESTRICT ON UPDATE CASCADE
) COMMENT='Peças utilizadas em cada OS';

-- ------------------------------------------------------------
-- 10. PAGAMENTO
-- ------------------------------------------------------------
CREATE TABLE Pagamento (
  id_pagamento    INT UNSIGNED     NOT NULL AUTO_INCREMENT,
  id_os           INT UNSIGNED     NOT NULL,
  forma           ENUM('Dinheiro','Cartão Crédito','Cartão Débito','PIX','Boleto')
                                   NOT NULL,
  valor_pago      DECIMAL(10,2)    NOT NULL,
  data_pagamento  DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT pk_pagamento PRIMARY KEY (id_pagamento),
  CONSTRAINT fk_pagamento_os
    FOREIGN KEY (id_os) REFERENCES OrdemServico (id_os)
    ON DELETE RESTRICT ON UPDATE CASCADE
) COMMENT='Registros de pagamento das OS';

-- ============================================================
--  VIEWS AUXILIARES
-- ============================================================

-- Valor total de cada OS (mão de obra + peças - desconto)
CREATE OR REPLACE VIEW vw_total_os AS
SELECT
  os.id_os,
  os.status,
  os.desconto_pct,
  COALESCE(SUM(osp.qtd * osp.preco_unitario),  0) AS total_pecas,
  COALESCE(SUM(oss.qtd * oss.valor_cobrado),   0) AS total_mao_obra,
  ROUND(
    (COALESCE(SUM(osp.qtd * osp.preco_unitario), 0)
   + COALESCE(SUM(oss.qtd * oss.valor_cobrado),  0))
   * (1 - os.desconto_pct / 100), 2
  ) AS valor_total
FROM OrdemServico os
LEFT JOIN OS_Peca   osp ON osp.id_os = os.id_os
LEFT JOIN OS_Servico oss ON oss.id_os = os.id_os
GROUP BY os.id_os, os.status, os.desconto_pct;



