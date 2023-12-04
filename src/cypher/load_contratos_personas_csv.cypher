// Load CONTRATOS_PERSONAS csv

// Deleting all "Interviniente" nodes
MATCH (i:Interviniente) DETACH DELETE i;

// Dropping constraint "Interviniente_id"
DROP CONSTRAINT Interviniente_id IF EXISTS;

// Creating constraint "Interviniente_id"
CREATE CONSTRAINT Interviniente_id IF NOT EXISTS
FOR (x:Interviniente)
REQUIRE x.intervinienteId IS UNIQUE;

// Creating "Interviniente" nodes
LOAD CSV WITH HEADERS
FROM 'file:///CONTRATOS_PERSONAS_simplified.csv' AS row
MERGE (i:Interviniente {intervinienteId: toInteger(row.ID_INTERVINIENTE)})
SET
    i.nombre = row.NOMBRE,
    i.apellido1 = row.APELLIDO1,
    i.apellido2 = row.APELLIDO2,
    i.direccion = row.DIRECCION,
    i.municipio = row.MUNICIPIO,
    i.provincia = row.PROVINCIA,
    i.codPostal = toInteger(row.COD_POSTAL),
//    i.fchCarnet = datetime(row.FCH_CARNET),
//    i.fchNacimiento = datetime(row.FCH_NACIMIENTO),
    i.sexo = row.SEXO,
    i.telefono1 = row.TELEFONO1,
    i.telefono2 = row.TELEFONO2,
    i.movil = row.MOVIL,
    i.fax = row.FAX,
    i.email = row.EMAIL;

// Creating relationships
LOAD CSV WITH HEADERS
FROM 'file:///CONTRATOS_PERSONAS_simplified.csv' AS row
MATCH (i:Interviniente {intervinienteId: toInteger(row.ID_INTERVINIENTE)})
MATCH (p:Poliza {polizaId: toInteger(row.ID_POLIZA)})-[:POSEE]->(c:Contrato {contratoId: toInteger(row.ID_CONTRATO)})
CREATE (i)-[:INTERVIENE_EN {rol: row.ROL}]->(c);