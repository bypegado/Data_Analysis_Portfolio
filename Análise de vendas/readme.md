# **Projecto de análise de dados - Caso de estudo Vendas**

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

<img width="239" height="138" alt="Image" src="https://github.com/user-attachments/assets/5861181b-4cca-4fcc-b496-6808bf7a2eb4" />

> Resposta: É possível verificar que os dados contam com 3 status ou categorias de clientes.

## Análise de dados a nível de Bussiness Intelligence

Uma vez que exploramos o dados e buscamos entender quais são as informações que temos no nosso banco de dados, podemos analisar as informações para buscar entender o que está acontecendo no banco de dados.

### Vendas gerais

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

