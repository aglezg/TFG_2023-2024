/** 
 * 8. Siniestros ocurridos de madrugada:
 *    Siniestros que ocurren entre las 00:00 y las 08:00 horas.
 **/
MATCH (s:Siniestro)
WHERE
  time("00:00") <= s.horaOcurrencia <= time("08:00")
RETURN 
  s.idSiniestro, s.horaOcurrencia;