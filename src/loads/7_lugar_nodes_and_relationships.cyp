// 7. Crear nodos 'Lugar' y sus relaciones

// 7.1 Eliminar nodos 'Lugar'
MATCH (n:Lugar) DETACH DELETE n;

// 7.2 Eliminar las restricciones en nodos 'Lugar'
DROP CONSTRAINT Lugar_municipio IF EXISTS;

// 7.3 Crear las restricciones en nodos 'Lugar'
CREATE CONSTRAINT Lugar_municipio IF NOT EXISTS
FOR (l:Lugar)
REQUIRE l.municipio IS UNIQUE;

// 7.4 Crear nodos 'Lugar' a partir de nodos 'Persona'
MATCH (p:Persona)
WHERE p.municipio IS NOT NULL
MERGE (l:Lugar {municipio: p.municipio})
SET
    l.provincia = p.provincia;

// 7.5 Crear nodos lugar a partir de nodos 'Siniestro'
MATCH (s:Siniestro)
WHERE s.municipio IS NOT NULL
MERGE (l:Lugar {municipio: s.municipio});

// 7.6 Crear relaciones (Persona)-[:VIVE_EN]->(Lugar)
MATCH (p:Persona)
WHERE p.municipio IS NOT NULL
MATCH (l:Lugar {municipio: p.municipio})
MERGE (p)-[r:VIVE_EN]->(l)
SET
    r.direccion = p.direccion,
    r.codPostal = p.codPostal
REMOVE
    p.municipio, p.provincia, p.direccion, p.codPostal;

// 7.7 Crear relaciones (Siniestro)-[:OCURRE_EN]->(Lugar)
MATCH (s:Siniestro)
WHERE s.municipio IS NOT NULL
MATCH (l:Lugar {municipio: s.municipio})
MERGE (s)-[r:OCURRE_EN]->(l)
SET
    r.viaPublica = s.viaPublica,
    r.numero = s.numero,
    r.entidad = s.entidad
REMOVE s.municipio, s.viaPublica, s.numero, s.entidad;