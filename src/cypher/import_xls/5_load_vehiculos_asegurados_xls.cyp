// Load CONTRATOS_SINIESTROS_VEHICULOS_ASEGURADOS.xslx

// Remove nodes
MATCH (v:Vehiculo) DETACH DELETE v;

// Remove constraints
DROP CONSTRAINT Vehiculo_matriculaVehiculo IF EXISTS;

// Create Vehiculo constraints
CREATE CONSTRAINT Vehiculo_matriculaVehiculo IF NOT EXISTS
ON (v:Vehiculo)
REQUIRE v.matriculaVehiculo IS UNIQUE;

// Crear nodos de Siniestro antes?

// Create Vehiculo nodes
