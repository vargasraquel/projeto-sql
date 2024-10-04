SELECT 
  bioma, 
  SUM(desmatado) AS area_total_desmatada
FROM 
  `basedosdados.br_inpe_prodes.municipio_bioma` AS dados
GROUP BY 
  bioma;
