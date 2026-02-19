# SQL - Primeiras Magias - Do Zero ao Avançado

Este repositório contém meus estudos e práticas do curso **"SQL – Primeiras Magias"**, ministrado por Téo Calvo na plataforma **TeoMeWhy** (https://www.teomewhy.org).  
Foi meu primeiro contato com bancos de dados relacionais e com a linguagem SQL, e a experiência me levou do zero até técnicas avançadas.

Durante o curso, utilizei dados reais (anonimizados) e fiz muitos exercícios práticos.

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

 O projeto foi robusto, com quase 200 linhas de código, e consolidou todo o aprendizado em um cenário realista. 

##  Como executar

1. Instale o [SQLite](https://www.sqlite.org/download.html).  
2. Clone este repositório:  
   ```bash

   git clone https://github.com/sueleensais/SQL-BasicoAoAvancado-TeoMeWhy.git
3. Abra os arquivos no VSCode
4. Execute os scripts no SQLite









