// Load CONTRATOS_SINIESTROS_LESIONADOS.xlsx

// Remove nodes
MATCH (v:Vehiculo) DETACH DELETE v;

// Remove constraints
DROP CONSTRAINT Vehiculo_matriculaVehiculo IF EXISTS;

// Create Vehiculo constraints
CREATE CONSTRAINT Vehiculo_matriculaVehiculo IF NOT EXISTS
for (v:Vehiculo)
REQUIRE v.matriculaVehiculo IS UNIQUE;

// Create Vehiculo nodes
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.VEHICULO_VIAJA IS NOT NULL
MERGE (v:Vehiculo {matriculaVehiculo: row.VEHICULO_VIAJA});

// Create Persona nodes [(1) => NOMBRE, APELLIDO1, APELLIDO2]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
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
    p.email = CASE WHEN row.EMAIL IS NOT NULL THEN row.EMAIL ELSE p.email END;

// Create Persona nodes [(2) => NOMBRE, APELLIDO1]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
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
    p.email = CASE WHEN row.EMAIL IS NOT NULL THEN row.EMAIL ELSE p.email END;

// Create Persona nodes [(3) => NOMBRE]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
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
    p.email = CASE WHEN row.EMAIL IS NOT NULL THEN row.EMAIL ELSE p.email END;

// Create relationships [ES_LESIONADA_EN] [(1) => NOMBRE, APELLIDO1, APELLIDO2]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NOT NULL // AND row.SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
MERGE (p)-[r:ES_LESIONADA_EN]->(s)
SET r.danyos = row.DAÑOS;


// Create relationships [ES_LESIONADA_EN] [(2) => NOMBRE, APELLIDO1]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NULL // AND row.SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1}) WHERE p.apellido2 IS NULL
MERGE (p)-[r:ES_LESIONADA_EN]->(s)
SET r.danyos = row.DAÑOS;

// Create relationships [ES_LESIONADA_EN] [(3) => NOMBRE]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NULL AND row.APELLIDO2 IS NULL // AND row.SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE}) WHERE p.apellido1 IS NULL AND p.apellido2 IS NULL
MERGE (p)-[r:ES_LESIONADA_EN]->(s)
SET r.danyos = row.DAÑOS;

// Create relationships [ES_PEATON_EN] [(1) => NOMBRE, APELLIDO1, APELLIDO2]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NOT NULL AND row.ROL = "PEATON" // AND row.SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
MERGE (p)-[r:ES_PEATON_EN]->(s);

// Create relationships [ES_PEATON_EN] [(2) => NOMBRE, APELLIDO1]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NULL AND row.ROL = "PEATON" // AND row.SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
MERGE (p)-[r:ES_PEATON_EN]->(s);

// Create relationships [ES_PEATON_EN] [(3) => NOMBRE]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NULL AND row.APELLIDO2 IS NULL AND row.ROL = "PEATON" // AND row.SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
MERGE (p)-[r:ES_PEATON_EN]->(s);

// Create relationships [INTERVIENE_EN_SINIESTRO] [(1) => NOMBRE, APELLIDO1, APELLIDO2]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NOT NULL
AND (row.ROL = "OCUP. V/A" OR row.ROL = "CTOR. V/A" OR row.ROL = "OCUP. V/C" OR row.ROL = "CTOR. V/C")  // AND row.SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
MERGE (p)-[r:INTERVIENE_EN_SINIESTRO {rol: row.ROL}]->(s)
SET r.matriculaVehiculo = CASE WHEN row.VEHICULO_VIAJA IS NOT NULL THEN row.VEHICULO_VIAJA ELSE r.matriculaVehiculo END;

// Create relationships [INTERVIENE_EN_SINIESTRO] [(2) => NOMBRE, APELLIDO1]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NOT NULL AND row.APELLIDO2 IS NULL AND row.ROL = "PEATON" // AND row.SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
MERGE (p)-[r:INTERVIENE_EN_SINIESTRO {rol: row.ROL}]->(s)
SET r.matriculaVehiculo = CASE WHEN row.VEHICULO_VIAJA IS NOT NULL THEN row.VEHICULO_VIAJA ELSE r.matriculaVehiculo END;

// Create relationships [INTERVIENE_EN_SINIESTRO] [(3) => NOMBRE]
CALL apoc.load.xls(
    'file:///CONTRATOS_SINIESTROS_LESIONADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.NOMBRE IS NOT NULL AND row.APELLIDO1 IS NULL AND row.APELLIDO2 IS NULL AND row.ROL = "PEATON" // AND row.SINIESTRO IS NOT NULL
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MATCH (p:Persona {nombre: row.NOMBRE, apellido1: row.APELLIDO1, apellido2: row.APELLIDO2})
MERGE (p)-[r:INTERVIENE_EN_SINIESTRO {rol: row.ROL}]->(s)
SET r.matriculaVehiculo = CASE WHEN row.VEHICULO_VIAJA IS NOT NULL THEN row.VEHICULO_VIAJA ELSE r.matriculaVehiculo END;

// Create relationships [CONDUCE_VA_EN, CONDUCE_VC_EN, VIAJA_EN_VA_EN, VIAJA_EN_VC_EN]
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

// Create relationships (vehiculo)-[INTERVIENE_COMO_ASEGURADO/CONTRARIO_EN]->(siniestro)
MATCH (p:Persona)-[r:CONDUCE_VA_EN|VIAJA_EN_VA_EN]->(s:Siniestro)
MATCH (v:Vehiculo)
WHERE r.matriculaVehiculo = v.matriculaVehiculo
MERGE (v)-[:INTERVIENE_COMO_ASEGURADO_EN]->(s);

MATCH (p:Persona)-[r:CONDUCE_VC_EN|VIAJA_EN_VC_EN]->(s:Siniestro)
MATCH (v:Vehiculo)
WHERE r.matriculaVehiculo = v.matriculaVehiculo
MERGE (v)-[:INTERVIENE_COMO_CONTRARIO_EN]->(s);