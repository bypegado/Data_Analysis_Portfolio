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

Query: `SELECT count(*) as qtd_registros 
FROM dimensional.fatovendas;`

_Resultado_

<img width="175" height="75" alt="Image" src="https://github.com/user-attachments/assets/6d355753-8bca-4d6a-9247-d69725b4cf2d" />


**Quais são os tipos de dados?**

Query: `SELECT column_name, data_type
FROM information_schema.columns
where table_schema= 'dimensional'
and table_name= 'fatovendas';`

_Resultado_

<img width="273" height="264" alt="Image" src="https://github.com/user-attachments/assets/0d313838-f3f5-47ae-a7db-9eb959007898" />

Agora que ja entendemos quais são os tipos de dados, vamos olhar mais atentamente para as varíaveis que não são numéricas.

**Quais são os tipos de Status do cliente disponíveis?**

Query: `SELECT DISTINCT(status)
FROM dimensional.dimensaocliente;`

_Resultado_

<img width="239" height="138" alt="Image" src="https://github.com/user-attachments/assets/5861181b-4cca-4fcc-b496-6808bf7a2eb4" />

> Resposta: É possível verificar que os dados contam com 3 status ou categorias de clientes.

## Análise de dados a nível de Bussiness Intelligence

Uma vez que exploramos o dados e buscamos entender quais são as informações que temos no nosso banco de dados, podemos analisar as informações para buscar entender o que está acontecendo no banco de dados.

### Sobre as vendas gerais

**Qual foi o faturamento total da empresa?**

Query: `SELECT sum(valortotal) as Faturamento_total 
FROM dimensional.Fatovendas;`

_Resultado_

<img width="207" height="74" alt="Image" src="https://github.com/user-attachments/assets/031525ee-3521-4705-acfb-f3f89e9cae22" />

> Resposta: Podemos verificar um faturamento total superior a 6108325.46

**Qual o número total de vendas realizadas?**

Query: `SELECT COUNT(*) as Numerodevendas_total 
FROM dimensional.Fatovendas;`

_Resultado_

<img width="244" height="73" alt="Image" src="https://github.com/user-attachments/assets/6e5a1415-f06c-41a9-87b6-71a1bb865466" />

> Resposta: Podemos verificar um número total de vendas igual a 1880

Qual o ticket médio?

Query: `SELECT AVG(valortotal) as Ticket_medio
FROM dimensional.fatovendas;`

_Resultado_

<img width="176" height="74" alt="ticketmedio" src="https://github.com/user-attachments/assets/0f22da15-d4cc-46fb-a535-1246683c1536" />

> Resposta: O ticket médio é igual a: 3249.11

### Sobre os produtos

**Quais são os produtos mais vendidos em quantidade?**

Query: `SELECT produto, COUNT(quantidade) AS quantidade
FROM dimensional.dimensaoproduto 
INNER JOIN dimensional.fatovendas
ON dimensional.dimensaoproduto.chaveproduto=dimensional.fatovendas.chaveproduto
GROUP BY dimensaoproduto.produto
order by quantidade desc
LIMIT 5;`

_Resultado_

<img width="559" height="194" alt="top5_maisvendidos" src="https://github.com/user-attachments/assets/03d00b13-bff4-4c55-99bb-36d52b3730e7" />

_Gráfico de colunas empilhadas, gerado no Power BI_

<img width="625" height="488" alt="Captura de ecrã 2025-08-29 085111" src="https://github.com/user-attachments/assets/1afc83dc-667d-4fa7-bdb9-dfbb493ac326" />


**Quais produtos geraram o maior valor total de vendas?**

Query: `SELECT produto, COUNT(valortotal) as Valor_total
FROM dimensional.dimensaoproduto 
INNER JOIN dimensional.fatovendas 
ON dimensional.dimensaoproduto.chaveproduto = dimensional.fatovendas.chaveproduto
GROUP BY dimensaoproduto.produto
ORDER BY Valor_total desc
LIMIT 5;`

_Resultado_

<img width="552" height="157" alt="image" src="https://github.com/user-attachments/assets/d571458a-458f-4b9d-aa11-eb08599d9df6" />


**Qual foi o produto mais vendido em cada trimestre/ano?**

Query: `WITH vendas AS (
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
ORDER BY v.Ano, v.Trimestre, v.Produto;`

_Resultado_

<img width="556" height="161" alt="image" src="https://github.com/user-attachments/assets/95e64128-ddf2-465d-9a17-87858d432f94" />


### Sobre os clientes

**Quem são os clientes que mais compraram em valor?**

Query: `SELECT c.cliente, SUM(V.valortotal) as Valor
FROM dimensional.fatovendas v
INNER JOIN dimensional.dimensaocliente c ON v.chavecliente=c.chavecliente
GROUP BY c.cliente
ORDER BY c.cliente;`

**Qual a província/estado com maior volume de vendas?**

Query: `SELECT p.estado, SUM(V.quantidade) as Volume
FROM dimensional.fatovendas V
INNER JOIN dimensional.dimensaocliente p ON p.chavecliente=V.chaveproduto
GROUP BY p.estado
LIMIT 1;`

_Resultado_

<img width="248" height="61" alt="image" src="https://github.com/user-attachments/assets/958f2bfa-b9a6-4cce-8d55-1b95eb5798da" />


