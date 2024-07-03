/** 
 * 10. Exceso de jóvenes implicados:
 *    Siniestros en los que intervienen personas jóvenes (personas de entre 18 y 30 años).
 **/
MATCH (p:Persona)-[rel]->(s:Siniestro)
WITH
  s as siniestro,
  COLLECT
  ( DISTINCT p) as personas
WHERE
  size(personas) >= 3
  AND
  ALL(persona IN personas WHERE 18 <= persona.edad <= 30)
RETURN
  siniestro,
  personas;