/** 
 * 1. Vehiculos reincidentes:
 *    Vehiculos que tienen un siniestro con otro vehiculo en específico en más de una ocasión.
 **/
MATCH (v1:Vehiculo)-[:INTERVIENE_COMO_ASEGURADO_EN|INTERVIENE_COMO_CONTRARIO_EN]->(s:Siniestro)<-[INTERVIENE_COMO_CONTRARIO_EN]-(v2:Vehiculo)
WITH 
  CASE WHEN v1.matriculaVehiculo < v2.matriculaVehiculo 
       THEN [v1.matriculaVehiculo, v2.matriculaVehiculo] 
       ELSE [v2.matriculaVehiculo, v1.matriculaVehiculo] 
  END as vehiculosOrdenados, 
  COUNT(s) as numeroSiniestros
WHERE numeroSiniestros > 1
RETURN 
  vehiculosOrdenados as matriculasVehiculosImplicados, 
  numeroSiniestros
ORDER BY numeroSiniestros;
