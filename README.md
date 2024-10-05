# Projeto 2 - Exercício de Banco de Dados (Tema 2: Desmatamento PRODES)
## Descrição do Projeto
Este projeto é um exercício de banco de dados realizado para um curso. O objetivo é responder a 8 perguntas sobre os dados de desmatamento do [PRODES (Projeto de Monitoramento do Desmatamento na Amazônia Legal por Satélite)](https://basedosdados.org/dataset/e5c87240-ecce-4856-97c5-e6b84984bf42?table=d7a76d45-c363-4494-826d-1580e997ebf0) utilizando consultas SQL no BigQuery.

## Perguntas e Respostas
### Pergunta 1: Qual é a área total desmatada por bioma em um município específico?
Explicação da Consulta: Esta consulta soma a área desmatada por bioma em um município específico. Isso nos permite entender a distribuição do desmatamento entre os diferentes biomas dentro desse município.

<details>
  <summary>Clique para ver a resposta</summary>

```
SELECT 
  bioma, 
  SUM(desmatado) AS area_total_desmatada
FROM 
  `basedosdados.br_inpe_prodes.municipio_bioma` AS dados
LEFT JOIN 
  (SELECT DISTINCT id_municipio, nome FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio
ON 
  dados.id_municipio = diretorio_id_municipio.id_municipio
WHERE 
  diretorio_id_municipio.nome = 'Dois Irmãos do Tocantins'
GROUP BY 
  bioma;
  ```

### Resultado
| bioma    | area_total_desmatada |
|----------|----------------------|
| Amazônia | 1406.9               |
| Cerrado  | 22800.8              |
</details>

### Pergunta 2: Qual é o bioma com a maior área desmatada em um Município específico?
Explicação da Consulta: Esta consulta identifica o bioma com a maior área desmatada em um município específico. Isso nos permite entender qual bioma está sofrendo mais com o desmatamento naquela região.

<details>
  <summary>Clique para ver a resposta</summary>

```
SELECT 
  bioma, 
  SUM(desmatado) AS area_total_desmatada
FROM 
  `basedosdados.br_inpe_prodes.municipio_bioma` AS dados
LEFT JOIN 
  (SELECT DISTINCT id_municipio, nome FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio
ON 
  dados.id_municipio = diretorio_id_municipio.id_municipio
WHERE 
  diretorio_id_municipio.nome = 'Dois Irmãos do Tocantins'
GROUP BY 
  bioma
ORDER BY 
  area_total_desmatada DESC
LIMIT 1;
```

### Resultado
| bioma   | area_total_desmatada |
|---------|----------------------|
| Cerrado | 22800.8              |
</details>

### Pergunta 3: Qual foi a tendência de desmatamento ao longo dos anos em um bioma específico?
Explicação da Consulta: Esta consulta analisa a tendência de desmatamento ao longo dos anos em um bioma específico. Isso nos permite entender se o desmatamento está aumentando, diminuindo ou se mantendo estável naquele bioma.

<details>
  <summary>Clique para ver a resposta</summary>

```
SELECT 
  ano, 
  SUM(desmatado) AS area_total_desmatada
FROM 
  `basedosdados.br_inpe_prodes.municipio_bioma` AS dados
WHERE 
  bioma = 'Amazônia'
GROUP BY 
  ano
ORDER BY 
  ano ASC;
  ```

### Resultado
| ano  | area_total_desmatada |
|------|----------------------|
| 2000 | 472973.59999999951   |
| 2001 | 524849.40000000014   |
| 2002 | 548204.10000000044   |
| 2003 | 575441.39999999944   |
| 2004 | 600123.90000000026   |
| 2005 | 621228.79999999993   |
| 2006 | 630948.600000001     |
| 2007 | 641199.90000000037   |
| 2008 | 653647.90000000026   |
| 2009 | 659549.70000000054   |
| 2010 | 665395.70000000065   |
| 2011 | 670797.80000000109   |
| 2012 | 674926.60000000068   |
| 2013 | 680080.40000000037   |
| 2014 | 684952.90000000049   |
| 2015 | 690864.40000000037   |
| 2016 | 697944.10000000044   |
| 2017 | 704701.50000000058   |
| 2018 | 711660.60000000021   |
| 2019 | 722363.99999999977   |
| 2020 | 732720.70000000077   |
| 2021 | 744913.600000001     |
| 2022 | 757394.79999999993   |
</details>

### Pergunta 4: Qual é a média de desmatamento anual por bioma?
Explicação da Consulta: Esta consulta calcula a média de desmatamento anual por bioma. Isso nos permite entender qual bioma está sofrendo mais com o desmatamento em média ao longo dos anos.

<details>
  <summary>Clique para ver a resposta</summary>

```
SELECT 
  bioma, 
  AVG(desmatado) AS media_anual_desmatamento
FROM 
  `basedosdados.br_inpe_prodes.municipio_bioma` AS dados
GROUP BY 
  bioma;
```

### Resultado
| bioma          | media_anual_desmatamento |
|----------------|--------------------------|
| Amazônia       | 1171.8818075756371       |
| Cerrado        | 622.5921023089295        |
| Caatinga       | 271.30349192649408       |
| Mata Atlântica | 249.49762371490257       |
| Pampa          | 433.84716446124781       |
| Pantanal       | 1033.3456521739131       |
</details>

### Pergunta 5: Quais municípios apresentaram aumento no desmatamento em um ano específico?
Explicação da Consulta: Esta consulta identifica os municípios que apresentaram aumento no desmatamento em um ano específico. Isso nos permite entender quais regiões estão sofrendo mais com o desmatamento naquele período.

<details>
  <summary>Clique para ver a resposta</summary>

```
WITH desmatamento_anterior AS (
  SELECT 
    dados.id_municipio, 
    diretorio_id_municipio.nome AS id_municipio_nome, 
    bioma, 
    desmatado, 
    ano, 
    LAG(desmatado) OVER (PARTITION BY dados.id_municipio, bioma ORDER BY ano) AS desmatamento_ano_anterior
  FROM 
    `basedosdados.br_inpe_prodes.municipio_bioma` AS dados
  LEFT JOIN 
    (SELECT DISTINCT id_municipio, nome FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio
  ON 
    dados.id_municipio = diretorio_id_municipio.id_municipio
)
SELECT 
  id_municipio, 
  id_municipio_nome, 
  bioma, 
  ano, 
  desmatado
FROM 
  desmatamento_anterior
WHERE 
  ano = 2022
  AND desmatado > desmatamento_ano_anterior
ORDER BY
  desmatado DESC
LIMIT 10;
```

### Resultado
| id_municipio | id_municipio_nome    | bioma    | ano  | desmatado |
|--------------|----------------------|----------|------|-----------|
| 5007109      | Ribas do Rio Pardo   | Cerrado  | 2022 | 14083.5   |
| 1100205      | Porto Velho          | Amazônia | 2022 | 12174.6   |
| 1500602      | Altamira             | Amazônia | 2022 | 11925.2   |
| 1504208      | Marabá               | Amazônia | 2022 | 8957.6    |
| 1505502      | Paragominas          | Amazônia | 2022 | 8908.0    |
| 1505064      | Novo Repartimento    | Amazônia | 2022 | 8711.2    |
| 2928901      | São Desidério        | Cerrado  | 2022 | 8583.9    |
| 5105101      | Juara                | Amazônia | 2022 | 8372.7    |
| 5008305      | Três Lagoas          | Cerrado  | 2022 | 8096.6    |
| 2911105      | Formosa do Rio Preto | Cerrado  | 2022 | 7944.5    |
</details>

### Pergunta 6: Qual bioma teve o menor desmatamento em um determinado ano?
Explicação da Consulta: Esta consulta identifica o bioma com o menor desmatamento em um ano específico. Isso nos permite entender qual bioma está sendo mais preservado naquele período.

<details>
  <summary>Clique para ver a resposta</summary>

```
SELECT 
  bioma, 
  SUM(desmatado) AS area_total_desmatada
FROM 
  `basedosdados.br_inpe_prodes.municipio_bioma` AS dados
WHERE 
  ano = 2022
GROUP BY 
  bioma
ORDER BY 
  area_total_desmatada ASC
LIMIT 1;
```

### Resultado
| bioma    | area_total_desmatada |
|----------|----------------------|
| Pantanal | 29668.499999999996   |
</details>

### Pergunta 7: Qual a distribuição do desmatamento por bioma em um gráfico?
Explicação da Consulta: Esta consulta calcula a distribuição do desmatamento por bioma, que pode ser utilizada para gerar um gráfico. Isso nos permite visualizar a proporção do desmatamento entre os diferentes biomas.

<details>
  <summary>Clique para ver a resposta</summary>

```
SELECT 
  bioma, 
  SUM(desmatado) AS area_total_desmatada
FROM 
  `basedosdados.br_inpe_prodes.municipio_bioma` AS dados
GROUP BY 
  bioma;
```

### Resultado
| bioma          | area_total_desmatada |
|----------------|----------------------|
| Amazônia       | 15066884.40000019    |
| Cerrado        | 20520013.09999999    |
| Caatinga       | 7544136.200000017    |
| Mata Atlântica | 17691627.000000063   |
| Pampa          | 2295051.4999999939   |
| Pantanal       | 522872.8999999995    |

</details>

### Pergunta 8: Quais municípios tiveram a maior área desmatada no último ano disponível?
Explicação da Consulta: Esta consulta identifica os municípios com a maior área desmatada no último ano disponível. Isso nos permite entender quais regiões estão sofrendo mais com o desmatamento recentemente.

<details>
  <summary>Clique para ver a resposta</summary>

```
WITH ultimo_ano AS (
  SELECT 
    MAX(ano) AS ultimo_ano
  FROM 
    `basedosdados.br_inpe_prodes.municipio_bioma`
)
SELECT 
  diretorio_id_municipio.nome AS id_municipio_nome, 
  dados.id_municipio, 
  SUM(dados.desmatado) AS area_total_desmatada
FROM 
  `basedosdados.br_inpe_prodes.municipio_bioma` AS dados
LEFT JOIN 
  (SELECT DISTINCT id_municipio, nome FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio
ON 
  dados.id_municipio = diretorio_id_municipio.id_municipio, ultimo_ano
WHERE 
  dados.ano = ultimo_ano.ultimo_ano
GROUP BY 
  id_municipio, id_municipio_nome
ORDER BY 
  area_total_desmatada DESC
LIMIT 10;
```

### Resultado
| id_municipio_nome  | id_municipio | area_total_desmatada |
|--------------------|--------------|----------------------|
| Ribas do Rio Pardo | 5007109      | 14083.5              |
| Porto Velho        | 1100205      | 12174.6              |
| Altamira           | 1500602      | 11925.2              |
| Paranatinga        | 5106307      | 9455.5               |
| Marabá             | 1504208      | 8957.6               |
| Paragominas        | 1505502      | 8908.0               |
| Novo Repartimento  | 1505064      | 8711.2               |
| São Desidério      | 2928901      | 8583.9               |
| Juara              | 5105101      | 8372.7               |
| Três Lagoas        | 5008305      | 8360.8000000000011   |
</details>

## Conclusão
Este projeto permitiu explorar os dados de desmatamento do PRODES e responder a diversas perguntas relevantes sobre a distribuição, tendências e impactos do desmatamento nos diferentes biomas e municípios. As consultas SQL realizadas fornecem insights importantes para entender melhor essa questão ambiental crucial.