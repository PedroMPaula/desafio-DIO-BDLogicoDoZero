-- ============================================================
--  OFICINA MECÂNICA — Queries Analíticas
--  Todas as cláusulas solicitadas estão presentes:
--  SELECT, WHERE, atributos derivados, ORDER BY, HAVING, JOIN
-- ============================================================

USE oficina_db;

-- ============================================================
--  BLOCO 1 — SELECT simples
-- ============================================================

-- Q1: Quais são todos os clientes cadastrados na oficina?
SELECT
  id_cliente,
  nome,
  cpf,
  telefone,
  email,
  cidade,
  uf
FROM Cliente
ORDER BY nome;

-- Q2: Quais serviços estão disponíveis e qual o valor da mão de obra?
SELECT
  id_servico,
  descricao,
  categoria,
  valor_mao_obra,
  tempo_estimado_h
FROM Servico
ORDER BY categoria, valor_mao_obra DESC;

-- Q3: Qual o estoque atual de peças?
SELECT
  nome,
  fabricante,
  numero_parte,
  preco_unitario,
  estoque_qtd,
  (preco_unitario * estoque_qtd) AS valor_total_estoque  -- atributo derivado
FROM Peca
ORDER BY valor_total_estoque DESC;


-- ============================================================
--  BLOCO 2 — WHERE (filtros)
-- ============================================================

-- Q4: Quais OS estão em andamento ou aguardando peça?
SELECT
  id_os,
  id_veiculo,
  data_emissao,
  status,
  observacao
FROM OrdemServico
WHERE status IN ('Em Execução', 'Aguardando Peça', 'Autorizada')
ORDER BY data_emissao;

-- Q5: Quais peças têm estoque abaixo de 15 unidades?
SELECT
  nome,
  fabricante,
  estoque_qtd,
  preco_unitario
FROM Peca
WHERE estoque_qtd < 15
ORDER BY estoque_qtd ASC;

-- Q6: Quais mecânicos ganham acima da média salarial?
SELECT
  nome,
  especialidade,
  salario_base
FROM Mecanico
WHERE salario_base > (SELECT AVG(salario_base) FROM Mecanico)
ORDER BY salario_base DESC;

-- Q7: Quais veículos têm mais de 80.000 km rodados?
SELECT
  v.placa,
  v.marca,
  v.modelo,
  v.ano_fabricacao,
  v.km_atual,
  c.nome AS proprietario
FROM Veiculo v
JOIN Cliente c ON c.id_cliente = v.id_cliente
WHERE v.km_atual > 80000
ORDER BY v.km_atual DESC;


-- ============================================================
--  BLOCO 3 — Atributos derivados
-- ============================================================

-- Q8: Qual é o valor bruto, desconto em R$ e valor líquido de cada OS concluída?
SELECT
  os.id_os,
  c.nome                                        AS cliente,
  CONCAT(v.marca, ' ', v.modelo)                AS veiculo,
  os.data_emissao,
  os.data_conclusao,
  os.desconto_pct,
  -- mão de obra total
  COALESCE(SUM(oss.qtd * oss.valor_cobrado), 0) AS total_servicos,
  -- peças total
  COALESCE(SUM(osp.qtd * osp.preco_unitario),0) AS total_pecas,
  -- valor bruto
  ROUND(
    COALESCE(SUM(oss.qtd * oss.valor_cobrado), 0)
  + COALESCE(SUM(osp.qtd * osp.preco_unitario),0), 2
  )                                              AS valor_bruto,
  -- desconto em R$
  ROUND(
   (COALESCE(SUM(oss.qtd * oss.valor_cobrado), 0)
  + COALESCE(SUM(osp.qtd * osp.preco_unitario),0))
  * (os.desconto_pct / 100), 2
  )                                              AS desconto_reais,
  -- valor líquido
  ROUND(
   (COALESCE(SUM(oss.qtd * oss.valor_cobrado), 0)
  + COALESCE(SUM(osp.qtd * osp.preco_unitario),0))
  * (1 - os.desconto_pct / 100), 2
  )                                              AS valor_liquido,
  -- tempo decorrido em horas (atributo derivado temporal)
  ROUND(TIMESTAMPDIFF(MINUTE, os.data_emissao, os.data_conclusao) / 60.0, 1)
                                                 AS duracao_horas
