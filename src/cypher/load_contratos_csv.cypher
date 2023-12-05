// Load CONTRATOS.csv file into Neo4j

// Removing nodes
MATCH (p:Poliza) DETACH DELETE p;
MATCH (c:Contrato) DETACH DELETE c;
MATCH (a:Agente) DETACH DELETE a;

// Removing CONSTRAINTS
DROP CONSTRAINT Poliza_id IF EXISTS;
DROP CONSTRAINT Agente_cod IF EXISTS;

// Creating CONSTRAINTS
CREATE CONSTRAINT Poliza_id IF NOT EXISTS
FOR (x:Poliza)
REQUIRE x.polizaId IS UNIQUE;

CREATE CONSTRAINT Agente_cod IF NOT EXISTS
FOR (x:Agente)
REQUIRE x.agenteCod IS UNIQUE;

// Creating Poliza nodes
LOAD CSV WITH HEADERS
FROM 'file:///CONTRATOS.csv' AS row
MERGE (p:Poliza {polizaId: toInteger(row.ID_POLIZA)});

// Creating Agente nodes
LOAD CSV WITH HEADERS
FROM 'file:///CONTRATOS.csv' AS row
MERGE (a:Agente {agenteCod: toInteger(row.COD_AGENTE)});

// Creating Contrato nodes and relationships
LOAD CSV WITH HEADERS
FROM 'file:///CONTRATOS.csv' as row
MATCH (p:Poliza {polizaId: toInteger(row.ID_POLIZA)})
MATCH (a:Agente {agenteCod: toInteger(row.COD_AGENTE)})
CREATE (p)-[:CONTIENE]->(c:Contrato {contratoId: toInteger(row.ID_CONTRATO)})<-[:INTERVIENE_EN]-(a)
SET
    c.danyosPropios = row.DANYOS_PROPIOS,
    c.perdidaTotal = row.PERDIDA_TOTAL,
    c.lunas = row.LUNAS,
    c.incendio = row.INCENDIO,
    c.robo = row.ROBO,
    c.dapFranquicia = toFloat(row.DAP_FRANQUICIA);