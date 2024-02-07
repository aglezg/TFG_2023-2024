// Create Municipio nodes and their relationships

// Remove nodes
MATCH (n:Municipio) DETACH DELETE n;

// Remove constraints
DROP CONSTRAINT Municipio_nombreMunicipio IF EXISTS;

// Create Municipio constraints
CREATE CONSTRAINT Municipio_nombreMunicipio IF NOT EXISTS
FOR (m:Municipio)
REQUIRE m.nombreMunicipio IS UNIQUE;

// Create Municipio nodes from Persona nodes
MATCH (p:Persona)
WHERE p.municipio IS NOT NULL
MERGE (m:Municipio {nombreMunicipio: p.municipio})
SET
    m.provincia = p.provincia;

// Create municipio nodes from Siniestro nodes
MATCH (s:Siniestro)
WHERE s.municipio IS NOT NULL
MERGE (m:Municipio {nombreMunicipio: s.municipio});

// Create relationships (Persona-[:VIVE_EN]->Municipio)
MATCH (p:Persona)
WHERE p.municipio IS NOT NULL
MATCH (m:Municipio {nombreMunicipio: p.municipio})
MERGE (p)-[r:VIVE_EN]->(m)
SET
    r.direccion = p.direccion,
    r.codPostal = p.codPostal
REMOVE
    p.municipio, p.provincia, p.direccion, p.codPostal;

// Create relationships (Siniestro-[:OCURRE_EN]->Municipio)
MATCH (s:Siniestro)
WHERE s.municipio IS NOT NULL
MATCH (m:Municipio {nombreMunicipio: s.municipio})
MERGE (s)-[r:OCURRE_EN]->(m)
SET
    r.viaPublica = s.viaPublica,
    r.numero = s.numero,
    r.entidad = s.entidad
REMOVE s.municipio, s.viaPublica, s.numero, s.entidad;