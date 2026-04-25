-- ============================================================
--  OFICINA MECÂNICA — Dados de Teste (Seed)
-- ============================================================

USE oficina_db;

-- ------------------------------------------------------------
-- CLIENTES
-- ------------------------------------------------------------
INSERT INTO Cliente (nome, cpf, telefone, email, logradouro, cidade, uf, cep, data_cadastro) VALUES
  ('Ana Paula Ferreira',   '11122233344', '(11)98001-1111', 'ana.ferreira@email.com',  'Rua das Flores, 10',      'São Paulo',       'SP', '01310000', '2023-01-15'),
  ('Bruno Carvalho Lima',  '22233344455', '(21)97002-2222', 'bruno.lima@email.com',    'Av. Atlântica, 500',      'Rio de Janeiro',  'RJ', '22010000', '2023-02-20'),
  ('Carla Mendes Souza',   '33344455566', '(31)96003-3333', 'carla.souza@email.com',   'Rua Bahia, 120',          'Belo Horizonte',  'MG', '30160010', '2023-03-05'),
  ('Diego Alves Ramos',    '44455566677', '(41)95004-4444', 'diego.ramos@email.com',   'Av. Sete de Setembro, 7', 'Curitiba',        'PR', '80050000', '2023-04-10'),
  ('Elaine Costa Braga',   '55566677788', '(51)94005-5555', 'elaine.braga@email.com',  'Rua dos Andradas, 300',   'Porto Alegre',    'RS', '90020006', '2023-05-18'),
  ('Fábio Nunes Martins',  '66677788899', '(62)93006-6666', 'fabio.martins@email.com', 'Rua 4, 44',               'Goiânia',         'GO', '74003000', '2023-06-22'),
  ('Gabriela Torres Paz',  '77788899900', '(71)92007-7777', 'gabriela.paz@email.com',  'Av. 7 de Setembro, 77',   'Salvador',        'BA', '40050001', '2023-07-30'),
  ('Henrique Melo Cruz',   '88899900011', '(85)91008-8888', 'henrique.cruz@email.com', 'Rua Pedro I, 88',         'Fortaleza',       'CE', '60175001', '2023-08-14'),
  ('Isabela Rocha Dias',   '99900011122', '(91)90009-9999', 'isabela.dias@email.com',  'Travessa Belo Horizonte', 'Belém',           'PA', '66040030', '2023-09-03'),
  ('Jorge Lopes Vieira',   '10011122233', '(92)89010-1010', 'jorge.vieira@email.com',  'Rua Floriano Peixoto, 1', 'Manaus',          'AM', '69010010', '2023-10-25');

-- ------------------------------------------------------------
-- VEÍCULOS
-- ------------------------------------------------------------
INSERT INTO Veiculo (id_cliente, placa, marca, modelo, ano_fabricacao, cor, km_atual) VALUES
  (1, 'ABC1D23', 'Chevrolet', 'Onix LT',       2020, 'Prata',   45000),
  (1, 'DEF4E56', 'Honda',     'HRV EX',         2022, 'Branco',  12000),
  (2, 'GHI7F89', 'Toyota',    'Corolla XEi',    2019, 'Preto',   78000),
  (3, 'JKL1G23', 'Volkswagen','Gol 1.6',        2018, 'Vermelho',95000),
  (4, 'MNO4H56', 'Ford',      'Ka SE 1.5',      2021, 'Azul',    30000),
  (5, 'PQR7I89', 'Fiat',      'Argo Drive',     2020, 'Cinza',   52000),
  (6, 'STU1J23', 'Renault',   'Kwid Zen',       2021, 'Laranja', 28000),
  (7, 'VWX4K56', 'Jeep',      'Compass Limited',2021, 'Preto',   40000),
  (8, 'YZA7L89', 'Hyundai',   'HB20 Evolution', 2022, 'Branco',  15000),
  (9, 'BCD1M23', 'Nissan',    'Kicks Advance',  2020, 'Prata',   61000),
  (10,'EFG4N56', 'Chevrolet', 'S10 High 4x4',   2019, 'Preto',   110000);

