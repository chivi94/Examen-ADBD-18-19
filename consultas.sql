--  1 --
SELECT DISTINCT T.nombre
FROM titular T NATURAL JOIN concesion C
WHERE C.fechaF IS NULL;

-- 2 --
SELECT C.nro,C.dni,C.fechaI,C.fechaF
FROM concesion C
WHERE C.nro = 2
ORDER BY C.fechaI ASC;

-- 3 -- 
SELECT C.nro, COUNT(*) AS numL
FROM concesion C
GROUP BY C.nro;

-- 4 --

    --Habría que añadir la siguiente cláusula
    -- WHERE c.fechaF IS NOT NULL

-- 5 -- 

--Planteamiento 
-- Tablas base necesarias Sancion, Titular y Concesion 
-- dni IN ( (dnis de titulares actules) - (dnis de titulares con alguna sancion) )


-- SQL 

     SELECT T.nombre
    FROM Titular T 
    WHERE T.dni IN (SELECT DISTINCT C.dni 
                    FROM Concesion C 
                    WHERE C.fechaF IS NULL
                    EXCEPT 
                    SELECT DISTINCT C.dni 
                    FROM Concesion C NATURAL JOIN Sancion S 
                    WHERE C.fechaF IS NULL);

-- Otra forma --
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
      
-- Otra forma --
SELECT DISTINCT T.nombre
FROM Concesion C, Titular T
WHERE C.dni=T.dni AND C.fechaF IS NULL AND NOT EXISTS (
  SELECT *
  FROM Sancion S
  WHERE S.cod=C.cod);
  
  
-- Otra forma --
SELECT DISTINCT t.dni, t.nombre
FROM Concesion c NATURAL JOIN Titular t
WHERE c.fechaf IS NULL AND c.cod NOT IN (SELECT s.cod 
					 FROM Sancion s);

-- 6 --
   
--Planteamiento 
    -- Tablas base necesarias: Titular, Concesion, Sancion
    -- Titulares actuales -> Concesion.fechaF IS NULL 
    -- Tabla temporal TitularSanciones : dni | nsan (número de sanciones)
    -- Comparar las tuplas de TitularSanciones entre sí y seleccionar aquellas tuplas para las que existan 
    -- menos de 5 tuplas con nsan mayor que el suyo.

--SQL 

    WITH TitularSanciones AS (SELECT DISTINCT C.dni, COUNT(*) as nsan 
                                FROM Concesion C NATURAL JOIN Sancion S 
                                WHERE C.fechaF IS NULL 
                                GROUP BY C.dni)
        
    SELECT T.nombre, TS.nsan
    FROM Titular T NATURAL JOIN  TitularSanciones TS 
    WHERE 5 > (SELECT COUNT(*) 
                FROM TitularSanciones TS2 
                WHERE TS2.nsan > TS.nsan);


-- 6 otra version --
    WITH sancionesTitular AS(
        SELECT T.nombre, COUNT(*) as numS 
        FROM titular T
            NATURAL JOIN concesion C
            NATURAL JOIN sancion S
        WHERE C.fechaf IS NULL
        GROUP BY T.dni
        ORDER BY numS DESC
    )

    SELECT ST.nombre, ST.numS FROM sancionesTitular ST
    WHERE 5 > (SELECT COUNT(*) 
        FROM sancionesTitular ST2
        WHERE ST2.numS > ST.numS);

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
SELECT T.nombre, COUNT(*) AS num_sanciones
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
SELECT T.nombre, C.dni, S.ref, S.fecha, S.cantidad
FROM titular T, concesion C, sancion S
WHERE T.dni = C.dni AND C.cod = S.cod AND
      EXTRACT(YEAR FROM S.fecha) = 2011;

-- 9 --
WITH SancionesPuesto AS (
	SELECT C.nro, COUNT(*) as num_sanciones
	FROM concesion C NATURAL JOIN sancion S
	GROUP BY C.nro
)
SELECT SP.nro, SP.num_sanciones
FROM SancionesPuesto SP
WHERE  SP.num_sanciones >= ALL(
		SELECT SP2.num_sanciones
		FROM SancionesPuesto SP2);
							 
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

-- Otra Forma --
SELECT T.nombre, S.ref, S.fecha
FROM Titular T, Concesion C, Sancion S
WHERE T.dni = C.dni AND
      C.cod = S.cod AND
      EXTRACT(YEAR FROM S.fecha)>= 2000 AND
      EXTRACT(YEAR FROM S.fecha)< 2011
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

