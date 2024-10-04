# Projeto 2 - Exercício de Banco de Dados (Tema 2: Desmatamento PRODES)
## Descrição do Projeto
Este projeto é um exercício de banco de dados realizado para um curso. O objetivo é responder a 8 perguntas sobre os dados de desmatamento do PRODES (Projeto de Monitoramento do Desmatamento na Amazônia Legal por Satélite) utilizando consultas SQL no BigQuery.

## Perguntas e Respostas
Pergunta 1: Qual é a área total desmatada por bioma em um município específico?
Explicação da Consulta: Esta consulta soma a área desmatada por bioma em um município específico. Isso nos permite entender a distribuição do desmatamento entre os diferentes biomas dentro desse município.

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

Pergunta 2: Qual é o bioma com a maior área desmatada em um Município específico?
Explicação da Consulta: Esta consulta identifica o bioma com a maior área desmatada em um município específico. Isso nos permite entender qual bioma está sofrendo mais com o desmatamento naquela região.

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

Pergunta 3: Qual foi a tendência de desmatamento ao longo dos anos em um bioma específico?
Explicação da Consulta: Esta consulta analisa a tendência de desmatamento ao longo dos anos em um bioma específico. Isso nos permite entender se o desmatamento está aumentando, diminuindo ou se mantendo estável naquele bioma.

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

Pergunta 4: Qual é a média de desmatamento anual por bioma?
Explicação da Consulta: Esta consulta calcula a média de desmatamento anual por bioma. Isso nos permite entender qual bioma está sofrendo mais com o desmatamento em média ao longo dos anos.

```
SELECT 
SELECT 
  bioma, 
  AVG(desmatado) AS media_anual_desmatamento
FROM 
  `basedosdados.br_inpe_prodes.municipio_bioma` AS dados
GROUP BY 
  bioma;
```

### Resultado

Pergunta 5: Quais municípios apresentaram aumento no desmatamento em um ano específico?
Explicação da Consulta: Esta consulta identifica os municípios que apresentaram aumento no desmatamento em um ano específico. Isso nos permite entender quais regiões estão sofrendo mais com o desmatamento naquele período.

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
  AND desmatado > desmatamento_ano_anterior;
ORDER BY
  desmatado DESC;
```

### Resultado

Pergunta 6: Qual bioma teve o menor desmatamento em um determinado ano?
Explicação da Consulta: Esta consulta identifica o bioma com o menor desmatamento em um ano específico. Isso nos permite entender qual bioma está sendo mais preservado naquele período.

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

Pergunta 7: Qual a distribuição do desmatamento por bioma em um gráfico?
Explicação da Consulta: Esta consulta calcula a distribuição do desmatamento por bioma, que pode ser utilizada para gerar um gráfico. Isso nos permite visualizar a proporção do desmatamento entre os diferentes biomas.

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

Pergunta 8: Quais municípios tiveram a maior área desmatada no último ano disponível?
Explicação da Consulta: Esta consulta identifica os municípios com a maior área desmatada no último ano disponível. Isso nos permite entender quais regiões estão sofrendo mais com o desmatamento recentemente.

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
| id_municipio_nome	| id_municipio	| area_total_desmatada |
|---|---|---|
| Santa Cruz do Arari	| 1506401	| 0.0 |
| Madre de Deus |	2919926 |	2.3 |
| Águas de São Pedro |	3500600 |	2.4 |
| Santa Cruz de Minas |	3157336 |	2.4 |
| Fernando de Noronha |	2605459 |	3.0 |
| Guaramiranga |	2305100 |	3.1 |
| Ilha Grande |	2204659 |	5.5 |
| Raposos |	3153905 |	7.3 |
| Rio Grande da Serra |	3544103 |	9.6 |
| Senador Georgino Avelino | 2413201 | 10.9 |

Conclusão
Este projeto permitiu explorar os dados de desmatamento do PRODES e responder a diversas perguntas relevantes sobre a distribuição, tendências e impactos do desmatamento nos diferentes biomas e municípios. As consultas SQL realizadas fornecem insights importantes para entender melhor essa questão ambiental crucial.