**Qual o perfil de clientes que mais compra?**

Query: `SELECT p.status, SUM(V.quantidade) as Volume
FROM dimensional.fatovendas V
INNER JOIN dimensional.dimensaocliente p ON p.chavecliente=V.chaveproduto
GROUP BY p.status
ORDER BY Volume DESC;`

_Resultado_

<img width="250" height="109" alt="image" src="https://github.com/user-attachments/assets/a595f8cf-494c-4e69-902a-5eb8fb4b0f6c" />


**Qual vendedor teve o maior valor de vendas?**

Query: `SELECT n.nome, SUM(v.valortotal) as Valor
FROM dimensional.fatovendas v
INNER JOIN dimensional.dimensaovendedor n ON n.chavevendedor=v.chavevendedor
GROUP BY n.nome
ORDER BY Valor DESC
LIMIT 1;`

_Resultado_

<img width="264" height="61" alt="image" src="https://github.com/user-attachments/assets/26599a83-d8f5-437b-bcd0-6c25f0041ea3" />


**Quem vendeu mais unidades?**

Query: `SELECT p.nome, SUM(V.quantidade) as Volume
FROM dimensional.fatovendas V
INNER JOIN dimensional.dimensaovendedor p ON p.chavevendedor=V.chaveproduto
GROUP BY p.nome
ORDER BY Volume DESC
LIMIT 1;`

_Resultado_

<img width="248" height="58" alt="image" src="https://github.com/user-attachments/assets/f9532805-3ddd-4ab1-b8f8-6c139de26b66" />


**Qual vendedor aplicou mais descontos?**

Query: `SELECT n.nome, COUNT(v.desconto) as total_desconto
FROM dimensional.fatovendas v
INNER JOIN dimensional.dimensaovendedor n ON n.chavevendedor=v.chavevendedor
GROUP BY n.nome
ORDER BY total_desconto DESC
LIMIT 1;`

_Resultado_

<img width="302" height="58" alt="image" src="https://github.com/user-attachments/assets/945cde66-b308-4ff0-9829-4557970ad456" />

### Sobre o tempo


**Qual o mês e o trimestre com maior faturamento?**

<img width="274" height="63" alt="image" src="https://github.com/user-attachments/assets/85d7e9d8-daa9-4218-b7d9-b439106075f8" />


>Mês e ano com maior faturamento

Query: `SELECT 
    t.Ano,
    t.Mes,
    SUM(f.ValorTotal) AS Faturamento
FROM Dimensional.FatoVendas f
JOIN Dimensional.DimensaoTempo t 
    ON f.ChaveTempo = t.ChaveTempo
GROUP BY t.Ano, t.Mes
ORDER BY Faturamento DESC
LIMIT 1;`

_Resultado_

<img width="285" height="332" alt="image" src="https://github.com/user-attachments/assets/4a8377f7-2e33-460b-a532-995e12a60e14" />

>Trimestre e ano com maior faturamento

Query: `SELECT 
    t.Ano,
    t.Trimestre,
    SUM(f.ValorTotal) AS Faturamento
FROM Dimensional.FatoVendas f
JOIN Dimensional.DimensaoTempo t 
    ON f.ChaveTempo = t.ChaveTempo
GROUP BY t.Ano, t.Trimestre
ORDER BY Faturamento DESC
LIMIT 1;`

_Resultado_

<img width="285" height="58" alt="image" src="https://github.com/user-attachments/assets/4c881fb8-2533-4659-b183-b803154f55d0" />

**Como se comportam as vendas por dia da semana?**

Query: `SELECT CASE
WHEN t.DiaSemana=  0 THEN 'Domingo'
WHEN t.DiaSemana = 1 THEN 'Segunda-Feira'
WHEN t.DiaSemana =2 THEN 'Terça-Feira'
WHEN t.DiaSemana = 3 THEN 'Quarta-Feira'
WHEN t.DiaSemana = 4 THEN 'Quinta-Feira'
WHEN t.DiaSemana = 5 THEN 'Sexta-Feira'
else 'Sabado'
end as Dianasemana
, SUM(f.ValorTotal) AS TotalVendas
FROM Dimensional.FatoVendas f
JOIN Dimensional.DimensaoTempo t ON f.ChaveTempo = t.ChaveTempo
GROUP BY t.DiaSemana
ORDER BY t.Diasemana;`

_Resultado_

<img width="237" height="216" alt="image" src="https://github.com/user-attachments/assets/50b5d371-e721-4b9a-b06f-224af8a992ac" />


## Conclusão

Este projeto demonstrou como a modelagem dimensional (Star Schema) e a integração entre SQL, PostgreSQL e Power BI podem transformar dados brutos em informações estratégicas para o negócio. 

A partir da criação das tabelas fato e dimensão, foi possível realizar análises que responderam a questões críticas, como identificar os produtos mais vendidos, os clientes mais valiosos, os períodos de maior faturamento e o desempenho dos vendedores. 

Além disso, os dashboards em Power BI proporcionaram uma visão visual e interativa que facilita a tomada de decisões gerenciais.

Com isso, o projeto não só valida a importância do Data Warehouse no suporte à inteligência de negócios, mas também reforça a aplicabilidade prática de ferramentas de análise de dados no contexto empresarial.