-- Otra forma --
SELECT T.nombre
FROM Titular T
WHERE T.dni NOT IN (SELECT C.dni 
                    FROM concesion C NATURAL JOIN sancion S);

-- 14 --
SELECT T.nombre, SUM(S.cantidad) as total
FROM titular T, concesion C, sancion S
WHERE T.dni = C.dni AND C.cod = S.cod
GROUP BY T.dni
ORDER BY total DESC;

-- 15 --
SELECT T.nombre, AVG(S.cantidad) as media
FROM titular T, concesion C, sancion S
WHERE T.dni = C.dni AND C.cod = S.cod
GROUP BY T.dni
ORDER BY media DESC;

-- 16 --
SELECT C.cod, C.fechaF - C.fechaI AS Duracion
FROM Concesion C
WHERE C.fechaF - C.fechaI = (SELECT MAX(C2.fechaF - C2.fechaI)
                             FROM Concesion C2);

-- Otra forma --
WITH Duracion AS (SELECT C.cod, C.fechaF - C.fechaI as dur
                  FROM concesion C
                  WHERE C.fechaF IS NOT NULL)

SELECT *
FROM Duracion D
WHERE D.dur >= ALL (SELECT D2.dur FROM Duracion D2);

-- 17 --
WITH NumInf AS (SELECT DISTINCT C.dni AS dni, COUNT(*) as numI
                FROM concesion C NATURAL JOIN sancion S
                GROUP BY C.dni
                HAVING COUNT(*)>=2)
                
SELECT T.nombre, NI.dni,NI.numI
FROM titular T NATURAL JOIN NumInf NI;

-- Otra forma --
SELECT DISTINCT T.*, COUNT(*) AS numInfracciones
FROM titular T, concesion C, sancion S
WHERE T.dni = C.dni AND C.cod = S.cod
GROUP BY T.dni
HAVING COUNT(*) >= 2;

-- 18 --
-- Planteamiento 
    -- Al utilizar las concesiones no se tienen en cuenta los puestos vacíos.
    -- Sólo actuales -> fechaF IS NULL
    -- Tabla TipoPuestos : tipo | np_actuales 
    -- Maximo -> dos roles de TipoPuestos,  TP1.np_actuales >=ALL TP2.np_actuales

-- SQL 

WITH TipoPuestos  AS (SELECT C.tipo, COUNT(*) AS np_actuales
                        FROM Concesion C
                        WHERE C.fechaF IS NULL
                        GROUP BY C.tipo)
                    
SELECT TP.tipo, TP.np_actuales
FROM TipoPuestos TP
WHERE TP.np_actuales >=ALL(SELECT TP2.np_actuales FROM TipoPuestos TP2);


--19 --
--Planteamiento 
    -- Al utilizar las concesiones no se tienen en cuenta los puestos vacíos.
    -- Sólo actuales -> fechaF IS NULL
    -- Porcentaje -> (subconsulta) np_actuales * 100 / COUNT(Concesion.tipo)  WHERE fechaF IS NULL

-- SQL 
SELECT C.tipo, COUNT(*) AS np_actuales, ( SELECT COUNT(C.tipo) * 100 / COUNT(C2.tipo) 
                                          FROM Concesion C2 
                                          WHERE C2.fechaF IS NULL) AS porcentaje
FROM Concesion C
WHERE C.fechaF IS NULL
GROUP BY C.tipo;

-- 20 -- 
-- Planteamiento 
    -- Al utilizar las concesiones no se tienen en cuenta los puestos vacíos.
    -- Sólo actuales -> fechaF IS NULL
    -- Tabla TipoPuestos : tipo | np_actuales | porcentaje 
    -- Maximo -> dos roles de TipoPuestos,  TP1.np_actuales >=ALL TP2.np_actuales

-- SQL 

WITH TipoPuestos  AS (SELECT C.tipo, COUNT(*) AS np_actuales, 
                        ( SELECT COUNT(C.tipo) * 100.00 / COUNT(C2.tipo) 
                        FROM Concesion C2 
                        WHERE C2.fechaF IS NULL) AS porcentaje
                        FROM Concesion C
                        WHERE C.fechaF IS NULL
                        GROUP BY C.tipo)
                    
SELECT TP.tipo, TP.np_actuales, Tp.porcentaje
FROM TipoPuestos TP
WHERE TP.np_actuales >=ALL(SELECT TP2.np_actuales FROM TipoPuestos TP2);


