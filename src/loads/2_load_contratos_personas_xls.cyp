// Cargar CONTRATOS_PERSONAS.xlsx

// Eliminar nodos 'Persona'
MATCH (p:Persona) DETACH DELETE p;

// Eliminar restricciones del nodo 'Persona'
DROP CONSTRAINT Persona_idPersona IF EXISTS;

// Crear restricciones en nodos 'Persona'
CREATE CONSTRAINT Persona_idPersona IF NOT EXISTS
FOR (p:Persona)
REQUIRE p.idPersona IS UNIQUE;

// Crear nodos 'Persona'
CALL apoc.load.xls(
    'file:///2_CONTRATOS_PERSONAS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
MERGE (p:Persona {idPersona: row.ID_INTERVINIENTE})
ON CREATE SET
    p.nombre = row.NOMBRE,
    p.apellido1 = row.APELLIDO1,
    p.apellido2 = row.APELLIDO2,
    p.direccion = row.DIRECCION,            // Referencia a lugar [Eliminada posteriormente]
    p.municipio = row.MUNICIPIO,            // Referencia a lugar [Eliminada posteriormente]
    p.provincia = row.PROVINCIA,            // Referencia a lugar [Eliminada posteriormente]
    p.codPostal = row.COD_POSTAL,           // Referencia a lugar [Eliminada posteriormente]
    p.fchCarnet = row.FCH_CARNET,         
    p.fchNacimiento = row.FCH_NACIMIENTO, 
    p.sexo = row.SEXO,
    p.telefono1 = row.TELEFONO1,
    p.telefono2 = row.TELEFONO2,
    p.movil = row.MOVIL,
    p.fax = row.FAX,
    p.email = row.EMAIL;