// Cargar CONTRATOS_SINIESTROS_VEHICULOS_CONTRARIOS.xslx

// Crear nodos 'Vehiculo'
CALL apoc.load.xls(
    'file:///6_CONTRATOS_SINIESTROS_VEHICULOS_CONTRARIOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE
    row.MATRICULA IS NOT NULL AND
    NOT (row.MATRICULA =~ "NA 0*" OR row.MATRICULA =~ "0* SIN")
MERGE (v:Vehiculo {matriculaVehiculo: row.MATRICULA})
SET
    v.marca = row.MARCA,
    v.modelo = row.MODELO,
    v.tipo = row.TIPO,
    v.uso = row.USO,
    v.color = row.COLOR;

// Crear nodos 'Persona' (usando NOMBRE, APELLIDO1, APELLIDO2)
CALL apoc.load.xls(
    'file:///6_CONTRATOS_SINIESTROS_VEHICULOS_CONTRARIOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NOT NULL AND row.CTOR_APELLIDO2 IS NOT NULL
MERGE (p:Persona {nombre: row.CTOR_NOMBRE, apellido1: row.CTOR_APELLIDO1, apellido2: row.CTOR_APELLIDO2})
SET
    p.fchNacimiento = CASE WHEN row.CTOR_FCH_NACIMIENTO IS NOT NULL THEN row.CTOR_FCH_NACIMIENTO ELSE p.fchNacimiento END,
    p.fchCarnet = CASE WHEN row.CTOR_FCH_CARNET IS NOT NULL THEN row.CTOR_FCH_CARNET ELSE p.fchCarnet END,
    p.claseCarnet = CASE WHEN row.CTOR_CLASE_CARNET IS NOT NULL THEN row.CTOR_CLASE_CARNET ELSE p.claseCarnet END,
    p.viaPublica = row.CTOR_VIA_PUBLICA,            // Referencia a lugar
    p.numero = row.CTOR_NUMERO,                     // Referencia a lugar
    p.escalera = row.CTOR_ESCALERA,                 // Referencia a lugar
    p.piso = row.CTOR_PISO,                         // Referencia a lugar
    // p.codMunicipio = row.CTOR_COD_MUNICIPIO,     // Referencia a lugar [Descartada]
    p.municipio = row.CTOR_MUNICIPIO,               // Referencia a lugar [Eliminada posteriormente]
    p.entidad = row.CTOR_ENTIDAD,                   // Referencia a lugar
    p.codPostal = row.CTOR_COD_POSTAL,              // Referencia a lugar [Eliminada posteriormente]
    p.telefono1 = CASE WHEN row.CTOR_TELEFONO1 IS NOT NULL THEN row.CTOR_TELEFONO1 ELSE p.telefono1 END,
    p.telefono2 = CASE WHEN row.CTOR_TELEFONO2 IS NOT NULL THEN row.CTOR_TELEFONO2 ELSE p.telefono2 END,
    p.movil = CASE WHEN row.CTOR_MOVIL IS NOT NULL THEN row.CTOR_MOVIL ELSE p.movil END,
    p.email = CASE WHEN row.CTOR_EMAIL IS NOT NULL THEN row.CTOR_EMAIL ELSE p.email END;

// Crear nodos 'Persona' (usando NOMBRE, APELLIDO1)
CALL apoc.load.xls(
    'file:///6_CONTRATOS_SINIESTROS_VEHICULOS_CONTRARIOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NOT NULL AND row.CTOR_APELLIDO2 IS NULL
MERGE (p:Persona {nombre: row.CTOR_NOMBRE, apellido1: row.CTOR_APELLIDO1})
SET
    p.fchNacimiento = CASE WHEN row.CTOR_FCH_NACIMIENTO IS NOT NULL THEN row.CTOR_FCH_NACIMIENTO ELSE p.fchNacimiento END,
    p.fchCarnet = CASE WHEN row.CTOR_FCH_CARNET IS NOT NULL THEN row.CTOR_FCH_CARNET ELSE p.fchCarnet END,
    p.claseCarnet = CASE WHEN row.CTOR_CLASE_CARNET IS NOT NULL THEN row.CTOR_CLASE_CARNET ELSE p.claseCarnet END,
    p.viaPublica = row.CTOR_VIA_PUBLICA,            // Referencia a lugar
    p.numero = row.CTOR_NUMERO,                     // Referencia a lugar
    p.escalera = row.CTOR_ESCALERA,                 // Referencia a lugar
    p.piso = row.CTOR_PISO,                         // Referencia a lugar
    // p.codMunicipio = row.CTOR_COD_MUNICIPIO,     // Referencia a lugar [Descartada]
    p.municipio = row.CTOR_MUNICIPIO,               // Referencia a lugar [Eliminada posteriormente]
    p.entidad = row.CTOR_ENTIDAD,                   // Referencia a lugar
    p.codPostal = row.CTOR_COD_POSTAL,              // Referencia a lugar [Eliminada posteriormente]
    p.telefono1 = CASE WHEN row.CTOR_TELEFONO1 IS NOT NULL THEN row.CTOR_TELEFONO1 ELSE p.telefono1 END,
    p.telefono2 = CASE WHEN row.CTOR_TELEFONO2 IS NOT NULL THEN row.CTOR_TELEFONO2 ELSE p.telefono2 END,
    p.movil = CASE WHEN row.CTOR_MOVIL IS NOT NULL THEN row.CTOR_MOVIL ELSE p.movil END,
    p.email = CASE WHEN row.CTOR_EMAIL IS NOT NULL THEN row.CTOR_EMAIL ELSE p.email END;

// Crear nodos 'Persona' (usando NOMBRE)
CALL apoc.load.xls(
    'file:///6_CONTRATOS_SINIESTROS_VEHICULOS_CONTRARIOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NULL AND row.CTOR_APELLIDO2 IS NULL
MERGE (p:Persona {nombre: row.CTOR_NOMBRE})
SET
    p.fchNacimiento = CASE WHEN row.CTOR_FCH_NACIMIENTO IS NOT NULL THEN row.CTOR_FCH_NACIMIENTO ELSE p.fchNacimiento END,
    p.fchCarnet = CASE WHEN row.CTOR_FCH_CARNET IS NOT NULL THEN row.CTOR_FCH_CARNET ELSE p.fchCarnet END,
    p.claseCarnet = CASE WHEN row.CTOR_CLASE_CARNET IS NOT NULL THEN row.CTOR_CLASE_CARNET ELSE p.claseCarnet END,
    p.viaPublica = row.CTOR_VIA_PUBLICA,            // Referencia a lugar
    p.numero = row.CTOR_NUMERO,                     // Referencia a lugar
    p.escalera = row.CTOR_ESCALERA,                 // Referencia a lugar
    p.piso = row.CTOR_PISO,                         // Referencia a lugar
    // p.codMunicipio = row.CTOR_COD_MUNICIPIO,     // Referencia a lugar [Descartada]
    p.municipio = row.CTOR_MUNICIPIO,               // Referencia a lugar [Eliminada posteriormente]
    p.entidad = row.CTOR_ENTIDAD,                   // Referencia a lugar
    p.codPostal = row.CTOR_COD_POSTAL,              // Referencia a lugar [Eliminada posteriormente]
    p.telefono1 = CASE WHEN row.CTOR_TELEFONO1 IS NOT NULL THEN row.CTOR_TELEFONO1 ELSE p.telefono1 END,
    p.telefono2 = CASE WHEN row.CTOR_TELEFONO2 IS NOT NULL THEN row.CTOR_TELEFONO2 ELSE p.telefono2 END,
    p.movil = CASE WHEN row.CTOR_MOVIL IS NOT NULL THEN row.CTOR_MOVIL ELSE p.movil END,
    p.email = CASE WHEN row.CTOR_EMAIL IS NOT NULL THEN row.CTOR_EMAIL ELSE p.email END;

// Crear relaciones (Vehiculo)-[:INTERVIENE_COMO_CONTRARIO_EN]->(Siniestro)
CALL apoc.load.xls(
    'file:///6_CONTRATOS_SINIESTROS_VEHICULOS_CONTRARIOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.MATRICULA IS NOT NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (v:Vehiculo {matriculaVehiculo: row.MATRICULA})
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MERGE (v)-[r:INTERVIENE_COMO_CONTRARIO_EN]->(s)
SET r.danyos = row.DANYOS;

// Crear relaciones (Persona)-[:CONDUCE_VC_EN]->(Siniestro) (usando NOMBRE, APELLIDO1, APELLIDO2)
CALL apoc.load.xls(
    'file:///6_CONTRATOS_SINIESTROS_VEHICULOS_CONTRARIOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NOT NULL AND row.CTOR_APELLIDO2 IS NOT NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (p:Persona {nombre: row.CTOR_NOMBRE, apellido1: row.CTOR_APELLIDO1, apellido2: row.CTOR_APELLIDO2})
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MERGE (p)-[r:CONDUCE_VC_EN]->(s)
SET r.matriculaVehiculo = CASE WHEN row.MATRICULA IS NOT NULL THEN row.MATRICULA ELSE r.matriculaVehiculo END;

// Crear relaciones (Persona)-[:CONDUCE_VC_EN]->(Siniestro) (usando NOMBRE, APELLIDO1)
CALL apoc.load.xls(
    'file:///6_CONTRATOS_SINIESTROS_VEHICULOS_CONTRARIOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NOT NULL AND row.CTOR_APELLIDO2 IS NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (p:Persona {nombre: row.CTOR_NOMBRE, apellido1: row.CTOR_APELLIDO1})
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MERGE (p)-[r:CONDUCE_VC_EN]->(s)
SET r.matriculaVehiculo = CASE WHEN row.MATRICULA IS NOT NULL THEN row.MATRICULA ELSE r.matriculaVehiculo END;

// Crear relaciones (Persona)-[:CONDUCE_VC_EN]->(Siniestro) (usando NOMBRE)
CALL apoc.load.xls(
    'file:///6_CONTRATOS_SINIESTROS_VEHICULOS_CONTRARIOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NULL AND row.CTOR_APELLIDO2 IS NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (p:Persona {nombre: row.CTOR_NOMBRE})
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MERGE (p)-[r:CONDUCE_VC_EN]->(s)
SET r.matriculaVehiculo = CASE WHEN row.MATRICULA IS NOT NULL THEN row.MATRICULA ELSE r.matriculaVehiculo END;