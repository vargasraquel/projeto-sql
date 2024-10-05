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
