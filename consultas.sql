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
    -- Persona/s (dni, nombre) que al menos han tenido 2 infracciones
WITH NumInf AS (SELECT DISTINCT C.dni AS dni, COUNT(*) as numI
                FROM concesion C NATURAL JOIN sancion S
                GROUP BY C.dni
                HAVING COUNT(*)>2)
                
SELECT T.nombre, NI.dni,NI.numI
FROM titular T NATURAL JOIN NumInf NI;


-- 5 -- 
    -- * Planteamiento 

        -- concActivasLimpias : Concesiones con fechaF IS null  y cod NOT IN Sancion.cod
        -- Nombre del Titular con dni IN concActivasLimpias.dni

    -- * SQL 

    WITH ConcActivasLimpias AS ( SELECT C.dni 
                                 FROM Concesion C
                                 WHERE C.fechaF IS null 
                                       AND C.cod NOT IN (SELECT S.cod FROM Sancion S))
    
    SELECT T.nombre
    FROM Titular T natural join ConcActivasLimpias CAL;

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

-- 9 --
WITH SancionesPuesto AS (
	SELECT P.nro,COUNT(*) as num_sanciones
	FROM Puesto P
		NATURAL JOIN Concesion
		NATURAL JOIN Sancion
	GROUP BY P.nro
)
SELECT SP.nro, SP.num_sanciones
FROM SancionesPuesto SP
WHERE
	SP.num_sanciones >= ALL(
		SELECT SP2.num_sanciones
		FROM SancionesPuesto SP2
	)
;



