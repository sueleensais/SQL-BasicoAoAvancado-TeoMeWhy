# SQL - Primeiras Magias - Do Zero ao Avançado

Este repositório contém meus estudos e práticas do curso **"SQL – Primeiras Magias"**, ministrado por Téo Calvo na plataforma **TeoMeWhy** (https://www.teomewhy.org).  
Foi meu primeiro contato com bancos de dados relacionais e com a linguagem SQL, e a experiência me levou do zero até técnicas avançadas.

Durante o curso, utilizei dados reais (anonimizados) e coloquei em prática muitos exercícios.

# Conteúdo do curso

- **Fundamentos Básicos**  
  Conceitos de banco de dados, SGBD, tabelas, registros, chaves primárias e estrangeiras, constraints e sequências.  

- **Ferramentas**  
  Uso do VSCode integrado ao SQLite.  

- **Consultas (DQL)**  
  `SELECT`, `FROM`, `WHERE`, `CASE WHEN`.  

- **Agregações**  
  `SUM`, `COUNT`, `AVG`, `MIN`, `MAX`.  

- **Organização de dados**  
  `GROUP BY`, `ORDER BY`, `HAVING`.  

- **JOINs**  
  `LEFT`, `RIGHT`, `INNER`.  

- **Consultas avançadas**  
  Subqueries e CTEs.  

- **Window Functions**  
  `OVER`, `PARTITION BY`, `LAG`, `LEAD`, `ROW_NUMBER`.  

- **DDL e DML**  
  `CREATE`, `DROP`, `INSERT`, `DELETE`, `UPDATE`.  

# Projeto Prático

No projeto prático, desenvolvi uma tabela para entender o comportamento de clientes em diferentes janelas temporais (7, 14, 28 e 56 dias) e responder aos problemas de negócio abaixo:

1. Quantidade de transações históricas (vida, D7, D14, D28, D56);
2. Dias desde a última transação
3. Idade na base
4. Produto mais usado (vida, D7, D14, D28, D56);
5. Saldo de pontos atual;
6. Pontos acumulados positivos (vida, D7, D14, D28, D56);
7. Pontos acumulados negativos (vida, D7, D14, D28, D56);
8. Dias da semana mais ativos (D28)
9. Período do dia mais ativo (D28)
10. Engajamento em D28 versus Vida

O projetoconsolidou todo o aprendizado do curso em um cenário realista. 

```sql
CREATE TABLE tb_freature_store_cliente AS 

WITH tb_transações AS (
    SELECT IdTransacao,
            idCliente,  
            QtdePontos,
            datetime(substr(DtCriacao,1,19)) AS DtCriacao,
            julianday('now') - julianday(substr(DtCriacao,1,10)) AS DifDate,
            CAST(strftime('%H', substr(DtCriacao,1,19)) AS INTEGER) AS DtHora
    
    FROM transacoes
    WHERE DtCriacao < '2025-07-01'

    ),

tb_cliente AS (
     SELECT IdCliente,
             datetime(substr(DtCriacao,1,19)) AS DtCriacao,
             julianday('now') - julianday(substr(DtCriacao,1,10)) AS IdadeBase
    
    FROM clientes
),

tb_sumario_transações AS (
    SELECT idCliente,
    count(IdTransacao) AS QtdeTransaçõesVida,
    count(CASE WHEN DifDate <= 7 THEN IdTransacao END) AS QtdeTransações7,
    count(CASE WHEN DifDate <= 14 THEN IdTransacao END) AS QtdeTransações14,
    count(CASE WHEN DifDate <= 28 THEN IdTransacao END) AS QtdeTransações28,
    count(CASE WHEN DifDate <= 56 THEN IdTransacao END) AS QtdeTransações56,
    
    min(DifDate) AS DiasUltimaInteração,
    
    sum(qtdePontos) AS SaldoPontos,

    sum(CASE WHEN QtdePontos > 0 THEN QtdePontos ELSE 0 END) AS QtdePontosPosVida,    
    sum(CASE WHEN QtdePontos > 0 AND DifDate <= 7  THEN QtdePontos ELSE 0 END) AS QtdePontosPos7,
    sum(CASE WHEN QtdePontos > 0 AND DifDate <= 14 THEN QtdePontos ELSE 0 END) AS QtdePontosPos14,
    sum(CASE WHEN QtdePontos > 0 AND DifDate <= 28 THEN QtdePontos ELSE 0 END) AS QtdePontosPos28,
    sum(CASE WHEN QtdePontos > 0 AND DifDate <= 56 THEN QtdePontos ELSE 0 END) AS QtdePontosPos56,

    sum(CASE WHEN QtdePontos < 0 THEN QtdePontos ELSE 0 END) AS QtdePontosNegVida,  
    sum(CASE WHEN QtdePontos < 0 AND DifDate <= 7  THEN QtdePontos ELSE 0 END) AS QtdePontosNeg7,
    sum(CASE WHEN QtdePontos < 0 AND DifDate <= 14 THEN QtdePontos ELSE 0 END) AS QtdePontosNeg14,
    sum(CASE WHEN QtdePontos < 0 AND DifDate <= 28 THEN QtdePontos ELSE 0 END) AS QtdePontosNeg28,
    sum(CASE WHEN QtdePontos < 0 AND DifDate <= 56 THEN QtdePontos ELSE 0 END) AS QtdePontosNeg56

FROM tb_transações
GROUP BY idCliente
),

tb_transação_produto AS (

    SELECT t1.*,
            t3.DescNomeProduto,
            t3.DescCategoriaProduto

    FROM tb_transações AS t1
    LEFT JOIN transacao_produto AS t2
    ON t1.IdTransacao = t2.IdTransacao

    LEFT JOIN produtos AS t3
    ON t2.IdProduto = t3.IdProduto
),

tb_cliente_produto AS (

    SELECT idCliente,
            DescNomeProduto,
            count(*) AS QtdeProdVida,
            count(CASE WHEN DifDate <= 7 THEN IdTransacao END) AS QtdeProd7,
            count(CASE WHEN DifDate <= 14 THEN IdTransacao END) AS QtdeProd14,
            count(CASE WHEN DifDate <= 28 THEN IdTransacao END) AS QtdeProd28,
            count(CASE WHEN DifDate <= 56 THEN IdTransacao END) AS QtdeProd56


    FROM tb_transação_produto

    GROUP BY idCliente,
            DescNomeProduto
),

tb_cliente_produto_rn AS (

    SELECT *,
        row_number () OVER (PARTITION BY IdCliente ORDER BY QtdeProdVida DESC) AS rnvida,
        row_number () OVER (PARTITION BY IdCliente ORDER BY QtdeProd7 DESC) AS rn7,
        row_number () OVER (PARTITION BY IdCliente ORDER BY QtdeProd14 DESC) AS rn14,
        row_number () OVER (PARTITION BY IdCliente ORDER BY QtdeProd28 DESC) AS rn28,
        row_number () OVER (PARTITION BY IdCliente ORDER BY QtdeProd56 DESC) AS rn56

    FROM tb_cliente_produto
),

tb_cliente_dia AS (

    SELECT idCliente,
        strftime('%w', DtCriacao) AS DtDia,
        count(*) AS QtdeTransações

    FROM tb_transações
    WHERE DifDate <= 28
    GROUP BY IdCliente, DtDia
),  

tb_cliente_dia_rn AS (

    SELECT *,
        row_number() OVER (PARTITION BY IdCliente ORDER BY QtdeTransações DESC) AS rndia

    FROM tb_cliente_dia
),

tb_cliente_período AS (

    SELECT idCliente,
            CASE 
                WHEN DtHora BETWEEN 7 AND 12 THEN 'MANHÃ'
                WHEN DtHora BETWEEN 13 AND 18 THEN 'TARDE'
                WHEN DtHora BETWEEN 19 AND 23 THEN 'NOITE'
                ELSE 'MADRUGADA'
                END AS Período,
                count(*) AS QtdeTransações

FROM tb_transações
WHERE DifDate <= 28

GROUP BY 1,2
),

tb_cliente_rn AS (

    SELECT *,
        row_number() OVER (PARTITION BY IdCliente ORDER BY QtdeTransações DESC) AS rnperíodo

    FROM tb_cliente_período
),

tb_join AS (

    SELECT t1.*,
            t2.IdadeBase,
            t3.DescNomeProduto AS ProdVida,
            t4.DescNomeProduto AS Prod7,
            t5.DescNomeProduto AS Prod14,
            t6.DescNomeProduto AS Prod28,
            t7.DescNomeProduto AS Prod56,
           COALESCE(t8.DtDia, -1) AS DtDia,
          COALESCE(t9.período, 'SEM INFORMAÇÃO') AS PeríodoMaisAtivo28

    FROM tb_sumario_transações AS t1

    LEFT JOIN tb_cliente AS t2
    ON t1.idCliente = t2.idCliente 

    LEFT JOIN tb_cliente_produto_rn AS t3
    ON t1.idCliente = t3.idCliente
    AND t3.rnvida = 1

    LEFT JOIN tb_cliente_produto_rn AS t4
    ON t1.idCliente = t4.idCliente
    AND t4.rn7 = 1

    LEFT JOIN tb_cliente_produto_rn AS t5
    ON t1.idCliente = t5.idCliente
    AND t5.rn14 = 1

    LEFT JOIN tb_cliente_produto_rn AS t6
    ON t1.idCliente = t6.idCliente
    AND t6.rn28 = 1

    LEFT JOIN tb_cliente_produto_rn AS t7
    ON t1.idCliente = t7.idCliente
    AND t7.rn56 = 1

    LEFT JOIN tb_cliente_dia_rn AS t8
    ON t1.idCliente = t8.idCliente
    AND t8.rndia = 1

    LEFT JOIN tb_cliente_rn AS t9
    ON t1.idCliente = t9.idCliente
    AND t9.rnperíodo = 1 
)  

INSERT INTO tb_freature_store_cliente

SELECT 
        '2025-07-01' AS DataRef,
        *,
        1. * QtdeTransações28 / QtdeTransaçõesVida AS Engajamento28xVida
FROM tb_join
```

##  Como executar

1. Instale o [SQLite](https://www.sqlite.org/download.html).  
2. Clone este repositório:  
   ```bash

   git clone https://github.com/sueleensais/SQL-BasicoAoAvancado-TeoMeWhy.git
3. Abra os arquivos no VSCode
4. Execute os scripts no SQLite











