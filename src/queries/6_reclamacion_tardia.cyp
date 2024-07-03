/** 
 * 6. Reclamación tardía:
 *    Siniestros cuya fecha de declaración es mayor a 60 días en comparación con su fecha de ocurrencia.
 **/
MATCH (s:Siniestro)
WHERE
  s.fchOcurrencia + Duration({days: 60}) < s.fchDeclaracion
RETURN
  s.idSiniestro, s.fchOcurrencia, s.fchDeclaracion;