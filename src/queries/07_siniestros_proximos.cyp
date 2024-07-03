/** 
 * 7. Siniestros próximos:
 *    Siniestros pertenecientes a una misma póliza con fechas de ocurrencia cercanas (30 días).
 **/
MATCH (p:Poliza)-[:TIENE_SINIESTRO]->(s:Siniestro)
MATCH (p)-[:TIENE_SINIESTRO]->(s2:Siniestro)
WHERE 
  s.idSiniestro <> s2.idSiniestro AND
  s2.fchOcurrencia - Duration({days: 30}) <= s.fchOcurrencia <= s2.fchOcurrencia + Duration({days: 30})
RETURN
  p, s, s2;