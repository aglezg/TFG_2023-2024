// Sentencias que abarcan ciertos casos relevantes

// Tests más relevantes

  // Vehiculos reincidentes: Vehiculo tiene un siniestro con otro vehiculo en más de una ocasión
    MATCH (v1:Vehiculo)-[:INTERVIENE_COMO_ASEGURADO_EN|INTERVIENE_COMO_CONTRARIO_EN]->(s:Siniestro)<-[:INTERVIENE_COMO_ASEGURADO_EN|INTERVIENE_COMO_CONTRARIO_EN]-(v2:Vehiculo)
    WITH v1.matriculaVehiculo as matriculaVehiculo1, v2.matriculaVehiculo as  matriculaVehiculo2, COUNT(s) as numeroSiniestrosImplicados
    WHERE numeroSiniestrosImplicados > 1
    RETURN matriculaVehiculo1, matriculaVehiculo2, numeroSiniestrosImplicados;

  // Lesionados reincidentes: Personas lesionadas en más de 1 siniestro
    MATCH (p:Persona)-[r:ES_LESIONADA_EN]->(:Siniestro)
    WITH p.nombre + ' ' + p.apellido1 + ' ' +  p.apellido2 as nombreCompleto, COUNT(r) as numeroDeSiniestrosLesionado
    WHERE numeroDeSiniestrosLesionado > 1
    RETURN nombreCompleto, numeroDeSiniestrosLesionado;

// Siniestro nodes

  // Reclamación tardía: Siniestros cuya fecha de declaración es mayor a 60 días en comparación a su fecha de ocurrencia
    MATCH (s:Siniestro)
    WHERE s.fchOcurrencia + Duration({days: 60}) <= s.fchDe claracion
    RETURN s.idSiniestro, s.fchOcurrencia, s.fchDeclaracion
  // Siniestros con igual fecha de ocurrencia dentro de una misma póliza
    MATCH (p:Poliza)-[:TIENE_SINIESTRO]->(s:Siniestro)
    MATCH (p2:Poliza)-[:TIENE_SINIESTRO]->(s2:Siniestro)
    WHERE p.idPoliza =  p2.idPoliza AND s.idSiniestro <> s2.idSiniestro AND s.fchOcurrencia = s2.fchOcurrencia
    RETURN p, p2, s, s2
  // Siniestros próximos: Siniestros pertenecientes a una misma póliza con fechas de ocurrencia cercanas (30 días)
    MATCH (p:Poliza)-[:TIENE_SINIESTRO]->(s:Siniestro)
    MATCH (p2:Poliza)-[:TIENE_SINIESTRO]->(s2:Siniestro)
    WHERE p.idPoliza = p2.idPoliza AND s.idSiniestro <> s2.idSiniestro
      AND s2.fchOcu rrencia - Duration({days: 30}) < s.fchOcurrencia < s2.fchOcurrencia + Duration({days: 30})
    RETURN p, p2, s, s2
  // Siniestros que ocurren de madrugada
    MATCH (s:Siniestro)
    WHERE time("00:00") <= s.horaOcurrencia <= time("08:00")
    RETURN s.idSiniestro, s.horaOcurrencia;