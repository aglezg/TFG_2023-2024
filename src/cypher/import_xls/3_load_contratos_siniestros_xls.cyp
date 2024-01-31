// Load CONTRATOS_SINIESTROS.xlsx

// Remove nodes
MATCH (s:Siniestro) DETACH DELETE s;

// Remove constraints
DROP CONSTRAINT Siniestro_idSiniestro IF EXISTS;

// Create Siniestro constraints
CREATE CONSTRAINT Siniestro_idSiniestro IF NOT EXISTS
FOR (s:Siniestro)
REQUIRE s.idSiniestro IS UNIQUE;

// Create Siniestro nodes
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_SINIESTRO IS NOT NULL                  // Error: Hay siniestros nulos
MERGE (s:Siniestro {idSiniestro: row.ID_SINIESTRO}) // toInteger(row.ID_SINIESTRO)
ON CREATE SET
    s.fchOcurrencia = row.FCH_OCURRENCIA,               // date(row.FCH_OCURRENCIA) error
    s.horaOcurrencia = row.HORA_OCURRENCIA,             // TIME(row.HORA_OCURRENCIA)
    s.fchDeclaracion = row.FCH_DECLARACION,             // date(row.FCH_DECLARACION)
    s.responsabilidadCivil = row.RESPONSABILIDAD_CIVIL,
    s.robo = row.ROBO,
    s.incendio = row.INCENDIO,
    s.lunas = row.LUNAS,
    s.perdidaTotal = row.PERDIDA_TOTAL,
    s.danyosPropios = row.DANYOS_PROPIOS,
    s.defensa = row.DEFENSA,
    s.lesionados = row.LESIONADOS,
    s.indIntervieneAutoridad = row.IND_INTERVIENE_AUTORIDAD,
    s.indAtestado = row.IND_ATESTADO,
    s.indAlcoholDroga = row.IND_ALCOHOL_DROGA,
    // viaPublica = row.VIA_PUBLICA,
    // numero = row.NUMERO,
    // entidad = row.ENTIDAD,
    // municipio = row.MUNICIPIO,
    s.indIndicioFraude = row.IND_INDICIO_FRAUDE,        // toBoolean(row.IND_INDICIO_FRAUDE)
    s.indFraudeConfirmado = row.IND_FRAUDE_CONFIRMADO,  // toBoolean(row.IND_FRAUDE_CONFIRMADO)
    s.indAsistenciaViaje = row.IND_ASISTENCIA_VIAJE;

// Create relationships (Poliza -> Siniestro)
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
MATCH (p:Poliza {idPoliza: row.ID_POLIZA})          // toInteger(row.ID_POLIZA)
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO}) // toInteger(row.ID_SINIESTRO)
MERGE (p)-[:TIENE_SINIESTRO]->(s);