// Load CONTRATOS_PERSONAS csv

// Deleting all "Persona:Interviniente" nodes
MATCH (i:Persona:Interviniente) DETACH DELETE i;

// Dropping constraint "Interviniente_id"
DROP CONSTRAINT Interviniente_id IF EXISTS;

// Creating constraint "Interviniente_id"
CREATE CONSTRAINT Interviniente_id IF NOT EXISTS
FOR (x:Persona:Interviniente)
REQUIRE x.intervinienteId IS UNIQUE;

// Creating "Interviniente" nodes
LOAD CSV WITH HEADERS
FROM 'file:///CONTRATOS_PERSONAS_simplified.csv' AS row
MERGE (i:Persona:Interviniente {intervinienteId: toInteger(row.ID_INTERVINIENTE)})
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

// Creating "Rol" nodes
LOAD CSV WITH HEADERS
FROM 'file:///CONTRATOS_PERSONAS_simplified.csv' AS row
MATCH (i:Persona:Interviniente {intervinienteId: toInteger(row.ID_INTERVINIENTE)})
MERGE (i)-[:TIENE_ROL]->(r:Rol {rolCod: row.COD_ROL})
SET r.nombreRol = row.ROL;

// Creating relationships
LOAD CSV WITH HEADERS
FROM 'file:///CONTRATOS_PERSONAS_simplified.csv' AS row
MATCH (p:Poliza {polizaId: toInteger(row.ID_POLIZA)})-[:POSEE]->(c:Contrato {contratoId: toInteger(row.ID_CONTRATO)})
MATCH (i:Persona:Interviniente {intervinienteId: toInteger(row.ID_INTERVINIENTE)})-[:TIENE_ROL]->(r:Rol {rolCod: row.COD_ROL})
MERGE (r)-[:INTERVIENE_EN]->(c);