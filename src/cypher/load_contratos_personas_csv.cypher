// Load CONTRATOS_PERSONAS csv

// Deleting all "Interviente" nodes
MATCH (i:Interviniente) DETACH DELETE i;

// Dropping constraint "Interviente_id"
DROP CONSTRAINT Interviente_id IF EXISTS;

// Creating constraint "Interviente_id"
CREATE CONSTRAINT Interviente_id IF NOT EXISTS
FOR (x:Interviente)
REQUIRE x.intervinienteId IS UNIQUE;

// Creating "Interviniente" nodes
LOAD CSV WITH HEADERS
FROM 'file:///CONTRATOS_PERSONAS_simplified.csv' AS row
MERGE (i:Interviente {intervinienteId: toInteger(row.ID_INTERVINIENTE)})
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
MATCH (i:Interviente {intervinienteId: toInteger(row.ID_INTERVINIENTE)})
MATCH (p:Poliza {polizaId: toInteger(row.ID_POLIZA)})-[:POSEE]->(c:Contrato {contratoId: toInteger(row.ID_CONTRATO)})
CREATE (i)-[:INTERVIENE_EN {rol: row.ROL}]->(c);