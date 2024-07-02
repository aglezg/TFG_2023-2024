// 3. Cargar CONTRATOS_SINIESTROS.xlsx

// 3.1 Eliminar nodos 'Siniestro'
MATCH (s:Siniestro) DETACH DELETE s;

// 3.2 Eliminar restricciones en nodos 'Siniestro'
DROP CONSTRAINT Siniestro_idSiniestro IF EXISTS;

// 3.3 Crear restricciones en nodos 'Siniestro'
CREATE CONSTRAINT Siniestro_idSiniestro IF NOT EXISTS
FOR (s:Siniestro)
REQUIRE s.idSiniestro IS UNIQUE;

// 3.4 Crear nodos 'Siniestro'
CALL apoc.load.xls(
    'file:///3_CONTRATOS_SINIESTROS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_SINIESTRO IS NOT NULL
MERGE (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
SET
    s.fchOcurrencia = row.FCH_OCURRENCIA,               
    s.horaOcurrencia = time(row.HORA_OCURRENCIA),   
    s.fchDeclaracion = row.FCH_DECLARACION,             
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
    s.viaPublica = row.VIA_PUBLICA,                         // Referencia a lugar [Eliminada posteriormente]
    s.numero = row.NUMERO,                                  // Referencia a lugar [Eliminada posteriormente]
    s.entidad = row.ENTIDAD,                                // Referencia a lugar [Eliminada posteriormente]
    s.municipio = row.MUNICIPIO,                            // Referencia a lugar [Eliminada posteriormente]
    s.indIndicioFraude = row.IND_INDICIO_FRAUDE,          
    s.indFraudeConfirmado = row.IND_FRAUDE_CONFIRMADO,    
    s.indAsistenciaViaje = row.IND_ASISTENCIA_VIAJE;

// 3.5 Crear relaciones (Poliza)-[:TIENE_SINIESTRO]->(Siniestro)
CALL apoc.load.xls(
    'file:///3_CONTRATOS_SINIESTROS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
MATCH (p:Poliza {idPoliza: row.ID_POLIZA})
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MERGE (p)-[:TIENE_SINIESTRO]->(s);