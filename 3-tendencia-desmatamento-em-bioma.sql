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
