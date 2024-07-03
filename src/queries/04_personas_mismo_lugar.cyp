/** 
 * 4. Personas partícipes de un siniestro residentes en la misma localidad:
 *    Personas intervinientes en un siniestro y aparentemente desconocidos entre si que viven en el mismo lugar.
 **/
MATCH (s:Siniestro)<-[rel1]-(p1:Persona)-[:VIVE_EN]->(l:Lugar)
MATCH (s)<-[rel2]-(p2:Persona)-[:VIVE_EN]->(l)
WHERE
  p1 <> p2 AND
  type(rel1) CONTAINS 'VA' AND
  type(rel2) <> "ES_LESIONADA_EN" AND
  NOT (type(rel2) CONTAINS 'VA') // Contemplamos ciclistas, peatones y motoristas
RETURN
  s,
  p1,
  p2,
  l;