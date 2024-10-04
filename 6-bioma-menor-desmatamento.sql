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