-- 21 --
-- Planteamiento 
    -- Sólo hace falta la tabla de Concesion
    -- Tabla DuracionConcesiones: nro | duracion (fruteria) (si fechaF IS NULL -> fechaf = CURRENT_DATE)
    -- SUM(duracion), GRUOP BY nro -> Tabla DuracionPuestos 
    -- MAXIMO de DuracionPuestos

-- SQL 

WITH  DuracionConcesiones AS (SELECT C.nro, (fechaF-fechaI) as duracion_dias
                                FROM Concesion C 
                                WHERE C.fechaF IS NOT NULL AND C.tipo = 'FRU'
                                UNION 
                                SELECT C.nro, (CURRENT_DATE-fechaI) as duracion_dias
                                FROM Concesion C 
                                WHERE C.fechaF IS  NULL AND C.tipo = 'FRU'),

        DuracionPuestos AS ( SELECT DC.nro, SUM(DC.duracion_dias) AS duracion_dias
                            FROM DuracionConcesiones DC
                            GROUP BY DC.nro)
SELECT DP.nro
FROM DuracionPuestos DP 
WHERE DP.duracion_dias >=ALL (SELECT DP2.duracion_dias FROM DuracionPuestos DP2);

-- 22 --
with CAct as( select C.cod, C.FechaF, C.tipo
              from Concesion C 
              where C.fechaF is null)

select N.tipo, N.cant*100.00/T.tot
from (select CA.tipo, count(*) as cant
      from CAct CA
      group by CA.tipo) N,
     (select count(*) as tot
  from CAct CA) T;

-- Otra forma -- 

 -- Planteamiento 
    -- fechaF is NULL
    -- Tabla Ntipos : tipo | nactuales 
    -- SELECT tipo, n_actuales * 100.00/ COUNT(concesiones actuales)
    
-- SQL 

WITH Ntipos AS ( SELECT DISTINCT C.tipo, COUNT(*) as nactuales
                FROM Concesion C 
                WHERE C.fechaF IS NULL 
                GROUP BY C.tipo)

SELECT N.tipo, N.nactuales * 100.00 / (SELECT COUNT(*) FROM Concesion C2 WHERE C2.fechaF is null) AS porcentaje
FROM Ntipos N;

-- 23 --
-- Planteamiento 
    -- COUNT(*), GRUOP BY year -> Tabla: year | nsanciones   con 2000 <= año <= 2010
    -- tasa = nsan / COUNT(*) Puesto ->  Tabla: year | tasa

--SQL 

WITH YearSanciones AS ( SELECT extract(year from S.fecha) as year, COUNT(*) as nsanciones
                        FROM Sancion S 
                        WHERE extract(year from S.fecha) >= 2000 AND extract(year from S.fecha) <= 2010
                        GROUP BY extract(year from S.fecha) )

SELECT YS.year, YS.nsanciones *1.00 / (SELECT COUNT(*) FROM Puesto P) as tasa
FROM YearSanciones YS;

-- 24 --

--Planteamiento 
    -- De las tablas base sólo es necesaria Concesion. 
    -- COUNT(DISTINCT Concesion.tipo), GROUP BY Concesion.tipo  -> Tabla NumTiposPuesto: nro | ntipos 
    -- Seleccionar las tuplas de NumTiposPuesto cuyo campo ntipos sea >= que todas las tuplas de NumTiposPuesto 

--SQL 

WITH NumTiposPuesto AS (SELECT C.nro, COUNT(DISTINCT C.tipo) as ntipos
                        FROM Concesion C
                        GROUP BY C.nro ) 

SELECT NTP.nro, NTP.ntipos
FROM NumTiposPuesto NTP 
WHERE NTP.ntipos >=ALL (SELECT NTP2.ntipos FROM NumTiposPuesto NTP2);

-- 25 --

--Planteamiento 
    --Tablas base necesarias: Concesion, Titular 
    -- Titulares con dni IN (dnis de titulares actuales) y NOT IN(dnis de titulares de una frutería)

-- SQL 

SELECT T.nombre 
FROM Titular T 
WHERE T.dni IN (SELECT DISTINCT C2.dni FROM Concesion C2 WHERE C2.fechaF IS NULL) AND 
      T.dni NOT IN (SELECT DISTINCT C.dni FROM Concesion C WHERE C.tipo='FRU');