-- ------------------------------------------------------------
-- EQUIPES
-- ------------------------------------------------------------
INSERT INTO Equipe (nome_equipe, especialidade) VALUES
  ('Equipe Alpha', 'Motores e Transmissão'),
  ('Equipe Beta',  'Elétrica e Eletrônica'),
  ('Equipe Gamma', 'Funilaria e Pintura'),
  ('Equipe Delta', 'Suspensão e Freios');

-- ------------------------------------------------------------
-- MECÂNICOS
-- ------------------------------------------------------------
INSERT INTO Mecanico (id_equipe, nome, cpf, especialidade, salario_base, data_admissao) VALUES
  (1, 'Roberto Andrade',    '12312312312', 'Motor',         3800.00, '2020-01-10'),
  (1, 'Marcos Teixeira',    '23423423423', 'Transmissão',   3500.00, '2020-03-15'),
  (2, 'Patrícia Cunha',     '34534534534', 'Elétrica',      3600.00, '2019-06-01'),
  (2, 'Lucas Barbosa',      '45645645645', 'Injeção Eletr.', 3900.00,'2021-02-20'),
  (3, 'Fernando Gomes',     '56756756756', 'Funilaria',     3200.00, '2018-11-05'),
  (3, 'Aline Santos',       '67867867867', 'Pintura',       3400.00, '2019-09-12'),
  (4, 'Thiago Pereira',     '78978978978', 'Suspensão',     3700.00, '2020-07-22'),
  (4, 'Renata Oliveira',    '89089089089', 'Freios',        3650.00, '2021-04-30'),
  (NULL,'Carlos Freitas',   '90190190190', 'Geral',         3100.00, '2022-01-03'),
  (1, 'Sandro Meirelles',   '01201201201', 'Motor',         4100.00, '2017-05-18');

-- ------------------------------------------------------------
-- SERVIÇOS (catálogo)
-- ------------------------------------------------------------
INSERT INTO Servico (descricao, categoria, valor_mao_obra, tempo_estimado_h) VALUES
  ('Troca de óleo e filtro',                  'Revisão',    80.00,  1.0),
  ('Alinhamento e balanceamento',              'Suspensão', 120.00,  1.5),
  ('Revisão de freios (dianteiro)',            'Freios',    200.00,  2.5),
  ('Troca de correia dentada e tensor',        'Motor',     550.00,  4.0),
  ('Diagnóstico eletrônico (scanner)',         'Elétrica',   90.00,  1.0),
  ('Troca de amortecedores dianteiros (par)', 'Suspensão', 300.00,  3.0),
  ('Revisão do sistema de arrefecimento',      'Motor',     180.00,  2.0),
  ('Funilaria — amassado lateral',             'Funilaria', 400.00,  5.0),
  ('Pintura parcial (painel)',                 'Pintura',   700.00,  8.0),
  ('Instalação de som/central multimídia',     'Elétrica',  250.00,  3.0),
  ('Troca de embreagem completa',              'Transmissão',650.00, 6.0),
  ('Higienização de ar-condicionado',          'Revisão',   150.00,  1.5),
  ('Revisão dos 10.000 km',                   'Revisão',   350.00,  3.5),
  ('Revisão dos 30.000 km',                   'Revisão',   620.00,  5.0),
  ('Troca de pastilhas de freio traseiras',   'Freios',    160.00,  2.0);

