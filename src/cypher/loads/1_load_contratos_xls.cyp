// Carga de CONTRATOS.xlsx

// Eliminar nodos 'Poliza' y 'Agente'
MATCH (p:Poliza) DETACH DELETE p;
MATCH (a:Agente) DETACH DELETE a;

// Eliminar restricciones en nodos 'Poliza' y 'Agente'
DROP CONSTRAINT Poliza_idPoliza IF EXISTS;
DROP CONSTRAINT Agente_codAgente IF EXISTS;

// Crear restricciones en nodos 'Poliza'
CREATE CONSTRAINT Poliza_idPoliza IF NOT EXISTS
FOR (p:Poliza)
REQUIRE p.idPoliza IS UNIQUE;

// Crear nodos 'Poliza'
CALL apoc.load.xls(
    'file:///CONTRATOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_POLIZA IS NOT NULL
MERGE (p:Poliza {idPoliza: toInteger(row.ID_POLIZA)});

// Crear restricciones en nodos 'Agente'
CREATE CONSTRAINT Agente_codAgente IF NOT EXISTS
FOR (a:Agente)
REQUIRE a.codAgente IS UNIQUE;

// Crear nodos 'Agente'
CALL apoc.load.xls(
    'file:///CONTRATOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.COD_AGENTE IS NOT NULL
MERGE (a:Agente {codAgente: toInteger(row.COD_AGENTE)});

// Crear relaciones (Agente)-[:CONTRATADA_POR]->(Poliza)
CALL apoc.load.xls(
    'file:///CONTRATOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
MATCH (p:Poliza {idPoliza: toInteger(row.ID_POLIZA)})
MATCH (a:Agente {codAgente: toInteger(row.COD_AGENTE)})
MERGE (p)-[:CONTRATADA_POR]->(a);