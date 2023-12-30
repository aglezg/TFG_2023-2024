// Load CONTRATOS.xlsx

// Remove nodes
MATCH (p:Poliza) DETACH DELETE p;
MATCH (c:Contrato) DETACH DELETE c;
MATCH (a:Agente) DETACH DELETE a;

// Remove constraints
DROP CONSTRAINT Poliza_idPoliza IF EXISTS;
DROP CONSTRAINT Agente_codAgente IF EXISTS;

// Create Poliza constraints
CREATE CONSTRAINT Poliza_idPoliza IF NOT EXISTS
FOR (p:Poliza)
REQUIRE p.idPoliza IS UNIQUE;

// Create Poliza nodes
CALL apoc.load.xls(
    'file:///CONTRATOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_POLIZA IS NOT NULL
MERGE (p:Poliza {idPoliza: row.ID_POLIZA}); //ON CREATE SET p.integerIdPoliza = CASE WHEN toInteger(row.ID_POLIZA) IS NOT NULL THEN true ELSE false END;

// Create Agente constraints
CREATE CONSTRAINT Agente_codAgente IF NOT EXISTS
FOR (a:Agente)
REQUIRE a.codAgente IS UNIQUE;

// Create Agente nodes
CALL apoc.load.xls(
    'file:///CONTRATOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.COD_AGENTE IS NOT NULL
MERGE (a:Agente {codAgente: toInteger(row.COD_AGENTE)});

// Create Contrato nodes and relationship (Poliza -> Contrato)
CALL apoc.load.xls(
    'file:///CONTRATOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_POLIZA IS NOT NULL AND row.ID_CONTRATO IS NOT NULL
MATCH (p:Poliza {idPoliza: row.ID_POLIZA})
MERGE (p)-[:CONTIENE]->(c:Contrato {idContrato: row.ID_CONTRATO})
ON CREATE SET
    // c.integerIdContrato = CASE WHEN toInteger(row.ID_CONTRATO) IS NOT NULL THEN true ELSE false END,
    c.danyosPropios = row.DANYOS_PROPIOS,
    c.perdidaTotal = row.PERDIDA_TOTAL,
    c.lunas = row.LUNAS,
    c.incendio = row.INCENDIO,
    c.robo = row.ROBO,
    c.dapFranquicia = toFloat(row.DAP_FRANQUICIA);