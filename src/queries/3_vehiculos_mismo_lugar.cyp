/** 
 * 3. Vehículos que participan en siniestros ocurridos en el mismo lugar:
 *    Vehiculos que intervienen en siniestros ocurridos en una misma zona más de 1 vez.
 **/
MATCH (v:Vehiculo)-[:INTERVIENE_COMO_ASEGURADO_EN|INTERVIENE_COMO_CONTRARIO_EN]->(s:Siniestro)-[:OCURRE_EN]->(l:Lugar)
WITH
  v.matriculaVehiculo as matriculaVehiculo,
  l.municipio as lugar,
  COUNT(DISTINCT s) as numeroSiniestros
WHERE
  numeroSiniestros > 1
RETURN
  matriculaVehiculo,
  lugar,
  numeroSiniestros
ORDER BY
  numeroSiniestros DESC;