FROM OrdemServico os
JOIN Veiculo       v   ON v.id_veiculo  = os.id_veiculo
JOIN Cliente       c   ON c.id_cliente  = v.id_cliente
LEFT JOIN OS_Servico oss ON oss.id_os   = os.id_os
LEFT JOIN OS_Peca    osp ON osp.id_os   = os.id_os
WHERE os.status = 'Concluída'
GROUP BY os.id_os, c.nome, veiculo, os.data_emissao, os.data_conclusao, os.desconto_pct
ORDER BY os.data_emissao DESC;


-- Q9: Qual a receita mensal da oficina (mão de obra + peças) em 2024?
SELECT
  DATE_FORMAT(os.data_emissao, '%Y-%m')                AS mes_ano,
  COUNT(DISTINCT os.id_os)                             AS qtd_os,
  ROUND(SUM(oss.qtd * oss.valor_cobrado),   2)         AS receita_servicos,
  ROUND(SUM(osp.qtd * osp.preco_unitario),  2)         AS receita_pecas,
  ROUND(
    COALESCE(SUM(oss.qtd * oss.valor_cobrado), 0)
  + COALESCE(SUM(osp.qtd * osp.preco_unitario), 0), 2
  )                                                    AS receita_bruta_total
FROM OrdemServico os
LEFT JOIN OS_Servico oss ON oss.id_os = os.id_os
LEFT JOIN OS_Peca    osp ON osp.id_os = os.id_os
WHERE YEAR(os.data_emissao) = 2024
  AND os.status = 'Concluída'
GROUP BY mes_ano
ORDER BY mes_ano;


-- ============================================================
--  BLOCO 4 — ORDER BY
-- ============================================================

-- Q10: Ranking de mecânicos por salário (maior para menor)
SELECT
  m.nome,
  e.nome_equipe,
  m.especialidade,
  m.salario_base,
  m.data_admissao,
  -- anos de casa (atributo derivado)
  FLOOR(DATEDIFF(CURRENT_DATE, m.data_admissao) / 365) AS anos_empresa
FROM Mecanico m
LEFT JOIN Equipe e ON e.id_equipe = m.id_equipe
ORDER BY m.salario_base DESC, anos_empresa DESC;

-- Q11: Veículos ordenados por quilometragem (mais rodado primeiro)
SELECT
  v.placa,
  CONCAT(v.marca, ' ', v.modelo, ' (', v.ano_fabricacao, ')') AS identificacao,
  c.nome          AS proprietario,
  v.km_atual,
  -- faixa de uso (atributo derivado)
  CASE
    WHEN v.km_atual < 30000  THEN 'Baixa rodagem'
    WHEN v.km_atual < 80000  THEN 'Rodagem média'
    ELSE                          'Alta rodagem'
  END AS faixa_km
FROM Veiculo v
JOIN Cliente c ON c.id_cliente = v.id_cliente
ORDER BY v.km_atual DESC;


-- ============================================================
--  BLOCO 5 — HAVING
-- ============================================================

-- Q12: Quais clientes geraram receita (valor líquido) acima de R$500 no total?
SELECT
  c.nome                                              AS cliente,
  c.cidade,
  COUNT(DISTINCT os.id_os)                            AS total_os,
  ROUND(SUM(
    (COALESCE(oss.qtd * oss.valor_cobrado, 0)
   + COALESCE(osp.qtd * osp.preco_unitario, 0))
   * (1 - os.desconto_pct / 100)
  ), 2)                                               AS receita_liquida_total
FROM Cliente c
JOIN Veiculo       v   ON v.id_cliente  = c.id_cliente
JOIN OrdemServico  os  ON os.id_veiculo = v.id_veiculo
LEFT JOIN OS_Servico oss ON oss.id_os   = os.id_os
LEFT JOIN OS_Peca    osp ON osp.id_os   = os.id_os
WHERE os.status = 'Concluída'
GROUP BY c.id_cliente, c.nome, c.cidade
HAVING receita_liquida_total > 500
ORDER BY receita_liquida_total DESC;

