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
MERGE (p:Poliza {idPoliza: toInteger(row.ID_POLIZA)});

// Create Contrato nodes and relationship (Poliza -> Contrato)
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_CONTRATO IS NOT NULL
MATCH (p:Poliza {idPoliza: toInteger(row.ID_POLIZA)})
MERGE (p)-[:CONTIENE]->(c:Contrato {idContrato: toInteger(row.ID_CONTRATO)});

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
MERGE (s:Siniestro {idSiniestro: toInteger(row.ID_SINIESTRO)});
SET
    fchOcurrencia = date(row.FCH_OCURRENCIA),
    horaOcurrencia = TIME(row.HORA_OCURRENCIA),
    // WITH "14:00" AS inputTimeString
    // WITH apoc.date.parse(inputTimeString, 's', 'HH:mm') AS timeValue
    // RETURN timeValue;
    fchDeclaracion = date(row.FCH_DECLARACION),
    responsabilidadCivil = row.RESPONSABILIDAD_CIVIL,
    robo = row.ROBO,
    incendio = row.INCENDIO,
    lunas = row.LUNAS,
    perdidaTotal = row.PERDIDA_TOTAL,
    danyosPropios = row.DANYOS_PROPIOS,
    defensa = row.DEFENSA,
    lesionados = row.LESIONADOS,
    indIntervieneAutoridad = row.IND_INTERVIENE_AUTORIDAD,
    indAtestado = row.IND_ATESTADO,
    indAlcoholDroga = row.IND_ALCOHOL_DROGA,
    // viaPublica = row.VIA_PUBLICA,
    // numero = row.NUMERO,
    // entidad = row.ENTIDAD,
    // municipio = row.MUNICIPIO,
    indIndicioFraude = toBoolean(row.IND_INDICIO_FRAUDE),
    indFraudeConfirmado = toBoolean(row.IND_FRAUDE_CONFIRMADO),
    indAsistenciaViaje = row.IND_ASISTENCIA_VIAJE;

// Create relationships (Contrato -> Siniestro)