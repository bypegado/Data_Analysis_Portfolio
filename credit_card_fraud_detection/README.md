
# 📊 Credit Card Fraud Detection — Business Intelligence (Power BI)

## 🔎 Visão Geral
Este projecto de **Business Intelligence** tem como objectivo analisar **fraudes financeiras em transacções com cartão de crédito**, aplicando **boas práticas de modelagem dimensional**, ETL e criação de dashboards orientados à tomada de decisão.

O foco do projecto não é apenas a visualização de dados, mas sim a **estruturação correcta do modelo**, garantindo análises fiáveis, escaláveis e alinhadas ao contexto financeiro.

---

## 🎯 Objectivo do Projecto
- Identificar padrões associados a fraudes financeiras  
- Avaliar o impacto financeiro das fraudes  
- Analisar comportamentos suspeitos através de indicadores de risco  
- Criar um dashboard claro, interactivo e orientado à decisão  

---

## 📥 Origem dos Dados
Os dados utilizados neste projecto têm origem num **dataset público disponibilizado na plataforma :contentReference[oaicite:0]{index=0}**, utilizado exclusivamente para fins educacionais e de portfólio.

🔗 Fonte do dataset:  
https://www.kaggle.com/code/elgohary249/credit-card-fraud-detection-dataset

---

## 🧱 Desafio Inicial
O dataset foi disponibilizado inicialmente em **uma única tabela**, contendo múltiplas colunas operacionais e indicadores de risco, o que dificultava:
- Análises consistentes  
- Criação de métricas confiáveis  
- Escalabilidade do modelo  
- Clareza na leitura do negócio  

---

## 🛠️ Abordagem Adoptada
Foi aplicada uma abordagem baseada em **boas práticas de Business Intelligence**, que incluiu:

- Criação de uma camada de **staging**
- Transformação do dataset num **modelo dimensional (Star Schema)**
- Separação clara entre **tabela fato** e **tabelas dimensão**
- Utilização de **chaves substitutas (IDs)**
- Junções compostas para dimensões dependentes de múltiplas colunas
- Garantia de integridade referencial (sem chaves nulas)

---

## ⭐ Estrutura Final do Modelo de Dados

### 📌 Tabela Fato

#### **Fact_Transactions**
Representa cada transacção financeira.

| Coluna | Descrição |
|------|------------|
| transaction_id | Identificador da transacção |
| amount | Valor da transacção |
| velocity_last_24h | Nº de transacções nas últimas 24h |
| device_trust_score | Score de confiança do dispositivo (25–99) |
| is_fraud | Indicador de fraude (0 = legítima, 1 = fraude) |
| time_id | FK → Dim_Time |
| merchant_id | FK → Dim_Merchant |
| cardholder_id | FK → Dim_Cardholder |
| risk_flag_id | FK → Dim_Risk_Flags |
| device_trust_id | FK → Dim_Device_Trust |

---

### 📌 Tabelas Dimensão

#### ⏱️ Dim_Time
- transaction_hour (0–23)
- faixa_horaria (Madrugada, Manhã, Tarde, Noite)

#### 🏪 Dim_Merchant
- merchant_category

#### 👤 Dim_Cardholder
- cardholder_age
- faixa_etaria (Jovem, Adulto, Sénior)

#### 🚩 Dim_Risk_Flags
Dimensão criada manualmente para garantir integridade referencial.

| foreign_transaction | location_mismatch | Descrição |
|---------------------|-------------------|-----------|
| 0 | 0 | Transacção normal |
| 1 | 0 | Transacção internacional |
| 0 | 1 | Localização diferente |
| 1 | 1 | Compra internacional fora da localização habitual |

#### 🔐 Dim_Device_Trust
Classificação do nível de confiança do dispositivo.

| device_trust_id | Categoria |
|-----------------|-----------|
| 1 | Baixa confiança |
| 2 | Confiança média |
| 3 | Alta confiança |

### 📌 Diagrama - Modelo dimensional
<img width="645" height="660" alt="image" src="https://github.com/user-attachments/assets/2d54f54d-6138-4d22-8f0d-149744a15b6f" />


---

## 🔄 ETL e Transformações
As principais transformações realizadas no Power Query incluem:
- Normalização de tipos de dados  
- Criação de categorias analíticas (faixa horária, faixa etária, confiança do dispositivo)  
- Conversão de indicadores técnicos em conceitos compreensíveis para o negócio  
- Eliminação de inconsistências de modelagem  

---

## 📐 Métricas e KPIs
Foram criadas medidas DAX para responder às principais perguntas de negócio:

- Total de Transacções  
- Total de Fraudes  
- Taxa de Fraude (%)  
- Valor Perdido por Fraude  
- Ticket Médio da Fraude  
- Fraudes por tipo de risco  
- Fraudes por nível de confiança do dispositivo  
- Análise comportamental com `velocity_last_24h`

---

## 📊 Dashboard
O dashboard foi desenvolvido com foco **executivo e analítico**, priorizando:
- KPIs claros e objectivos  
- Identificação rápida de riscos  
- Visualizações orientadas à decisão  
- Comunicação simples de dados técnicos  

🔗 **Dashboard Online (Power BI):**  
https://app.powerbi.com/view?r=eyJrIjoiY2VmZDFmNWItOTNjZS00NjI2LWJjNGUtNDY4ZTMxZGM4YzczIiwidCI6IjZkNTM3YmI4LTRmZjctNDc1Yi1hMGIxLWQ5YTg0MWFhMzU2ZSIsImMiOjl9

---

## 💡 Principais Insights
- A fraude concentra-se em **combinações específicas de risco**
- Dispositivos com **baixa confiança** apresentam maior incidência de fraude
- Transacções fraudulentas apresentam **maior velocidade** nas últimas 24 horas
- Mesmo com menor volume, a fraude gera **impacto financeiro relevante**

---

## 🧠 Conclusão
Este projecto demonstra que **Business Intelligence começa na modelagem dos dados**.

A transformação de um dataset simples num **modelo dimensional robusto** permitiu análises mais consistentes, escaláveis e alinhadas ao contexto financeiro, reforçando o papel do BI como ferramenta de apoio à decisão.

---

## 🛠️ Ferramentas Utilizadas
- Power BI Desktop  
- Power BI Service  
- Power Query  
- DAX  

---

## 👤 Autor
**Dulcidónio Pegado**  
Analista de Dados | Business Intelligence  

