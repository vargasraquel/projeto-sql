SELECT 
  bioma, 
  AVG(desmatado) AS media_anual_desmatamento
FROM 
  `basedosdados.br_inpe_prodes.municipio_bioma` AS dados
GROUP BY 
  bioma;
