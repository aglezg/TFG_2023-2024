// Load CONTRATOS_PERSONAS(simplificado).xlsx

// Remove nodes
MATCH (i:Persona:Interviniente) DETACH DELETE i;

// Remove constraints
DROP CONSTRAINT Interviniente_idInterviniente IF EXISTS;

// Create Poliza constraints
CREATE CONSTRAINT Poliza_idPoliza IF NOT EXISTS
FOR (p:Poliza)
REQUIRE p.idPoliza IS UNIQUE;

// Create Poliza nodes
CALL apoc.load.xls(
    'file:///CONTRATOS_PERSONAS(simplificado).xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_POLIZA IS NOT NULL
MERGE (p:Poliza {idPoliza: toInteger(row.ID_POLIZA)});

// Create Contrato nodes and relationship (Poliza -> Contrato)
CALL apoc.load.xls(
    'file:///CONTRATOS_PERSONAS(simplificado).xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.ID_CONTRATO IS NOT NULL
MATCH (p:Poliza {idPoliza: toInteger(row.ID_POLIZA)})
MERGE (p)-[:CONTIENE]->(c:Contrato {idContrato: toInteger(row.ID_CONTRATO)});

// Create Interviniente constraints
CREATE CONSTRAINT Interviniente_idInterviniente IF NOT EXISTS
FOR (i:Interviniente)
REQUIRE i.idInterviniente IS UNIQUE;

// Create Persona:Interviniente nodes
CALL apoc.load.xls(
    'file:///CONTRATOS_PERSONAS(simplificado).xlsx',
    'Hoja1',
    {
        header: true
        // Configure dates: fchCarnet, fchNacimiento
    }
) YIELD map as row
WHERE row.ID_INTERVINIENTE IS NOT NULL
MERGE (i:Persona:Interviniente {idInterviniente: toInteger(row.ID_INTERVINIENTE)})
SET
    i.nombre = row.NOMBRE,
    i.apellido1 = row.APELLIDO1,
    i.apellido2 = row.APELLIDO2,
//    i.direccion = row.DIRECCION,
//    i.municipio = row.MUNICIPIO,
//    i.provincia = row.PROVINCIA,
//    i.codPostal = toInteger(row.COD_POSTAL),
    i.fchCarnet = date(row.FCH_CARNET),
    i.fchNacimiento = date(row.FCH_NACIMIENTO),
    i.sexo = row.SEXO,
    i.telefono1 = row.TELEFONO1,
    i.telefono2 = row.TELEFONO2,
    i.movil = row.MOVIL,
    i.fax = row.FAX,
    i.email = row.EMAIL;

// Create Rol nodes
CALL apoc.load.xls(
    'file:///CONTRATOS_PERSONAS(simplificado).xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.COD_ROL IS NOT NULL OR row.ROL IS NOT NULL
MATCH (i:Persona:Interviniente {idInterviniente: toInteger(row.ID_INTERVINIENTE)})
MERGE (i)-[:TIENE_ROL]->(r:Rol {codRol: row.COD_ROL})
SET
    r.nombreRol = row.ROL;

// Create relationships (Rol -> Contrato)
CALL apoc.load.xls(
    'file:///CONTRATOS_PERSONAS(simplificado).xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
MATCH (p:Poliza {idPoliza: toInteger(row.ID_POLIZA)})-[:CONTIENE]->(c:Contrato {idContrato: toInteger(row.ID_CONTRATO)})
MATCH (i:Persona:Interviniente {idInterviniente: toInteger(row.ID_INTERVINIENTE)})-[:TIENE_ROL]->(r:Rol {codRol: row.COD_ROL})
MERGE (r)-[:INTERVIENE_EN]->(c);