-- Q13: Quais categorias de serviço têm ticket médio de mão de obra acima de R$200?
SELECT
  s.categoria,
  COUNT(*)                               AS vezes_executado,
  ROUND(AVG(oss.valor_cobrado), 2)       AS ticket_medio,
  ROUND(SUM(oss.qtd * oss.valor_cobrado), 2) AS receita_total_categoria
FROM Servico s
JOIN OS_Servico oss ON oss.id_servico = s.id_servico
GROUP BY s.categoria
HAVING ticket_medio > 200
ORDER BY ticket_medio DESC;

-- Q14: Quais equipes realizaram mais de 3 OS em 2024?
SELECT
  e.nome_equipe,
  e.especialidade,
  COUNT(DISTINCT os.id_os)  AS total_os,
  COUNT(DISTINCT os.id_veiculo) AS veiculos_distintos
FROM Equipe e
JOIN OrdemServico os ON os.id_equipe = e.id_equipe
WHERE YEAR(os.data_emissao) = 2024
GROUP BY e.id_equipe, e.nome_equipe, e.especialidade
HAVING total_os > 3
ORDER BY total_os DESC;


-- ============================================================
--  BLOCO 6 — JOINs (perspectiva complexa)
-- ============================================================

-- Q15: Visão completa de cada OS — cliente, veículo, equipe, serviços e peças
SELECT
  os.id_os,
  c.nome                                           AS cliente,
  c.telefone,
  CONCAT(v.marca, ' ', v.modelo)                   AS veiculo,
  v.placa,
  e.nome_equipe                                    AS equipe,
  os.status,
  os.data_emissao,
  os.data_conclusao,
  GROUP_CONCAT(DISTINCT s.descricao  ORDER BY s.descricao SEPARATOR ' | ') AS servicos,
  GROUP_CONCAT(DISTINCT p.nome       ORDER BY p.nome      SEPARATOR ' | ') AS pecas_usadas,
  os.desconto_pct
FROM OrdemServico  os
JOIN Veiculo       v   ON v.id_veiculo  = os.id_veiculo
JOIN Cliente       c   ON c.id_cliente  = v.id_cliente
LEFT JOIN Equipe   e   ON e.id_equipe   = os.id_equipe
LEFT JOIN OS_Servico oss ON oss.id_os   = os.id_os
LEFT JOIN Servico  s   ON s.id_servico  = oss.id_servico
LEFT JOIN OS_Peca  osp ON osp.id_os     = os.id_os
LEFT JOIN Peca     p   ON p.id_peca     = osp.id_peca
GROUP BY os.id_os, c.nome, c.telefone, veiculo, v.placa,
         e.nome_equipe, os.status, os.data_emissao,
         os.data_conclusao, os.desconto_pct
ORDER BY os.data_emissao DESC;


-- Q16: Qual o histórico completo de manutenção de cada veículo?
SELECT
  v.placa,
  CONCAT(v.marca, ' ', v.modelo, ' (', v.ano_fabricacao, ')') AS veiculo,
  c.nome          AS proprietario,
  os.id_os,
  os.data_emissao,
  os.status,
  s.descricao     AS servico,
  oss.valor_cobrado,
  p.nome          AS peca,
  osp.qtd         AS qtd_peca,
  osp.preco_unitario
FROM Veiculo       v
JOIN Cliente       c   ON c.id_cliente  = v.id_cliente
JOIN OrdemServico  os  ON os.id_veiculo = v.id_veiculo
LEFT JOIN OS_Servico oss ON oss.id_os   = os.id_os
LEFT JOIN Servico  s   ON s.id_servico  = oss.id_servico
LEFT JOIN OS_Peca  osp ON osp.id_os     = os.id_os
LEFT JOIN Peca     p   ON p.id_peca     = osp.id_peca
ORDER BY v.placa, os.data_emissao, s.descricao;


