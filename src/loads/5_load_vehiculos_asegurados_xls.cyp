// 5. Cargar CONTRATOS_SINIESTROS_VEHICULOS_ASEGURADOS.xslx

// 5.1 Crear nodos 'Vehiculo'
CALL apoc.load.xls(
    'file:///5_CONTRATOS_SINIESTROS_VEHICULOS_ASEGURADOS.xlsx',
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
    v.indFlota = row.IND_FLOTA;

// 5.2 Crear nodos 'Persona' (usando NOMBRE, APELLIDO1, APELLIDO2)
CALL apoc.load.xls(
    'file:///5_CONTRATOS_SINIESTROS_VEHICULOS_ASEGURADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NOT NULL AND row.CTOR_APELLIDO2 IS NOT NULL
MERGE (p:Persona {nombre: row.CTOR_NOMBRE, apellido1: row.CTOR_APELLIDO1, apellido2: row.CTOR_APELLIDO2})
SET
    p.sexo = CASE WHEN row.CTOR_SEXO IS NOT NULL THEN row.CTOR_SEXO ELSE p.sexo END,
    p.fchNacimiento = CASE WHEN row.CTOR_FCH_NACIMIENTO IS NOT NULL THEN row.CTOR_FCH_NACIMIENTO ELSE p.fchNacimiento END,
    p.fchCarnet = CASE WHEN row.CTOR_FCH_CARNET IS NOT NULL THEN row.CTOR_FCH_CARNET ELSE p.fchCarnet END,
    p.sigla = row.CTOR_SIGLA,               // Referencia a lugar
    p.viaPublica = row.CTOR_VIA_PUBLICA,    // Referencia a lugar
    p.numero = row.CTOR_NUMERO,             // Referencia a lugar
    p.escalera = row.CTOR_ESCALERA,         // Referencia a lugar
    p.piso = row.CTOR_PISO,                 // Referencia a lugar
    p.municipio = row.CTOR_MUNICIPIO,       // Referencia a lugar [Eliminada posteriormente]
    p.provincia = row.CTOR_PROVINCIA,       // Referencia a lugar [Eliminada posteriormente]
    p.entidad = row.CTOR_ENTIDAD,           // Referencia a lugar
    p.codPostal = row.CTOR_COD_POSTAL,      // Referencia a lugar [Eliminada posteriormente]
    p.movil = CASE WHEN row.CTOR_MOVIL IS NOT NULL THEN row.CTOR_MOVIL ELSE p.movil END,
    p.fax = CASE WHEN row.CTOR_FAX IS NOT NULL THEN row.CTOR_FAX ELSE p.fax END,
    p.email = CASE WHEN row.CTOR_EMAIL IS NOT NULL THEN row.CTOR_EMAIL ELSE p.email END;

// 5.3 Crear nodos 'Persona' (usando NOMBRE, APELLIDO1)
CALL apoc.load.xls(
    'file:///5_CONTRATOS_SINIESTROS_VEHICULOS_ASEGURADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NOT NULL AND row.CTOR_APELLIDO2 IS NULL
MERGE (p:Persona {nombre: row.CTOR_NOMBRE, apellido1: row.CTOR_APELLIDO1})
SET
    p.sexo = CASE WHEN row.CTOR_SEXO IS NOT NULL THEN row.CTOR_SEXO ELSE p.sexo END,
    p.fchNacimiento = CASE WHEN row.CTOR_FCH_NACIMIENTO IS NOT NULL THEN row.CTOR_FCH_NACIMIENTO ELSE p.fchNacimiento END,
    p.fchCarnet = CASE WHEN row.CTOR_FCH_CARNET IS NOT NULL THEN row.CTOR_FCH_CARNET ELSE p.fchCarnet END,
    p.sigla = row.CTOR_SIGLA,               // Referencia a lugar
    p.viaPublica = row.CTOR_VIA_PUBLICA,    // Referencia a lugar
    p.numero = row.CTOR_NUMERO,             // Referencia a lugar
    p.escalera = row.CTOR_ESCALERA,         // Referencia a lugar
    p.piso = row.CTOR_PISO,                 // Referencia a lugar
    p.municipio = row.CTOR_MUNICIPIO,       // Referencia a lugar [Eliminada posteriormente]
    p.provincia = row.CTOR_PROVINCIA,       // Referencia a lugar [Eliminada posteriormente]
    p.entidad = row.CTOR_ENTIDAD,           // Referencia a lugar
    p.codPostal = row.CTOR_COD_POSTAL,      // Referencia a lugar [Eliminada posteriormente]
    p.movil = CASE WHEN row.CTOR_MOVIL IS NOT NULL THEN row.CTOR_MOVIL ELSE p.movil END,
    p.fax = CASE WHEN row.CTOR_FAX IS NOT NULL THEN row.CTOR_FAX ELSE p.fax END,
    p.email = CASE WHEN row.CTOR_EMAIL IS NOT NULL THEN row.CTOR_EMAIL ELSE p.email END;

// 5.4 Crear nodos 'Persona' (usando NOMBRE)
CALL apoc.load.xls(
    'file:///5_CONTRATOS_SINIESTROS_VEHICULOS_ASEGURADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NULL AND row.CTOR_APELLIDO2 IS NULL
MERGE (p:Persona {nombre: row.CTOR_NOMBRE})
SET
    p.sexo = CASE WHEN row.CTOR_SEXO IS NOT NULL THEN row.CTOR_SEXO ELSE p.sexo END,
    p.fchNacimiento = CASE WHEN row.CTOR_FCH_NACIMIENTO IS NOT NULL THEN row.CTOR_FCH_NACIMIENTO ELSE p.fchNacimiento END,
    p.fchCarnet = CASE WHEN row.CTOR_FCH_CARNET IS NOT NULL THEN row.CTOR_FCH_CARNET ELSE p.fchCarnet END,
    p.sigla = row.CTOR_SIGLA,               // Referencia a lugar
    p.viaPublica = row.CTOR_VIA_PUBLICA,    // Referencia a lugar
    p.numero = row.CTOR_NUMERO,             // Referencia a lugar
    p.escalera = row.CTOR_ESCALERA,         // Referencia a lugar
    p.piso = row.CTOR_PISO,                 // Referencia a lugar
    p.municipio = row.CTOR_MUNICIPIO,       // Referencia a lugar [Eliminada posteriormente]
    p.provincia = row.CTOR_PROVINCIA,       // Referencia a lugar [Eliminada posteriormente]
    p.entidad = row.CTOR_ENTIDAD,           // Referencia a lugar
    p.codPostal = row.CTOR_COD_POSTAL,      // Referencia a lugar [Eliminada posteriormente]
    p.movil = CASE WHEN row.CTOR_MOVIL IS NOT NULL THEN row.CTOR_MOVIL ELSE p.movil END,
    p.fax = CASE WHEN row.CTOR_FAX IS NOT NULL THEN row.CTOR_FAX ELSE p.fax END,
    p.email = CASE WHEN row.CTOR_EMAIL IS NOT NULL THEN row.CTOR_EMAIL ELSE p.email END;

// 5.5 Crear relaciones (Vehiculo)-[:INTERVIENE_COMO_ASEGURADO_EN]->(Siniestro)
CALL apoc.load.xls(
    'file:///5_CONTRATOS_SINIESTROS_VEHICULOS_ASEGURADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.MATRICULA IS NOT NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (v:Vehiculo {matriculaVehiculo: row.MATRICULA})
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MERGE (v)-[r:INTERVIENE_COMO_ASEGURADO_EN]->(s)
SET r.danyos = row.DANYOS;

// 5.6 Crear relaciones (Persona)-[:CONDUCE_VA_EN]->(Siniestro) (usando NOMBRE, APELLIDO1, APELLIDO2)
CALL apoc.load.xls(
    'file:///5_CONTRATOS_SINIESTROS_VEHICULOS_ASEGURADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NOT NULL AND row.CTOR_APELLIDO2 IS NOT NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (p:Persona {nombre: row.CTOR_NOMBRE, apellido1: row.CTOR_APELLIDO1, apellido2: row.CTOR_APELLIDO2})
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MERGE (p)-[r:CONDUCE_VA_EN]->(s)
SET r.matriculaVehiculo = CASE WHEN row.MATRICULA IS NOT NULL THEN row.MATRICULA ELSE r.matriculaVehiculo END;

// 5.7 Crear relaciones (Persona)-[:CONDUCE_VA_EN]->(Siniestro) (usando NOMBRE, APELLIDO1)
CALL apoc.load.xls(
    'file:///5_CONTRATOS_SINIESTROS_VEHICULOS_ASEGURADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NOT NULL AND row.CTOR_APELLIDO2 IS NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (p:Persona {nombre: row.CTOR_NOMBRE, apellido1: row.CTOR_APELLIDO1})
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MERGE (p)-[r:CONDUCE_VA_EN]->(s)
SET r.matriculaVehiculo = CASE WHEN row.MATRICULA IS NOT NULL THEN row.MATRICULA ELSE r.matriculaVehiculo END;

// 5.8 Crear relaciones (Persona)-[:CONDUCE_VA_EN]->(Siniestro) (usando NOMBRE)
CALL apoc.load.xls(
    'file:///5_CONTRATOS_SINIESTROS_VEHICULOS_ASEGURADOS.xlsx',
    'Hoja1',
    {
        header: true
    }
) YIELD map as row
WHERE row.CTOR_NOMBRE IS NOT NULL AND row.CTOR_APELLIDO1 IS NULL AND row.CTOR_APELLIDO2 IS NULL AND row.ID_SINIESTRO IS NOT NULL
MATCH (p:Persona {nombre: row.CTOR_NOMBRE})
MATCH (s:Siniestro {idSiniestro: row.ID_SINIESTRO})
MERGE (p)-[r:CONDUCE_VA_EN]->(s)
SET r.matriculaVehiculo = CASE WHEN row.MATRICULA IS NOT NULL THEN row.MATRICULA ELSE r.matriculaVehiculo END;