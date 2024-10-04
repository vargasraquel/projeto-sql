Projeto 2 - Exercício de Banco de Dados (Tema 2: Desmatamento PRODES)
Descrição do Projeto
Este projeto é um exercício de banco de dados realizado para um curso. O objetivo é responder a 8 perguntas sobre os dados de desmatamento do PRODES (Projeto de Monitoramento do Desmatamento na Amazônia Legal por Satélite) utilizando consultas SQL no BigQuery.

Perguntas e Respostas
Pergunta 1: Qual é a área total desmatada por bioma em um município específico?
Explicação da Consulta: Esta consulta soma a área desmatada por bioma em um município específico. Isso nos permite entender a distribuição do desmatamento entre os diferentes biomas dentro desse município.

```SELECT 
  municipio,
  bioma,
  SUM(area_km2) AS area_desmatada_total
FROM 
  `bigquery-public-data.desmatamento_prodes.municipios_biomas`
WHERE 
  municipio = 'NOVO PROGRESSO'
GROUP BY 
  municipio, bioma
ORDER BY 
  area_desmatada_total DESC;```


Pergunta 2: Qual é o bioma com a maior área desmatada em um Município específico?
Explicação da Consulta: Esta consulta identifica o bioma com a maior área desmatada em um município específico. Isso nos permite entender qual bioma está sofrendo mais com o desmatamento naquela região.

SELECT 
  municipio, 
  bioma,
  SUM(area_km2) AS area_desmatada_total
FROM 
  `bigquery-public-data.desmatamento_prodes.municipios_biomas`
WHERE 
  municipio = 'NOVO PROGRESSO'
GROUP BY 
  municipio, bioma
ORDER BY 
  area_desmatada_total DESC
LIMIT 1;

Pergunta 3: Qual foi a tendência de desmatamento ao longo dos anos em um bioma específico?
Explicação da Consulta: Esta consulta analisa a tendência de desmatamento ao longo dos anos em um bioma específico. Isso nos permite entender se o desmatamento está aumentando, diminuindo ou se mantendo estável naquele bioma.

SELECT 
  ano, 
  SUM(area_km2) AS area_desmatada_total
FROM 
  `bigquery-public-data.desmatamento_prodes.municipios_biomas`
WHERE 
  bioma = 'Amazônia'
GROUP BY 
  ano
ORDER BY 
  ano ASC;

Pergunta 4: Qual é a média de desmatamento anual por bioma?
Explicação da Consulta: Esta consulta calcula a média de desmatamento anual por bioma. Isso nos permite entender qual bioma está sofrendo mais com o desmatamento em média ao longo dos anos.

SELECT 
  bioma, 
  AVG(area_km2) AS media_desmatamento_anual
FROM 
  `bigquery-public-data.desmatamento_prodes.municipios_biomas`
GROUP BY 
  bioma
ORDER BY 
  media_desmatamento_anual DESC;

Pergunta 5: Quais municípios apresentaram aumento no desmatamento em um ano específico?
Explicação da Consulta: Esta consulta identifica os municípios que apresentaram aumento no desmatamento em um ano específico. Isso nos permite entender quais regiões estão sofrendo mais com o desmatamento naquele período.

SELECT 
  municipio, 
  ano, 
  area_km2 AS area_desmatada
FROM 
  `bigquery-public-data.desmatamento_prodes.municipios_biomas`
WHERE 
  ano = 2021
ORDER BY 
  area_desmatada DESC;

Pergunta 6: Qual bioma teve o menor desmatamento em um determinado ano?
Explicação da Consulta: Esta consulta identifica o bioma com o menor desmatamento em um ano específico. Isso nos permite entender qual bioma está sendo mais preservado naquele período.

SELECT 
  bioma, 
  SUM(area_km2) AS area_desmatada_total
FROM 
  `bigquery-public-data.desmatamento_prodes.municipios_biomas`
WHERE 
  ano = 2021
GROUP BY 
  bioma
ORDER BY 
  area_desmatada_total ASC
LIMIT 1;

Pergunta 7: Qual a distribuição do desmatamento por bioma em um gráfico?
Explicação da Consulta: Esta consulta calcula a distribuição do desmatamento por bioma, que pode ser utilizada para gerar um gráfico. Isso nos permite visualizar a proporção do desmatamento entre os diferentes biomas.

SELECT 
  bioma, 
  SUM(area_km2) AS area_desmatada_total
FROM 
  `bigquery-public-data.desmatamento_prodes.municipios_biomas`
GROUP BY 
  bioma
ORDER BY 
  area_desmatada_total DESC;

Pergunta 8: Quais municípios tiveram a maior área desmatada no último ano disponível?
Explicação da Consulta: Esta consulta identifica os municípios com a maior área desmatada no último ano disponível. Isso nos permite entender quais regiões estão sofrendo mais com o desmatamento recentemente.

``SELECT 
  municipio, 
  ano, 
  SUM(area_km2) AS area_desmatada_total
FROM 
  `bigquery-public-data.desmatamento_prodes.municipios_biomas`
WHERE 
  ano = (SELECT MAX(ano) FROM `bigquery-public-data.desmatamento_prodes.municipios_biomas`)
GROUP BY 
  municipio, ano
ORDER BY 
  area_desmatada_total DESC
LIMIT 10;``

Conclusão
Este projeto permitiu explorar os dados de desmatamento do PRODES e responder a diversas perguntas relevantes sobre a distribuição, tendências e impactos do desmatamento nos diferentes biomas e municípios. As consultas SQL realizadas fornecem insights importantes para entender melhor essa questão ambiental crucial.