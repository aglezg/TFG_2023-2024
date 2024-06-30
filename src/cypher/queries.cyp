// Casos de uso e implementación de consultas

  /** 
   * 1. Vehiculos reincidentes:
   *    Vehiculos que tienen un siniestro con otro vehiculo en específico en más de una ocasión.
   **/
    MATCH (v1:Vehiculo)-[:INTERVIENE_COMO_ASEGURADO_EN|INTERVIENE_COMO_CONTRARIO_EN]->(s:Siniestro)<-[:INTERVIENE_COMO_ASEGURADO_EN|INTERVIENE_COMO_CONTRARIO_EN]-(v2:Vehiculo)
    WITH 
      v1.matriculaVehiculo as matriculaVehiculo1,
      v2.matriculaVehiculo as  matriculaVehiculo2,
      COUNT(s) as numeroSiniestrosImplicados
    WHERE 
      numeroSiniestrosImplicados > 1
    RETURN
      matriculaVehiculo1,
      matriculaVehiculo2,
      numeroSiniestrosImplicados;

  /** 
   * 2. Lesionados reincidentes:
   *    Personas que han sido lesionadas en más de 1 siniestro.
   **/
    MATCH (p:Persona)-[r:ES_LESIONADA_EN]->(:Siniestro)
    WITH 
      p.nombre + ' ' + p.apellido1 + ' ' +  p.apellido2 as nombreCompleto,
      COUNT(r) as numeroDeSiniestrosLesionado
    WHERE
      numeroDeSiniestrosLesionado > 1
    RETURN
      nombreCompleto,
      numeroDeSiniestrosLesionado;

  /** 
   * 3. Vehículos que participan en siniestros ocurridos en el mismo lugar:
   *    Vehiculos que intervienen en siniestros ocurridos en una misma zona más de 1 vez.
   **/
    MATCH (v:Vehiculo)-[:INTERVIENE_COMO_ASEGURADO_EN|INTERVIENE_COMO_CONTRARIO_EN]->(s:Siniestro)-[:OCURRE_EN]->(l:Lugar)
    WITH
      v.matriculaVehiculo as matriculaVehiculo,
      l.municipio as lugar,
      COUNT(l) as numeroSiniestros
    WHERE
      numeroSiniestros > 1
    RETURN
      matriculaVehiculo,
      lugar,
      numeroSiniestros;

  /** 
   * 4. Vehículos que participan en siniestros ocurridos en el mismo lugar:
   *    Vehiculos que intervienen en siniestros ocurridos en una misma zona más de 1 vez.
   **/
    MATCH (siniestro:Siniestro)<-[relacion1]-(persona1:Persona)-[relVive1:VIVE_EN]->(lugar1:Lugar)
    MATCH (s)<-[relacion2]-(persona2:Persona)-[relVive2:VIVE_EN]->(lugar2:Lugar)
    WHERE
      persona1 <> persona2 AND
      lugar1.municipio = lugar2.municipio AND
      type(relacion1) CONTAINS 'VA' AND
      type(relacion2) <> "ES_LESIONADA_EN" AND
      NOT (type(relacion2) CONTAINS 'VA') // Contemplamos ciclistas, peatones y motoristas
    RETURN
      siniestro,
      persona1,
      relacion1,
      persona2,
      relacion2,
      lugar1;
  
    /** 
     * 5. No tercería:
     *    Personas familiares intervinientes en un siniestro (comparten apellidos).
     **/
    MATCH (persona1:Persona)-[relacion1]->(siniestro:Siniestro)
    MATCH (persona2:Persona)-[relacion2]->(siniestro)
    WITH
      siniestro.idSiniestro as idSiniestro,
      persona1.nombre + ' ' + persona1.apellido1 + ' ' + persona1.apellido2 as nombreCompletoPersona1,
      type(relacion1) as nombreRelacion1,
      persona2.nombre + ' ' + persona2.apellido1 + ' ' + persona2.apellido2 as nombreCompletoPersona2,
      type(relacion2) as nombreRelacion2
    WHERE
      nombreCompletoPersona1 CONTAINS persona2.apellido1
      AND
      nombreCompletoPersona1 CONTAINS persona2.apellido2
      AND
      type(relacion1) CONTAINS 'VA'
      AND
      type(relacion2) <> 'ES_LESIONADA_EN'
      AND
      NOT(type(relacion2) CONTAINS 'VA')
    RETURN
      idSiniestro,
      nombreCompletoPersona1,
      nombreRelacion1,
      nombreCompletoPersona2,
      nombreRelacion2;

    /** 
     * 6. Reclamación tardía:
     *    Siniestros cuya fecha de declaración es mayor a 60 días en comparación con su fecha de ocurrencia.
     **/
    MATCH (s:Siniestro)
    WHERE
      s.fchOcurrencia + Duration({days: 60}) <= s.fchDeclaracion
    RETURN
      s.idSiniestro, s.fchOcurrencia, s.fchDeclaracion

    /** 
     * 7. Siniestros próximos:
     *    Siniestros pertenecientes a una misma póliza con fechas de ocurrencia cercanas (30 días).
     **/
    MATCH (p:Poliza)-[:TIENE_SINIESTRO]->(s:Siniestro)
    MATCH (p2:Poliza)-[:TIENE_SINIESTRO]->(s2:Siniestro)
    WHERE 
      p.idPoliza = p2.idPoliza AND
      s.idSiniestro <> s2.idSiniestro AND
      s2.fchOcurrencia - Duration({days: 30}) < s.fchOcurrencia < s2.fchOcurrencia + Duration({days: 30})
    RETURN
      p, p2, s, s2
  
    /** 
     * 8. Siniestros ocurridos de madrugada:
     *    Siniestros que ocurren entre las 00:00 y las 08:00 horas.
     **/
    MATCH (s:Siniestro)
    WHERE
      time("00:00") <= s.horaOcurrencia <= time("08:00")
    RETURN 
      s.idSiniestro, s.horaOcurrencia;
  
    /** 
     * 9. Exceso de lesionados:
     *    Siniestros que cuentan con un número de lesionados mayor a 3.
     **/
    MATCH (s:Siniestro)<-[:ES_LESIONADA_EN]-(p:Persona)
    WITH
      s.idSiniestro AS idSiniestro,
      COUNT(p) as numLesionados
    WHERE
      numLesionados > 3
    RETURN
      idSiniestro,
      numLesionados;

    /** 
     * 10. Exceso con jóvenes implicados:
     *    Siniestros en los que intervienen personas jóvenes (personas de entre 18 y 30 años).
     **/
    MATCH (p:Persona)-[rel]->(s:Siniestro)
    WITH
      s.idSiniestro as idSiniestro,
      COLLECT
      ( DISTINCT {
        idPersona: p.idPersona,
        nombreCompleto: p.nombre + ' ' + p.apellido1 + ' ' + p.apellido2,
        edad: p.edad
      }) as personas
    WHERE
      size(personas) > 2
      AND
      ALL(persona IN personas WHERE 18 <= persona.edad <= 30)
    RETURN
      idSiniestro,
      personas;