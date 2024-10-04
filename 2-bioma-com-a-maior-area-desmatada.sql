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