-- ------------------------------------------------------------
-- PEÇAS
-- ------------------------------------------------------------
INSERT INTO Peca (nome, fabricante, numero_parte, preco_unitario, estoque_qtd) VALUES
  ('Filtro de óleo',           'Tecfil',    'PH360',    28.90, 50),
  ('Óleo motor 5W30 sintético (4L)', 'Mobil', 'M5W30',  89.90, 30),
  ('Pastilha freio dianteira', 'Bosch',     'BP1234',   95.00, 20),
  ('Correia dentada',          'Gates',     'GT2548',  120.00, 10),
  ('Tensor correia dentada',   'INA',       'TEN875',   75.00, 10),
  ('Amortecedor dianteiro',    'Sachs',     'SAC4412',  280.00, 8),
  ('Vela de ignição',          'NGK',       'BKR5EK',   18.50, 40),
  ('Fluido de freio DOT4 (0.5L)', 'Bosch',  'DOT4500',  22.00, 25),
  ('Correia do alternador',    'Gates',     'GT1022',   55.00, 15),
  ('Filtro de ar',             'Mann',      'C26168',   42.00, 35),
  ('Pastilha freio traseira',  'Fras-le',   'PD1122',   78.00, 20),
  ('Fluido arrefecimento (1L)','Arexons',   'AREC1L',   19.90, 30),
  ('Rolamento roda dianteira', 'SKF',       'SKF6205',  135.00, 12),
  ('Jogo de velas (4 un)',     'NGK',       'BKR5X4',   72.00, 18),
  ('Filtro de combustível',    'Mahle',     'KL147',    55.00, 22);

-- ------------------------------------------------------------
-- ORDENS DE SERVIÇO
-- ------------------------------------------------------------
INSERT INTO OrdemServico (id_veiculo, id_equipe, data_emissao, data_conclusao, status, desconto_pct, observacao) VALUES
  (1,  1, '2024-01-10 08:00:00', '2024-01-10 10:30:00', 'Concluída',              0.00, 'Revisão de rotina'),
  (3,  2, '2024-01-15 09:00:00', '2024-01-15 11:00:00', 'Concluída',              5.00, 'Cliente fidelidade'),
  (4,  4, '2024-02-01 08:30:00', '2024-02-02 17:00:00', 'Concluída',              0.00, NULL),
  (5,  1, '2024-02-10 10:00:00', '2024-02-12 16:00:00', 'Concluída',             10.00, 'Troca de correia — urgente'),
  (6,  4, '2024-03-05 08:00:00', '2024-03-05 10:00:00', 'Concluída',              0.00, NULL),
  (7,  3, '2024-03-20 09:30:00', '2024-03-22 18:00:00', 'Concluída',              0.00, 'Amassado lateral porta direita'),
  (8,  2, '2024-04-01 14:00:00', '2024-04-01 16:00:00', 'Concluída',              0.00, 'Central multimídia instalada'),
  (9,  1, '2024-04-15 08:00:00', '2024-04-17 17:00:00', 'Concluída',              8.00, 'Revisão 30k — desconto especial'),
  (10, 4, '2024-05-02 07:30:00', '2024-05-03 12:00:00', 'Concluída',              0.00, 'Amortecedores e freios'),
  (2,  2, '2024-05-20 09:00:00', '2024-05-20 10:30:00', 'Concluída',              0.00, NULL),
  (11, 1, '2024-06-10 08:00:00',  NULL,                  'Em Execução',            0.00, 'Troca de embreagem S10'),
  (1,  NULL,'2024-06-15 10:00:00', NULL,                 'Aguardando Autorização', 0.00, 'Cliente solicitou orçamento'),
  (3,  4, '2024-06-18 09:00:00',  NULL,                  'Aguardando Peça',        0.00, 'Aguardando rolamento SKF'),
  (5,  3, '2024-06-20 14:00:00',  NULL,                  'Autorizada',             5.00, 'Pintura parcial aprovada'),
  (6,  1, '2024-06-22 08:30:00', '2024-06-22 11:30:00', 'Concluída',              0.00, 'Troca de velas e filtro ar');

