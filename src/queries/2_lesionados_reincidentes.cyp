/** 
 * 2. Lesionados reincidentes:
 *    Personas que han sido lesionadas en más de 1 siniestro.
 **/
MATCH (p:Persona)-[r:ES_LESIONADA_EN]->(:Siniestro)
WITH 
  p.nombre + ' ' + p.apellido1 + ' ' +  p.apellido2 as nombrePersona,
  COUNT(r) as numeroDeSiniestrosLesionado
WHERE
  numeroDeSiniestrosLesionado > 1
RETURN
  nombrePersona,
  numeroDeSiniestrosLesionado;
