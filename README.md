# 🔧 Oficina Mecânica — Banco de Dados Relacional

Projeto de modelagem e implementação de banco de dados relacional para o contexto de uma **oficina mecânica**, desenvolvido como desafio do módulo de **Modelagem de Banco de Dados** da DIO.

---

## 📐 Esquema Lógico

O esquema foi projetado a partir do modelo ER (Entidade-Relacionamento) e convertido para o modelo relacional. A estrutura cobre todo o fluxo de trabalho de uma oficina: cadastro de clientes e veículos, montagem de equipes, catálogo de serviços, controle de estoque de peças, emissão de Ordens de Serviço e registro de pagamentos.

### Diagrama de Entidades e Relacionamentos

```
Cliente ─────< Veiculo >──────< OrdemServico >─────< OS_Servico >─────< Servico
                                      │
                                      │──────────< OS_Peca >──────────< Peca
                                      │
                               Equipe ──< Mecanico
```

### Tabelas

| Tabela | Responsabilidade |
|---|---|
| `Cliente` | Dados cadastrais dos clientes (CPF único) |
| `Veiculo` | Veículos vinculados a clientes (placa única) |
| `Equipe` | Agrupamento de mecânicos por especialidade |
| `Mecanico` | Profissionais com vínculo opcional a equipes |
| `Servico` | Catálogo de serviços com valor de mão de obra |
| `Peca` | Estoque de peças com preço unitário |
| `OrdemServico` | OS com status, desconto e referência ao veículo/equipe |
| `OS_Servico` | Tabela associativa OS ↔ Serviço (N:M) |
| `OS_Peca` | Tabela associativa OS ↔ Peça (N:M) |
| `Pagamento` | Registro de pagamentos por forma de pagamento |

### Decisões de Modelagem

- **Snapshot de preços**: as tabelas `OS_Servico` e `OS_Peca` armazenam o preço cobrado **no momento da OS**, preservando o histórico mesmo que o catálogo seja atualizado.
- **Status da OS**: campo `ENUM` com ciclo de vida completo — *Aguardando Autorização → Autorizada → Em Execução → Aguardando Peça → Concluída / Cancelada*.
- **Desconto por OS**: percentual de desconto (`desconto_pct`) aplicado globalmente sobre o valor bruto da OS.
- **Mecânico sem equipe**: `id_equipe` é opcional, permitindo mecânicos autônomos na oficina.
- **View auxiliar** `vw_total_os`: calcula automaticamente totais de peças, serviços e valor líquido com desconto, evitando cálculos repetitivos nas queries.

---

## 📁 Estrutura do Repositório

```
desafio-DIO-BDLogicoDoZero/
├── sql/
│   ├── Criacao.sql   → DDL: criação de tabelas, views e constraints
│   ├── Povoamento.sql     → DML: dados de teste (10 clientes, 11 veículos, 15 OS...)
│   └── Recuperacao.sql  → 20 queries analíticas comentadas
└── README.md
```

---

## 🚀 Como Executar

**Pré-requisito**: MySQL 8.x ou MariaDB 10.6+

```bash
# 1. Criar o banco e as tabelas
mysql -u root -p < sql/Criacao.sql

# 2. Popular com dados de teste
mysql -u root -p < sql/Povoamento.sql

# 3. Executar as queries
mysql -u root -p desafio-DIO-BDLogicoDoZero < sql/Recuperacao.sql
```

---

## 🔍 Queries Implementadas

Todas as cláusulas exigidas estão cobertas:

### SELECT simples
| # | Pergunta |
|---|---|
| Q1 | Quais são todos os clientes cadastrados na oficina? |
| Q2 | Quais serviços estão disponíveis e qual o valor da mão de obra? |
| Q3 | Qual o estoque atual de peças e seu valor total em R$? |

### WHERE — Filtros
| # | Pergunta |
|---|---|
| Q4 | Quais OS estão em andamento ou aguardando peça? |
| Q5 | Quais peças têm estoque abaixo de 15 unidades? |
| Q6 | Quais mecânicos ganham acima da média salarial? |
| Q7 | Quais veículos têm mais de 80.000 km rodados? |

### Atributos Derivados
| # | Pergunta |
|---|---|
| Q8 | Qual é o valor bruto, desconto em R$ e valor líquido de cada OS concluída? |
| Q9 | Qual a receita mensal da oficina em 2024? |
| Q10 | Ranking de mecânicos por salário e anos de empresa |
| Q11 | Veículos com faixa de uso calculada (baixa/média/alta rodagem) |

### HAVING — Filtro em grupos
| # | Pergunta |
|---|---|
| Q12 | Quais clientes geraram receita líquida acima de R$500? |
| Q13 | Quais categorias de serviço têm ticket médio acima de R$200? |
| Q14 | Quais equipes realizaram mais de 3 OS em 2024? |

### JOINs — Perspectiva complexa
| # | Pergunta |
|---|---|
| Q15 | Visão completa de cada OS: cliente, veículo, equipe, serviços e peças |
| Q16 | Histórico completo de manutenção de cada veículo |
| Q17 | Quais os 5 serviços mais executados e sua receita acumulada? |
| Q18 | Relatório de pagamentos com saldo pendente por OS |
| Q19 | Mecânicos com total de OS atendidas pela equipe e receita estimada por profissional |
| Q20 | Peças mais consumidas com cobertura estimada de estoque |

---

## 🛠 Tecnologias

- **SGBD**: MySQL 8.x / MariaDB 10.6+
- **Linguagem**: SQL (DDL + DML)
- **Paradigma**: Modelo Relacional

---

## 👤 Autor

Projeto desenvolvido como parte do desafio **"Construindo seu Primeiro Projeto Lógico de Banco de Dados"** — Bootcamp DIO.
