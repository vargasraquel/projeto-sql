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
