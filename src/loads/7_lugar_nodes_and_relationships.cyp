// 7. Crear nodos 'Lugar' y sus relaciones

// Eliminar nodos 'Lugar'
MATCH (n:Lugar) DETACH DELETE n;

// Eliminar nodos 'Lugar'
DROP CONSTRAINT Lugar_municipio IF EXISTS;

// Crear las restricciones en nodos 'Lugar'
CREATE CONSTRAINT Lugar_municipio IF NOT EXISTS
FOR (l:Lugar)
REQUIRE l.municipio IS UNIQUE;

// Crear nodos 'Lugar' a partir de nodos 'Persona'
MATCH (p:Persona)
WHERE p.municipio IS NOT NULL
MERGE (l:Lugar {municipio: p.municipio})
SET
    l.provincia = p.provincia;

// Crear nodos lugar a partir de nodos 'Siniestro'
MATCH (s:Siniestro)
WHERE s.municipio IS NOT NULL
MERGE (l:Lugar {municipio: s.municipio});

// Crear relaciones (Persona)-[:VIVE_EN]->(Lugar)
MATCH (p:Persona)
WHERE p.municipio IS NOT NULL
MATCH (l:Lugar {municipio: p.municipio})
MERGE (p)-[r:VIVE_EN]->(l)
SET
    r.direccion = p.direccion,
    r.codPostal = p.codPostal
REMOVE
    p.municipio, p.provincia, p.direccion, p.codPostal;

// Crear relaciones (Siniestro)-[:OCURRE_EN]->(Lugar)
MATCH (s:Siniestro)
WHERE s.municipio IS NOT NULL
MATCH (l:Lugar {municipio: s.municipio})
MERGE (s)-[r:OCURRE_EN]->(l)
SET
    r.viaPublica = s.viaPublica,
    r.numero = s.numero,
    r.entidad = s.entidad
REMOVE s.municipio, s.viaPublica, s.numero, s.entidad;