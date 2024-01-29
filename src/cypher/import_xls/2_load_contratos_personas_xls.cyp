// Load CONTRATOS_PERSONAS.xlsx

// Remove nodes
MATCH (p:Persona) DETACH DELETE p;

// Remove constraints
DROP CONSTRAINT Persona_idPersona IF EXISTS;

// Create Persona constraints
CREATE CONSTRAINT Persona_idPersona IF NOT EXISTS
FOR (p:Persona)
REQUIRE p.idPersona IS UNIQUE;

// Create Persona nodes
CALL apoc.load.xls(
    'file:///CONSTRATOS_PERSONAS.xlsx', // Puede que haya que usar la version simplificada
    {
        header: true
    }
) YIELD map as row
MERGE (p:Persona {idPersona: toInteger(row.ID_INTERVINIENTE)})
ON CREATE SET
    p.nombre = row.NOMBRE,
    p.apellido1 = row.APELLIDO1,
    p.apellido2 = row.APELLIDO2,
    // p.direccion = row.DIRECCION,
    // p.municipio = row.MUNICIPIO,
    // p.provincia = row.PROVINCIA,
    // p.codPostal = row.COD_POSTAL,
    p.fchCarnet = row.FCH_CARNET,
    p.fchNacimiento = row.FCH_NACIMIENTO,
    p.sexo = row.SEXO,
    p.telefono1 = row.TELEFONO1,
    p.telefono2 = row.TELEFONO2,
    p.movil = row.MOVIL,
    p.fax = row.FAX,
    p.email = row.EMAIL;