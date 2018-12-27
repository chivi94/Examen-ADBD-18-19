--  1 --
SELECT T.nombre
FROM titular T NATURAL JOIN concesion C
WHERE C.fechaF IS NULL;

-- 2 --
SELECT DISTINCT P.nro,C.dni,C.fechaI,C.fechaF
FROM puesto P NATURAL JOIN concesion C
WHERE P.nro = 2
ORDER BY C.fechaI ASC;

-- 3 -- 
SELECT P.nro, COUNT(*) AS numL
FROM puesto P NATURAL JOIN concesion C
GROUP BY P.nro;

-- 4 --
--Habría que añadir la siguiente cláusula
-- WHERE c.fechaF IS NOT NULL

-- 5 -- 
WITH sancionesActualesTitular AS(
    SELECT T.dni, COUNT(*) AS numSanciones
    FROM Titular T, Concesion C, Sancion S
    WHERE T.dni = C.dni AND
          C.cod = S.cod AND
          C.fechaF IS NULL
    GROUP BY T.dni
)

SELECT T.nombre
FROM Titular T, Concesion C
WHERE T.dni NOT IN (SELECT ST.dni
                       FROM sancionesActualesTitular ST) AND
      T.dni = C.dni AND
      C.fechaF IS NULL;

-- 6 --
    -- * Planteamiento

        -- ConcActivas : Concesiones con fechaF IS null
        -- Nsanciones : COUNT(*) Titular con dni = ConcActivas.dni, Sanciones con cod = ConcActivas.cod , GRUOP BY dni
        -- Comparar Nsanciones con Nsanciones y quedarse con las tuplas que verifiquen que el número de tuplas con mas sanciones
        -- es menor que 5.

    -- * SQL 

    WITH ConcActivas AS (SELECT * 
                         FROM Concesion C 
                         WHERE C.fechaF IS null),

    Nsanciones AS (SELECT T.dni,T.nombre, COUNT(*) as nsan
                   FROM Titular T, ConcActivas CA, Sancion S 
                   WHERE T.dni = CA.dni AND S.cod = CA.cod
                   GROUP BY T.dni)
                
    SELECT Ns.nombre, Ns.nsan
    FROM Nsanciones Ns 
    WHERE 5 > (SELECT COUNT(*)
               FROM Nsanciones Ns2
               WHERE Ns2.nsan > Ns.nsan);

-- 7 --
    --* Planteamiento 

        -- SELECT C.nro, C.fechaI, C.fechaF, T.nombre 
        -- C.dni = T.dni
        -- ORDER BY C.nro DESC, C.fechaI ASC

    --* SQL

    SELECT C.nro as Puesto, C.fechaI as Fecha_inicio, C.fechaF as Fecha_fin, T.nombre
    FROM Concesion C, Titular T 
    WHERE C.dni = T.dni 
    ORDER BY C.nro DESC, C.fechaI ASC;
                                                         
-- 8 --
SELECT T.nombre,COUNT(*) AS num_sanciones
FROM Titular T
	JOIN Concesion C ON T.dni = C.dni
	JOIN Sancion S ON C.cod = S.cod
WHERE
	'2011-12-31' >= S.fecha AND
	'2011-01-01' <= S.fecha
GROUP BY T.nombre;

-- Otra opción, sin el nombre del titular --
SELECT C.dni, S.ref, S.fecha,S.cantidad
FROM concesion C NATURAL JOIN sancion S
WHERE EXTRACT(YEAR FROM S.fecha) = 2011;

-- Con el nombre --
SELECT T.nombre,C.dni, S.ref, S.fecha,S.cantidad
FROM titular T, concesion C, sancion S
WHERE T.dni = C.dni AND C.cod = S.cod AND
      EXTRACT(YEAR FROM S.fecha) = 2011;

-- 9 --
WITH SancionesPuesto AS (
	SELECT C.nro,COUNT(*) as num_sanciones
	FROM concesion C NATURAL JOIN sancion S
	GROUP BY C.nro
)
SELECT SP.nro, SP.num_sanciones
FROM SancionesPuesto SP
WHERE
	SP.num_sanciones >= ALL(
		SELECT SP2.num_sanciones
		FROM SancionesPuesto SP2
	)
;
							 
-- 10 --
WITH NPuestosTit AS( SELECT C.dni, COUNT(DISTINCT C.nro) as npt
  		     FROM Concesion C
                     GROUP BY C.dni)
SELECT T.nombre,NP.npt
FROM Titular T, NPuestosTit NP
WHERE T.dni=NP.dni AND NP.npt >=ALL(SELECT NP2.npt
    				    FROM NPuestosTit NP2);

-- 11 --
WITH duracionConcesion AS(
    SELECT C.cod, C.dni, C.fechaF - C.fechaI AS duracion
    FROM Concesion C
)
SELECT T.nombre, DC.duracion
FROM Titular T, duracionConcesion DC
WHERE T.dni = DC.dni AND
      DC IS NOT NULL AND
      5 > (SELECT COUNT(*)
           FROM duracionConcesion DC2
           WHERE DC2.duracion > DC.duracion);

-- 12 --
SELECT T.nombre, S.ref, S.fecha
FROM Titular T, Concesion C, Sancion S
WHERE T.dni = C.dni AND
      C.cod = S.cod AND
      S.fecha >= DATE('2000-1-1') AND
      S.fecha < DATE('2011-1-1')
ORDER BY S.fecha;

-- 13 --
WITH sancionesTitular AS(
    SELECT T.dni, COUNT(*) AS numSanciones
    FROM Titular T, Concesion C, Sancion S
    WHERE T.dni = C.dni AND
          C.cod = S.cod
    GROUP BY T.dni
)

SELECT T.nombre
FROM Titular T
WHERE T.dni NOT IN (SELECT ST.dni
                       FROM sancionesTitular ST);

-- 14 --
WITH sancionesTitularCantidades AS(
    SELECT T.dni, S.cantidad
    FROM Titular T, Concesion C, Sancion S
    WHERE T.dni = C.dni AND
          C.cod = S.cod
)

SELECT T.nombre, SUM(STC.cantidad)
FROM Titular T, sancionesTitularCantidades STC
WHERE T.dni = STC.dni
GROUP BY T.dni;

-- 15 --
WITH sancionesTitularCantidades AS(
    SELECT T.dni, S.cantidad
    FROM Titular T, Concesion C, Sancion S
    WHERE T.dni = C.dni AND
          C.cod = S.cod
)

SELECT T.nombre, AVG(STC.cantidad)
FROM Titular T, sancionesTitularCantidades STC
WHERE T.dni = STC.dni
GROUP BY T.dni;

-- 16 --
SELECT C.cod, C.fechaF - C.fechaI AS Duracion
FROM Concesion C
WHERE C.fechaF - C.fechaI = (SELECT MAX(C2.fechaF - C2.fechaI)
                             FROM Concesion C2);
			     
-- 17 -- 
WITH NumInf AS (SELECT DISTINCT C.dni AS dni, COUNT(*) as numI
                FROM concesion C NATURAL JOIN sancion S
                GROUP BY C.dni
                HAVING COUNT(*)>2)
                
SELECT T.nombre, NI.dni,NI.numI
FROM titular T NATURAL JOIN NumInf NI;




