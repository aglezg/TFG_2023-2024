// Load CONTRATOS_SINIESTROS.csv file into Neo4j

// Removing nodes
MATCH (x:Siniestro) DETACH DELETE x;

// Removing CONSTRAINTS
DROP CONSTRAINT Siniestro_id IF EXISTS;

// Creating CONSTRAINTS
CREATE CONSTRAINT Siniestro_id IF NOT EXISTS
FOR (x:Siniestro)
REQUIRE x.id IS UNIQUE;

// Check
LOAD CSV WITH HEADERS FROM 'file:///CONTRATOS_SINIESTROS.csv' as row
WITH row WHERE row.ID_SINIESTRO IS NOT NULL
RETURN row.ID_SINIESTRO, toInteger(replace(row.ID_SINIESTRO, " ", "")) AS cleanedID;

// Creating "Siniestro" nodes
//LOAD CSV WITH HEADERS
//FROM 'file:///CONTRATOS_SINIESTROS.csv' as row
//WITH row WHERE row.ID_SINIESTRO IS NOT NULL
//MERGE (s:Siniestro {id: trim(replace(row.ID_SINIESTRO, '[^0-9]', ''))})
//SET
//    s.fechaOcurrencia = row.FCH_OCURRENCIA,
//    s.horaOcurrencia = time(row.HORA_OCURRENCIA),
//    s.fechaDeclaracion = row.FCH_DECLARACION,
//    s.responsabilidadCivil = row.RESPONSABILIDAD_CIVIL,
//    s.robo = row.ROBO,
//    s.incendio = row.INCENDIO,
//    s.lunas = row.LUNAS,
//    s.perdidaTotal = row.PERDIDA_TOTAL,
//    s.danyosPropios = row.DANYOS_PROPIOS,
//    s.defensa = row.DEFENSA,
//    s.lesionados = row.LESIONADOS,
//    s.indIntervieneAutoridad = row.IND_INTERVIENE_AUTORIDAD,
//    s.indAtestado = row.IND_ATESTADO,
//    s.indAlcohol = row.IND_ALCOHOL;