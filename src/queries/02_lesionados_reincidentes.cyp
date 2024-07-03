/** 
 * 2. Lesionados reincidentes:
 *    Personas que han sido lesionadas en más de 1 siniestro.
 **/
MATCH (p:Persona)-[:ES_LESIONADA_EN]->(s:Siniestro)
WITH 
  p.nombre + ' ' + p.apellido1 + ' ' +  p.apellido2 as nombrePersona,
  COUNT(DISTINCT s) as numeroDeSiniestrosLesionado
WHERE
  nombrePersona IS NOT NULL AND
  numeroDeSiniestrosLesionado > 1
RETURN
  nombrePersona,
  numeroDeSiniestrosLesionado
ORDER BY
  numeroDeSiniestrosLesionado DESC;