-- Q17: Quais são os 5 serviços mais executados e sua receita acumulada?
SELECT
  s.descricao,
  s.categoria,
  s.valor_mao_obra                                 AS preco_tabela,
  COUNT(oss.id_os)                                 AS vezes_executado,
  ROUND(SUM(oss.qtd * oss.valor_cobrado), 2)       AS receita_acumulada,
  -- diferença entre cobrado e tabela (atributo derivado)
  ROUND(AVG(oss.valor_cobrado) - s.valor_mao_obra, 2) AS desvio_medio_tabela
FROM Servico s
JOIN OS_Servico oss ON oss.id_servico = s.id_servico
GROUP BY s.id_servico, s.descricao, s.categoria, s.valor_mao_obra
ORDER BY vezes_executado DESC, receita_acumulada DESC
LIMIT 5;


-- Q18: Relatório de pagamentos — OS, forma de pagamento e saldo restante
SELECT
  os.id_os,
  c.nome                                            AS cliente,
  vt.valor_total                                    AS valor_os,
  pg.forma                                          AS forma_pagamento,
  pg.valor_pago,
  pg.data_pagamento,
  ROUND(vt.valor_total - pg.valor_pago, 2)          AS saldo_pendente,
  CASE
    WHEN pg.valor_pago >= vt.valor_total THEN 'Quitada'
    WHEN pg.valor_pago  > 0             THEN 'Parcial'
    ELSE                                     'Não pago'
  END AS situacao_pagamento
FROM OrdemServico os
JOIN Veiculo       v   ON v.id_veiculo  = os.id_veiculo
JOIN Cliente       c   ON c.id_cliente  = v.id_cliente
JOIN vw_total_os   vt  ON vt.id_os      = os.id_os
LEFT JOIN Pagamento pg  ON pg.id_os     = os.id_os
WHERE os.status = 'Concluída'
ORDER BY saldo_pendente DESC, os.data_conclusao DESC;


-- Q19: Mecânicos e suas equipes com total de OS atendidas
SELECT
  m.nome                                   AS mecanico,
  m.especialidade,
  COALESCE(e.nome_equipe, 'Sem equipe')    AS equipe,
  m.salario_base,
  COUNT(DISTINCT os.id_os)                 AS total_os_da_equipe,
  -- custo de mão de obra por OS da equipe (proxy de produtividade)
  ROUND(
    COALESCE(SUM(oss.qtd * oss.valor_cobrado), 0)
    / NULLIF(COUNT(DISTINCT m2.id_mecanico), 0), 2
  )                                        AS receita_por_mecanico_equipe
FROM Mecanico m
LEFT JOIN Equipe       e   ON e.id_equipe   = m.id_equipe
LEFT JOIN Mecanico     m2  ON m2.id_equipe  = m.id_equipe
LEFT JOIN OrdemServico os  ON os.id_equipe  = m.id_equipe
LEFT JOIN OS_Servico   oss ON oss.id_os     = os.id_os
GROUP BY m.id_mecanico, m.nome, m.especialidade, equipe, m.salario_base
ORDER BY receita_por_mecanico_equipe DESC, m.salario_base DESC;


-- Q20: Peças mais utilizadas e seu impacto financeiro total
SELECT
  p.nome                                            AS peca,
  p.fabricante,
  p.preco_unitario                                  AS preco_atual,
  SUM(osp.qtd)                                      AS qtd_consumida,
  ROUND(SUM(osp.qtd * osp.preco_unitario), 2)       AS receita_peca,
  p.estoque_qtd                                     AS estoque_atual,
  -- estimativa de cobertura de estoque (atributo derivado)
  ROUND(p.estoque_qtd / NULLIF(SUM(osp.qtd),0), 1)  AS cobertura_em_os
FROM Peca p
JOIN OS_Peca osp ON osp.id_peca = p.id_peca
GROUP BY p.id_peca, p.nome, p.fabricante, p.preco_unitario, p.estoque_qtd
HAVING SUM(osp.qtd) > 0
ORDER BY receita_peca DESC;
