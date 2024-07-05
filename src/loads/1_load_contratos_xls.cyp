// 1. Carga de CONTRATOS.xlsx

// 1.1 Eliminar nodos 'Poliza' y 'Agente'
MATCH (p:Poliza) DETACH DELETE p;
MATCH (a:Agente) DETACH DELETE a;

// 1.2 Eliminar restricciones en nodos 'Poliza' y 'Agente'
DROP CONSTRAINT Poliza_idPoliza IF EXISTS;
DROP CONSTRAINT Agente_codAgente IF EXISTS;

// 1.3 Crear restricciones en nodos 'Poliza'
CREATE CONSTRAINT Poliza_idPoliza IF NOT EXISTS
FOR (p:Poliza)
REQUIRE p.idPoliza IS UNIQUE;

// 1.4 Crear nodos 'Poliza'
CALL apoc.load.xls(
    'file:///1_CONTRATOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_POLIZA IS NOT NULL
MERGE (p:Poliza {idPoliza: row.ID_POLIZA});

// 1.5 Crear restricciones en nodos 'Agente'
CREATE CONSTRAINT Agente_codAgente IF NOT EXISTS
FOR (a:Agente)
REQUIRE a.codAgente IS UNIQUE;

// 1.6 Crear nodos 'Agente'
CALL apoc.load.xls(
    'file:///1_CONTRATOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.COD_AGENTE IS NOT NULL
MERGE (a:Agente {codAgente: row.COD_AGENTE});

// 1.7 Crear relaciones (Poliza)-[:CONTRATADA_POR]->(Agente)
CALL apoc.load.xls(
    'file:///1_CONTRATOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
MATCH (p:Poliza {idPoliza: row.ID_POLIZA})
MATCH (a:Agente {codAgente: row.COD_AGENTE})
MERGE (p)-[:CONTRATADA_POR]->(a);