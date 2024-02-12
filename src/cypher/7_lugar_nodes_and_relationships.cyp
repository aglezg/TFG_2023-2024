// Create Lugar nodes and their relationships

// Remove nodes
MATCH (n:Lugar) DETACH DELETE n;

// Remove constraints
DROP CONSTRAINT Lugar_municipio IF EXISTS;

// Create Lugar constraints
CREATE CONSTRAINT Lugar_municipio IF NOT EXISTS
FOR (l:Lugar)
REQUIRE l.municipio IS UNIQUE;

// Create Lugar nodes from Persona nodes
MATCH (p:Persona)
WHERE p.municipio IS NOT NULL
MERGE (l:Lugar {municipio: p.municipio})
SET
    l.provincia = p.provincia;

// Create lugar nodes from Siniestro nodes
MATCH (s:Siniestro)
WHERE s.municipio IS NOT NULL
MERGE (l:Lugar {municipio: s.municipio});

// Create relationships (Persona-[:VIVE_EN]->Lugar)
MATCH (p:Persona)
WHERE p.municipio IS NOT NULL
MATCH (l:Lugar {municipio: p.municipio})
MERGE (p)-[r:VIVE_EN]->(l)
SET
    r.direccion = p.direccion,
    r.codPostal = p.codPostal
REMOVE
    p.municipio, p.provincia, p.direccion, p.codPostal;

// Create relationships (Siniestro-[:OCURRE_EN]->Lugar)
MATCH (s:Siniestro)
WHERE s.municipio IS NOT NULL
MATCH (l:Lugar {municipio: s.municipio})
MERGE (s)-[r:OCURRE_EN]->(l)
SET
    r.viaPublica = s.viaPublica,
    r.numero = s.numero,
    r.entidad = s.entidad
REMOVE s.municipio, s.viaPublica, s.numero, s.entidad;