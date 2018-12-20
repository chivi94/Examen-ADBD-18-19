-- Titulares con licencias activas
SELECT T.nombre
FROM titular T NATURAL JOIN concesion C
WHERE C.fechaF IS NULL;

-- Historial de licencias de un puesto dado. Ej: Puesto 2
SELECT DISTINCT P.nro,C.dni,C.fechaI,C.fechaF
FROM puesto P NATURAL JOIN concesion C
WHERE P.nro = 2
ORDER BY C.fechaI ASC;

-- Número de licencias que ha tenido cada puesto:
-- Incluyendo las activas
SELECT P.nro, COUNT(*) AS numL
FROM puesto P NATURAL JOIN concesion C
GROUP BY P.nro;
-- Sin incluir las activas. Habría que añadir la siguiente cláusula
-- WHERE c.fechaF IS NOT NULL
-- Persona/s (dni, nombre) que al menos han tenido 2 infracciones
WITH NumInf AS (SELECT DISTINCT C.dni AS dni, COUNT(*) as numI
                FROM concesion C NATURAL JOIN sancion S
                GROUP BY C.dni
                HAVING COUNT(*)>2)
                
SELECT T.nombre, NI.dni,NI.numI
FROM titular T NATURAL JOIN NumInf NI;
