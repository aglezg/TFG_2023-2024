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
    'file:///CONTRATOS_PERSONAS(simplificado).xlsx', // Version simplificada
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
MERGE (p:Persona {idPersona: toInteger(row.ID_INTERVINIENTE)})
ON CREATE SET
    p.nombre = row.NOMBRE,
    p.apellido1 = row.APELLIDO1,
    p.apellido2 = row.APELLIDO2,
    p.direccion = row.DIRECCION,     // Referencia a lugar
    p.municipio = row.MUNICIPIO,     // Referencia a lugar
    p.provincia = row.PROVINCIA,     // Referencia a lugar
    p.codPostal = row.COD_POSTAL,    // Referencia a lugar
    p.fchCarnet = row.FCH_CARNET,         // date
    p.fchNacimiento = row.FCH_NACIMIENTO, // date
    p.sexo = row.SEXO,
    p.telefono1 = row.TELEFONO1,
    p.telefono2 = row.TELEFONO2,
    p.movil = row.MOVIL,
    p.fax = row.FAX,
    p.email = row.EMAIL;