-- ------------------------------------------------------------
-- OS ↔ SERVIÇOS
-- ------------------------------------------------------------
INSERT INTO OS_Servico (id_os, id_servico, qtd, valor_cobrado) VALUES
  -- OS 1: troca de óleo + revisão 10k
  (1,  1, 1,  80.00),
  (1, 13, 1, 350.00),
  -- OS 2: diagnóstico + elétrica
  (2,  5, 1,  90.00),
  -- OS 3: freios dianteiro
  (3,  3, 1, 200.00),
  -- OS 4: correia dentada
  (4,  4, 1, 550.00),
  -- OS 5: alinhamento + balanceamento
  (5,  2, 1, 120.00),
  -- OS 6: funilaria + pintura
  (6,  8, 1, 400.00),
  (6,  9, 1, 700.00),
  -- OS 7: instalação de som
  (7, 10, 1, 250.00),
  -- OS 8: revisão 30k
  (8, 14, 1, 620.00),
  -- OS 9: suspensão + freios
  (9,  6, 1, 300.00),
  (9,  3, 1, 200.00),
  (9, 15, 1, 160.00),
  -- OS 10: ar-condicionado
  (10,12, 1, 150.00),
  -- OS 11: embreagem
  (11,11, 1, 650.00),
  -- OS 12: orçamento apenas (sem serviço executado)
  -- OS 13: aguardando peça — somente serviço
  (13, 2, 1, 120.00),
  -- OS 14: pintura autorizada
  (14, 9, 1, 700.00),
  -- OS 15: velas + filtro (revisão simples)
  (15, 1, 1,  80.00);

-- ------------------------------------------------------------
-- OS ↔ PEÇAS
-- ------------------------------------------------------------
INSERT INTO OS_Peca (id_os, id_peca, qtd, preco_unitario) VALUES
  -- OS 1
  (1,  1, 1, 28.90),  -- filtro óleo
  (1,  2, 1, 89.90),  -- óleo motor
  -- OS 3
  (3,  3, 1, 95.00),  -- pastilha dianteira
  (3,  8, 1, 22.00),  -- fluido freio
  -- OS 4
  (4,  4, 1,120.00),  -- correia dentada
  (4,  5, 1, 75.00),  -- tensor
  -- OS 6 — sem peças (serviço de funilaria/pintura)
  -- OS 8: revisão 30k
  (8,  1, 1, 28.90),
  (8,  2, 1, 89.90),
  (8, 10, 1, 42.00),  -- filtro ar
  (8, 14, 1, 72.00),  -- jogo velas
  (8,  8, 1, 22.00),  -- fluido freio
  -- OS 9: amortecedores + freios
  (9,  6, 2,280.00),  -- 2 amortecedores
  (9, 11, 1, 78.00),  -- pastilha traseira
  (9,  8, 1, 22.00),
  -- OS 11: embreagem (sem detalhe de peças ainda)
  -- OS 13: rolamento aguardado
  (13,13, 1,135.00),
  -- OS 15
  (15, 1, 1, 28.90),
  (15,10, 1, 42.00),
  (15,14, 1, 72.00);

-- ------------------------------------------------------------
-- PAGAMENTOS
-- ------------------------------------------------------------
INSERT INTO Pagamento (id_os, forma, valor_pago, data_pagamento) VALUES
  (1,  'PIX',            558.80, '2024-01-10 11:00:00'),
  (2,  'Cartão Crédito', 171.00, '2024-01-15 11:30:00'),
  (3,  'Dinheiro',       317.00, '2024-02-02 17:30:00'),
  (4,  'PIX',            758.70, '2024-02-12 16:30:00'),  -- 10% desconto
  (5,  'Cartão Débito',  120.00, '2024-03-05 10:30:00'),
  (6,  'Boleto',        1100.00, '2024-03-22 18:30:00'),
  (7,  'PIX',            250.00, '2024-04-01 16:30:00'),
  (8,  'Cartão Crédito', 780.81, '2024-04-17 17:30:00'),  -- 8% desconto
  (9,  'Dinheiro',       760.00, '2024-05-03 12:30:00'),
  (10, 'PIX',            150.00, '2024-05-20 11:00:00'),
  (15, 'Dinheiro',       222.90, '2024-06-22 12:00:00');
