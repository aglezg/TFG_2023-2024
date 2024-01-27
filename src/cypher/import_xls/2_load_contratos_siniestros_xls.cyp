// Load CONTRATOS_SINIESTROS.xlsx

// Remove nodes
MATCH (s:Siniestro) DETACH DELETE s;

// Remove constraints
DROP CONSTRAINT Siniestro_idSiniestro IF EXISTS;

// Create Poliza constraints
CREATE CONSTRAINT Poliza_idPoliza IF NOT EXISTS
FOR (p:Poliza)
REQUIRE p.idPoliza IS UNIQUE;

// Create Poliza nodes
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_POLIZA IS NOT NULL
MERGE (p:Poliza {idPoliza: row.ID_POLIZA}); //ON CREATE SET p.integerIdPoliza = CASE WHEN toInteger(row.ID_POLIZA) IS NOT NULL THEN true ELSE false END;

// Create Contrato nodes and relationship (Poliza -> Contrato)
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_POLIZA IS NOT NULL AND row.ID_CONTRATO IS NOT NULL
MATCH (p:Poliza {idPoliza: row.ID_POLIZA})
MERGE (p)-[:CONTIENE]->(c:Contrato {idContrato: row.ID_CONTRATO}); // ON CREATE SET c.integerIdContrato = CASE WHEN toInteger(row.ID_CONTRATO) IS NOT NULL THEN true ELSE false END;

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
WHERE row.ID_SINIESTRO IS NOT NULL
MERGE (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
ON CREATE SET
    s.fchOcurrencia = row.FCH_OCURRENCIA, // date(row.FCH_OCURRENCIA) error
    s.horaOcurrencia = row.HORA_OCURRENCIA, // TIME(row.HORA_OCURRENCIA)
    s.fchDeclaracion = row.FCH_DECLARACION, // date(row.FCH_DECLARACION)
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
    s.indIndicioFraude = row.IND_INDICIO_FRAUDE, // toBoolean(row.IND_INDICIO_FRAUDE)
    s.indFraudeConfirmado = row.IND_FRAUDE_CONFIRMADO, // toBoolean(row.IND_FRAUDE_CONFIRMADO)
    s.indAsistenciaViaje = row.IND_ASISTENCIA_VIAJE;

// Create relationships (Contrato -> Siniestro)
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_POLIZA IS NOT NULL AND row.ID_CONTRATO IS NOT NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (p:Poliza {idPoliza: row.ID_POLIZA})-[:CONTIENE]->(c:Contrato {idContrato: row.ID_CONTRATO})
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MERGE (c)-[:TIENE_ASOCIADO]->(s);