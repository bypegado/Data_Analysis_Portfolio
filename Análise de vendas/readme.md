# **Projeto: Gerenciamento de Vendas com Data Warehouse e Dashboards**

Este projecto tem como objectivo realizar a modelagem e análise de um Data Warehouse de Vendas utilizando o modelo estrela (Star Schema).
Foram criadas tabelas dimensão (Cliente, Produto, Vendedor, Tempo) e uma tabela fato (Vendas) para suportar consultas de negócio e análises estratégicas.

🛠️ Tecnologias Utilizadas:

PostgreSQL – para criação do banco e carregamento dos dados
SQL – consultas analíticas
Power BI – dashboards e relatórios interativos

📂 Estrutura do Dataset:

Dimensão Cliente → informações de clientes (nome, estado, sexo, status)
Dimensão Produto → catálogo de produtos vendidos
Dimensão Vendedor → responsáveis pelas vendas
Dimensão Tempo → datas, dias da semana, meses, anos, trimestres
Fato Vendas → registros de vendas com quantidade, valores e descontos

A arquitectura das tabelas é em estrela aonde o relacionamento das tabelas dimensões com a tabela fato é do tipo 1:N em termos de cardinalidade, a seguir podemos visualizar o diagrama:

<img width="736" height="602" alt="Image" src="https://github.com/user-attachments/assets/9733c3b1-d977-4a1a-8039-ae06817e5147" />



## Exploração de dados:
A primeira fase da análise é entender o que tem na nossa matéria prima. Vamos a exploração de dados:

**Qual a quantidade de registros de vendas temos na nossa base de dados?**

Query: SELECT count(*) as qtd_registros 
FROM dimensional.fatovendas;

<img width="175" height="75" alt="Image" src="https://github.com/user-attachments/assets/6d355753-8bca-4d6a-9247-d69725b4cf2d" />

> Resposta: 1880

**Quais são os tipos de dados?**

Query: SELECT column_name, data_type
FROM information_schema.columns
where table_schema= 'dimensional'
and table_name= 'fatovendas'

<img width="273" height="264" alt="Image" src="https://github.com/user-attachments/assets/0d313838-f3f5-47ae-a7db-9eb959007898" />

> Resposta: Podemos verificar que a tabela fatovendas possui tipo de dados: integer e numeric

Agora que ja entendemos quais são os tipos de dados, vamos olhar mais atentamente para as varíaveis que não são numéricas.

**Quais são os tipos de Status do cliente disponíveis?**
SELECT DISTINCT(status)
FROM dimensional.dimensaocliente;

<img width="239" height="138" alt="Image" src="https://github.com/user-attachments/assets/5861181b-4cca-4fcc-b496-6808bf7a2eb4" />

> Resposta: É possível verificar que os dados contam com 3 status ou categorias de clientes.

## Análise de dados a nível de Bussiness Intelligence

Uma vez que exploramos o dados e buscamos entender quais são as informações que temos no nosso banco de dados, podemos analisar as informações para buscar entender o que está acontecendo no banco de dados.

### Sobre as vendas gerais

**Qual foi o faturamento total da empresa?**

Query: SELECT sum(valortotal) as Faturamento_total 
FROM dimensional.Fatovendas;

<img width="207" height="74" alt="Image" src="https://github.com/user-attachments/assets/031525ee-3521-4705-acfb-f3f89e9cae22" />

> Resposta: Podemos verificar um faturamento total superior a 6108325.46

Qual o número total de vendas realizadas?
Query: SELECT COUNT(*) as Numerodevendas_total 
FROM dimensional.Fatovendas

<img width="244" height="73" alt="Image" src="https://github.com/user-attachments/assets/6e5a1415-f06c-41a9-87b6-71a1bb865466" />

> Resposta: Podemos verificar um número total de vendas igual a 1880

Qual o ticket médio?
Query: SELECT AVG(valortotal) as Ticket_medio
FROM dimensional.fatovendas;

<img width="176" height="74" alt="ticketmedio" src="https://github.com/user-attachments/assets/0f22da15-d4cc-46fb-a535-1246683c1536" />

> Resposta: O ticket médio é igual a: 3249.11

### Sobre os produtos
Quais são os produtos mais vendidos em quantidade?

Query: SELECT produto, COUNT(quantidade) AS quantidade
FROM dimensional.dimensaoproduto 
INNER JOIN dimensional.fatovendas
ON dimensional.dimensaoproduto.chaveproduto=dimensional.fatovendas.chaveproduto
GROUP BY dimensaoproduto.produto
order by quantidade desc
LIMIT 5;

_Data output, PostgreSQL_

<img width="559" height="194" alt="top5_maisvendidos" src="https://github.com/user-attachments/assets/03d00b13-bff4-4c55-99bb-36d52b3730e7" />

_Gráfico de colunas empilhadas, gerado no Power BI_

<img width="625" height="488" alt="Captura de ecrã 2025-08-29 085111" src="https://github.com/user-attachments/assets/1afc83dc-667d-4fa7-bdb9-dfbb493ac326" />


Quais produtos geraram o maior valor total de vendas?

Query: SELECT produto, COUNT(valortotal) as Valor_total
FROM dimensional.dimensaoproduto 
INNER JOIN dimensional.fatovendas 
ON dimensional.dimensaoproduto.chaveproduto = dimensional.fatovendas.chaveproduto
GROUP BY dimensaoproduto.produto
ORDER BY Valor_total desc
LIMIT 5;

<img width="552" height="157" alt="image" src="https://github.com/user-attachments/assets/d571458a-458f-4b9d-aa11-eb08599d9df6" />




Qual foi o produto mais vendido em cada trimestre/ano?
WITH vendas AS (
  SELECT
    t.Ano,
    t.Trimestre,
    p.Produto,
    SUM(f.Quantidade) AS total_vendido
  FROM Dimensional.FatoVendas f
  JOIN Dimensional.DimensaoTempo    t ON t.ChaveTempo    = f.ChaveTempo
  JOIN Dimensional.DimensaoProduto  p ON p.ChaveProduto  = f.ChaveProduto
  GROUP BY t.Ano, t.Trimestre, p.Produto
),
maximos AS (
  SELECT Ano, Trimestre, MAX(total_vendido) AS max_vendido
  FROM vendas
  GROUP BY Ano, Trimestre
)
SELECT v.Ano, v.Trimestre, v.Produto, v.total_vendido
FROM vendas v
JOIN maximos m
  ON m.Ano = v.Ano
 AND m.Trimestre = v.Trimestre
 AND v.total_vendido = m.max_vendido
ORDER BY v.Ano, v.Trimestre, v.Produto;





### Sobre os clientes
SELECT c.cliente, SUM(V.valortotal) as Valor
FROM dimensional.fatovendas v
INNER JOIN dimensional.dimensaocliente c ON v.chavecliente=c.chavecliente
GROUP BY c.cliente
ORDER BY c.cliente;
