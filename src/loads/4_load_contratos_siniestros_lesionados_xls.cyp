// 4. Cargar CONTRATOS_SINIESTROS_LESIONADOS.xlsx

// 4.1 Eliminar nodos 'Vehiculo'
MATCH (v:Vehiculo) DETACH DELETE v;

// 4.2 Eliminar restricciones en nodos 'Vehiculo'
DROP CONSTRAINT Vehiculo_matriculaVehiculo IF EXISTS;

// 4.3 Crear restricciones en nodos 'Vehiculos'
CREATE CONSTRAINT Vehiculo_matriculaVehiculo IF NOT EXISTS
for (v:Vehiculo)
REQUIRE v.matriculaVehiculo IS UNIQUE;

// 4.4 Crear nodos 'Vehiculo'
CALL apoc.load.xls(
    'file:///4_CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE
    row.VEHICULO_VIAJA IS NOT NULL AND
    NOT (row.VEHICULO_VIAJA =~ "NA 0*" OR row.VEHICULO_VIAJA =~ "0* SIN")
MERGE (v:Vehiculo {matriculaVehiculo: row.VEHICULO_VIAJA});

// 4.5 Crear nodos 'Persona' (usando NOMBRE, APELLIDO1, APELLIDO2)
CALL apoc.load.xls(
    'file:///4_CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NOT NULL
MERGE (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
SET
    p.edad = CASE WHEN row.EDAD IS NOT NULL THEN row.EDAD ELSE p.edad END,
    p.telefono1 = CASE WHEN row.TELEFONO1 IS NOT NULL THEN row.TELEFONO1 ELSE p.telefono1 END,
    p.telefono2 = CASE WHEN row.TELEFONO2 IS NOT NULL THEN row.TELEFONO2 ELSE p.telefono2 END,
    p.movil = CASE WHEN row.MOVIL IS NOT NULL THEN row.MOVIL ELSE p.movil END,
    p.fax = CASE WHEN row.FAX IS NOT NULL THEN row.FAX ELSE p.fax END,
    p.email = CASE WHEN row.EMAIL IS NOT NULL THEN row.EMAIL ELSE p.email END,
    p.viaPublica = row.VIA_PUBLICA,     // Referencia a lugar
    p.numero = row.NUMERO,              // Referencia a lugar
    p.piso = row.PISO,                  // Referencia a lugar
    p.municipio = row.MUNICIPIO,        // Referencia a lugar [Eliminada posteriormente]
    p.provincia = row.PROVINCIA,        // Referencia a lugar [Eliminada posteriormente]
    p.codPostal = row.CODIGO_POSTAL;    // Referencia a lugar [Eliminada posteriormente]

// 4.6 Crear nodos 'Persona' (usando NOMBRE, APELLIDO1)
CALL apoc.load.xls(
    'file:///4_CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NULL
MERGE (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1})
SET
    p.edad = CASE WHEN row.EDAD IS NOT NULL THEN row.EDAD ELSE p.edad END,
    p.telefono1 = CASE WHEN row.TELEFONO1 IS NOT NULL THEN row.TELEFONO1 ELSE p.telefono1 END,
    p.telefono2 = CASE WHEN row.TELEFONO2 IS NOT NULL THEN row.TELEFONO2 ELSE p.telefono2 END,
    p.movil = CASE WHEN row.MOVIL IS NOT NULL THEN row.MOVIL ELSE p.movil END,
    p.fax = CASE WHEN row.FAX IS NOT NULL THEN row.FAX ELSE p.fax END,
    p.email = CASE WHEN row.EMAIL IS NOT NULL THEN row.EMAIL ELSE p.email END,
    p.viaPublica = row.VIA_PUBLICA,     // Referencia a lugar
    p.numero = row.NUMERO,              // Referencia a lugar
    p.piso = row.PISO,                  // Referencia a lugar
    p.municipio = row.MUNICIPIO,        // Referencia a lugar [Eliminada posteriormente]
    p.provincia = row.PROVINCIA,        // Referencia a lugar [Eliminada posteriormente]
    p.codPostal = row.CODIGO_POSTAL;    // Referencia a lugar [Eliminada posteriormente]

// 4.7 Crear nodos 'Persona' (usando NOMBRE)
CALL apoc.load.xls(
    'file:///4_CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NULL AND row.APELLIDO2 IS NULL
MERGE (p:Persona {nombre: row.NOMBRE})
SET
    p.edad = CASE WHEN row.EDAD IS NOT NULL THEN row.EDAD ELSE p.edad END,
    p.telefono1 = CASE WHEN row.TELEFONO1 IS NOT NULL THEN row.TELEFONO1 ELSE p.telefono1 END,
    p.telefono2 = CASE WHEN row.TELEFONO2 IS NOT NULL THEN row.TELEFONO2 ELSE p.telefono2 END,
    p.movil = CASE WHEN row.MOVIL IS NOT NULL THEN row.MOVIL ELSE p.movil END,
    p.fax = CASE WHEN row.FAX IS NOT NULL THEN row.FAX ELSE p.fax END,
    p.email = CASE WHEN row.EMAIL IS NOT NULL THEN row.EMAIL ELSE p.email END,
    p.viaPublica = row.VIA_PUBLICA,     // Referencia a lugar
    p.numero = row.NUMERO,              // Referencia a lugar
    p.piso = row.PISO,                  // Referencia a lugar
    p.municipio = row.MUNICIPIO,        // Referencia a lugar [Eliminada posteriormente]
    p.provincia = row.PROVINCIA,        // Referencia a lugar [Eliminada posteriormente]
    p.codPostal = row.CODIGO_POSTAL;    // Referencia a lugar [Eliminada posteriormente]

// 4.8 Create relationships (Persona)-[ES_LESIONADA_EN]->(Siniestro) (usando NOMBRE, APELLIDO1, APELLIDO2)
CALL apoc.load.xls(
    'file:///4_CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NOT NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
MERGE (p)-[r:ES_LESIONADA_EN]->(s)
SET r.danyos = row.DAÑOS;


// 4.9 Create relationships (Persona)-[ES_LESIONADA_EN]->(Siniestro) (usando NOMBRE, APELLIDO1)
CALL apoc.load.xls(
    'file:///4_CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1}) WHERE p.apellido2 IS NULL
MERGE (p)-[r:ES_LESIONADA_EN]->(s)
SET r.danyos = row.DAÑOS;

// 4.10 Create relationships (Persona)-[ES_LESIONADA_EN]->(Siniestro) (usando NOMBRE)
CALL apoc.load.xls(
    'file:///4_CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NULL AND row.APELLIDO2 IS NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE}) WHERE p.apellido1 IS NULL AND p.apellido2 IS NULL
MERGE (p)-[r:ES_LESIONADA_EN]->(s)
SET r.danyos = row.DAÑOS;

// 4.11 Crear relaciones (Persona)-[INTERVIENE_EN_SINIESTRO]->(Siniestro) (usando NOMBRE, APELLIDO1, APELLIDO2)
CALL apoc.load.xls(
    'file:///4_CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NOT NULL AND row.ROL IS NOT NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
MERGE (p)-[r:INTERVIENE_EN_SINIESTRO {rol: row.ROL}]->(s)
SET r.matriculaVehiculo = CASE WHEN row.VEHICULO_VIAJA IS NOT NULL THEN row.VEHICULO_VIAJA ELSE r.matriculaVehiculo END;

// 4.12 Crear relaciones (Persona)-[INTERVIENE_EN_SINIESTRO]->(Siniestro) (usando NOMBRE, APELLIDO1)
CALL apoc.load.xls(
    'file:///4_CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NOT NULL AND row.ROL IS NOT NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
MERGE (p)-[r:INTERVIENE_EN_SINIESTRO {rol: row.ROL}]->(s)
SET r.matriculaVehiculo = CASE WHEN row.VEHICULO_VIAJA IS NOT NULL THEN row.VEHICULO_VIAJA ELSE r.matriculaVehiculo END;

// 4.13 Crear relaciones (Persona)-[INTERVIENE_EN_SINIESTRO]->(Siniestro) (usando NOMBRE)
CALL apoc.load.xls(
    'file:///4_CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NOT NULL AND row.ROL IS NOT NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
MERGE (p)-[r:INTERVIENE_EN_SINIESTRO {rol: row.ROL}]->(s)
SET r.matriculaVehiculo = CASE WHEN row.VEHICULO_VIAJA IS NOT NULL THEN row.VEHICULO_VIAJA ELSE r.matriculaVehiculo END;

// 4.14 Crear relaciones (Persona)-[ES_PEATON_EN,CONDUCE_VA_EN, CONDUCE_VC_EN, VIAJA_EN_VA_EN, VIAJA_EN_VC_EN]->(Siniestro)
// && Borrar relaciones anteriores [INTERVIENE_EN_SINIESTRO]
MATCH (p:Persona)-[r:INTERVIENE_EN_SINIESTRO]->(s:Siniestro)
WHERE r.rol = "PEATON"
MERGE (p)-[r2:ES_PEATON_EN]->(s)
DELETE r;

MATCH (p:Persona)-[r:INTERVIENE_EN_SINIESTRO]->(s:Siniestro)
WHERE r.rol = "CICLISTA"
MERGE (p)-[r2:ES_CICLISTA_EN]->(s)
DELETE r;

MATCH (p:Persona)-[r:INTERVIENE_EN_SINIESTRO]->(s:Siniestro)
WHERE r.rol = "CTOR. V/A"
MERGE (p)-[r2:CONDUCE_VA_EN]->(s)
SET r2.matriculaVehiculo = CASE WHEN r.matriculaVehiculo IS NOT NULL THEN r.matriculaVehiculo ELSE NULL END
DELETE r;

MATCH (p:Persona)-[r:INTERVIENE_EN_SINIESTRO]->(s:Siniestro)
WHERE r.rol = "CTOR. V/C"
MERGE (p)-[r2:CONDUCE_VC_EN]->(s)
SET r2.matriculaVehiculo = CASE WHEN r.matriculaVehiculo IS NOT NULL THEN r.matriculaVehiculo ELSE NULL END
DELETE r;

MATCH (p:Persona)-[r:INTERVIENE_EN_SINIESTRO]->(s:Siniestro)
WHERE r.rol = "OCUP. V/A"
MERGE (p)-[r2:VIAJA_EN_VA_EN]->(s)
SET r2.matriculaVehiculo = CASE WHEN r.matriculaVehiculo IS NOT NULL THEN r.matriculaVehiculo ELSE NULL END
DELETE r;

MATCH (p:Persona)-[r:INTERVIENE_EN_SINIESTRO]->(s:Siniestro)
WHERE r.rol = "OCUP. V/C"
MERGE (p)-[r2:VIAJA_EN_VC_EN]->(s)
SET r2.matriculaVehiculo = CASE WHEN r.matriculaVehiculo IS NOT NULL THEN r.matriculaVehiculo ELSE NULL END
DELETE r;

// 4.15 Crear relaciones (Vehiculo)-[INTERVIENE_COMO_ASEGURADO|CONTRARIO_EN]->(Siniestro)
MATCH (p:Persona)-[r:CONDUCE_VA_EN|VIAJA_EN_VA_EN]->(s:Siniestro)
MATCH (v:Vehiculo)
WHERE r.matriculaVehiculo = v.matriculaVehiculo
MERGE (v)-[:INTERVIENE_COMO_ASEGURADO_EN]->(s);

// 4.16 Crear relaciones (Persona)-[CONDUCE_VC_EN|VIAJA_EN_VC_EN]->(Siniestro)
MATCH (p:Persona)-[r:CONDUCE_VC_EN|VIAJA_EN_VC_EN]->(s:Siniestro)
MATCH (v:Vehiculo)
WHERE r.matriculaVehiculo = v.matriculaVehiculo
MERGE (v)-[:INTERVIENE_COMO_CONTRARIO_EN]->(s);