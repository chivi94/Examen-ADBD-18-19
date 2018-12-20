# Examen ADBD 18-19
Consultas previas realizadas con el esquema relacional del examen de la asignatura, curso 18-19

## Instrucciones dadas por Manuel
El esquema es una simplificación del realizado en las prácticas de los mercados de Aljaraque.
El examen se realizará con el esquema tal cual se describe aquí, y no se pueden hacer suposiciones basadas en cómo es la normativa real de los mercados de Aljaraque.
Por motivos de formato en moodle, las claves primarias aparecen en negrita y las foráneas en cursiva. No aparecen las flechas de referencia de las claves foráneas, siendo en este caso por coincidencia del nombre del atributo y en dirección clave foránea --> clave primaria.
Los datos que se cargan en el script son orientativos y en el examen podría haber alguna modificación de los datos (no del esquema)
Esquema: claves primarias en negrita; foráneas en cursiva apuntando a las primarias con la misma denominación
Restricciones: fechaI < fechaF;  una concesión es activa cuando es nula la fechaF; tipo es un string enumerado de posibles valores 'FRU', 'ALI', 'CAR', 'ELE', 'ULT'

- Puesto (**nro**, dimension)               

- Titular(**dni**, nombre)

- Concesion(**cod**, fechaI, fechaF, tipo, *nro*, *dni*)

- Sancion(**ref**, fecha, cantidad, *cod*)
