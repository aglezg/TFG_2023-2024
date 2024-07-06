/** 
 * 9. Exceso de lesionados:
 *    Siniestros que cuentan con un número de lesionados mayor a 3.
 **/
MATCH (s:Siniestro)<-[:ES_LESIONADA_EN]-(p:Persona)
WITH
  s.idSiniestro AS idSiniestro,
  COUNT(DISTINCT p) as numLesionados
WHERE
  numLesionados > 3
RETURN
  idSiniestro,
  numLesionados
ORDER BY
  numLesionados DESC;