/** 
 * 5. No tercería:
 *    Personas familiares intervinientes en un siniestro (comparten apellidos).
 **/
MATCH (p1:Persona)-[relacion1]->(s:Siniestro)
MATCH (p2:Persona)-[relacion2]->(s)
WITH
  s as siniestro,
  p1 as persona1,
  p1.nombre + ' ' + p1.apellido1 + ' ' + p1.apellido2 as nombrePersona1,
  type(relacion1) as tipoRelacion1,
  p2 as persona2,
  p2.nombre + ' ' + p2.apellido1 + ' ' + p2.apellido2 as nombrePersona2,
  type(relacion2) as tipoRelacion2
WHERE
  nombrePersona1 CONTAINS p2.apellido1
  AND
  nombrePersona1 CONTAINS p2.apellido2
  AND
  type(relacion1) CONTAINS 'VA'
  AND
  type(relacion2) <> 'ES_LESIONADA_EN'
  AND
  NOT(type(relacion2) CONTAINS 'VA')
RETURN
  siniestro,
  persona1,
  persona2;