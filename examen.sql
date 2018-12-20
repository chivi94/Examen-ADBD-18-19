-- script examen ADBD 2018-19
--   simplificado de la normativa Mercados Aljaraque
--
-- Puesto, Titular, Concesion, Sancion, 

-- DROPS
drop table Sancion;
drop table Concesion;
drop table Puesto;
drop table Titular;

-- CREATES
create table Puesto(
   nro integer,
   dimension integer not null,
   primary key( nro)
);

create table Titular(
   dni char(10),
   nombre char(25) not null,
   primary key (dni)
);

create table Concesion(
   cod char(10),
   fechai date not null,
   fechaf date,
   tipo char(3) not null,
   nro integer not null,
   dni char(10) not null,
   primary key (cod),
   foreign key (nro) references Puesto(nro),
   foreign key (dni) references Titular(dni),
   constraint ordenFechas check(fechai<fechaf)
);

create table Sancion(
   ref char(10),
   fecha date not null,
   cantidad integer not null,
   cod char(10) not null,
   primary key (ref),
   foreign key (cod) references Concesion(cod)
);

-- INSERTS

insert into Puesto values (1, 29);
insert into Puesto values (2, 26);
insert into Puesto values (3, 26);
insert into Puesto values (4, 22);
insert into Puesto values (5, 22);
insert into Puesto values (6, 31);
insert into Puesto values (7, 30);
insert into Puesto values (8, 28);
insert into Puesto values (9, 20);
insert into Puesto values (10, 19);

insert into Titular values ('086s', 'Dangelo');
insert into Titular values ('100d', 'Mateo');
insert into Titular values ('143q', 'Elsa');
insert into Titular values ('165u', 'Mohammad');
insert into Titular values ('168g', 'Brook');
insert into Titular values ('235k', 'Elroy');
insert into Titular values ('277a', 'Lavinia');
insert into Titular values ('285x', 'Owen');
insert into Titular values ('300a', 'Jesse');
insert into Titular values ('379k', 'Chyna');
insert into Titular values ('398g', 'Electa');
insert into Titular values ('444q', 'Tommie');
insert into Titular values ('475r', 'Jamel');
insert into Titular values ('481q', 'Mara');
insert into Titular values ('510c', 'Melvin');
insert into Titular values ('655w', 'Annie');
insert into Titular values ('721g', 'Noemy');
insert into Titular values ('796n', 'Rebeca');
insert into Titular values ('888j', 'Rubie');
insert into Titular values ('978y', 'Maegan');
 
insert into Concesion values ('c31', '1985-05-29', '1991-09-29', 'FRU', 1, '086s');
insert into Concesion values ('c93', '1995-09-27', '1996-08-21', 'ALI', 1, '086s');
insert into Concesion values ('c80', '1998-07-21', '1999-07-25', 'ULT', 1, '398g');
insert into Concesion values ('c75', '2015-11-06', '2016-08-27', 'ULT', 1, '398g');
insert into Concesion values ('c57', '2016-12-22', null        , 'ALI', 1, '086s');
insert into Concesion values ('c28', '1996-11-05', '1997-11-15', 'CAR', 2, '100d');
insert into Concesion values ('c69', '1998-10-12', '2008-09-05', 'ELE', 2, '444q');
insert into Concesion values ('c58', '2010-07-17', '2014-03-04', 'FRU', 2, '444q');
insert into Concesion values ('c40', '2015-03-30', '2016-09-06', 'ELE', 2, '100d');
insert into Concesion values ('c01', '2017-01-09', null        , 'FRU', 2, '100d');
insert into Concesion values ('c30', '2003-12-28', '2004-03-21', 'ALI', 3, '100d');
insert into Concesion values ('c74', '2005-10-21', '2006-09-27', 'ULT', 3, '475r');
insert into Concesion values ('c62', '2007-07-09', '2015-05-22', 'CAR', 3, '285x');
insert into Concesion values ('c94', '2016-08-27', '2016-10-28', 'ALI', 3, '475r');
insert into Concesion values ('c16', '2017-09-09', null        , 'FRU', 3, '143q');
insert into Concesion values ('c32', '1996-08-08', '2001-11-26', 'FRU', 4, '481q');
insert into Concesion values ('c72', '2002-10-08', '2009-08-24', 'ELE', 4, '165u');
insert into Concesion values ('c84', '2010-08-04', '2011-01-24', 'ELE', 4, '481q');
insert into Concesion values ('c10', '2011-10-10', '2015-08-29', 'CAR', 4, '165u');
insert into Concesion values ('c15', '2016-05-14', null        , 'ELE', 4, '165u');
insert into Concesion values ('c36', '2000-07-03', '2004-08-10', 'FRU', 5, '168g');
insert into Concesion values ('c82', '2005-04-04', '2006-12-05', 'FRU', 5, '510c');
insert into Concesion values ('c55', '2010-12-08', '2014-04-04', 'CAR', 5, '168g');
insert into Concesion values ('c96', '2015-04-12', '2017-07-05', 'ULT', 5, '510c');
insert into Concesion values ('c09', '2017-08-04', null        , 'CAR', 5, '168g');
insert into Concesion values ('c00', '1973-07-23', '1987-12-01', 'FRU', 6, '655w');
insert into Concesion values ('c65', '1988-04-10', '2012-10-17', 'FRU', 6, '235k');
insert into Concesion values ('c34', '2012-11-06', '2013-01-17', 'FRU', 6, '235k');
insert into Concesion values ('c43', '2015-10-10', '2016-06-20', 'FRU', 6, '235k');
insert into Concesion values ('c04', '2017-11-22', '2018-01-03', 'FRU', 6, '655w');
insert into Concesion values ('c02', '2009-09-21', '2010-12-19', 'ALI', 7, '277a');
insert into Concesion values ('c47', '2011-05-27', '2012-03-25', 'ULT', 7, '721g');
insert into Concesion values ('c73', '2012-09-17', '2014-01-24', 'FRU', 7, '277a');
insert into Concesion values ('c06', '2014-12-23', '2015-11-04', 'ELE', 7, '721g');
insert into Concesion values ('c85', '2016-10-14', null        , 'CAR', 7, '277a');
insert into Concesion values ('c87', '1975-08-01', '1993-02-21', 'ULT', 8, '796n');
insert into Concesion values ('c19', '2006-12-06', '2007-07-19', 'CAR', 8, '285x');
insert into Concesion values ('c81', '2008-03-25', '2010-02-14', 'ALI', 8, '796n');
insert into Concesion values ('c49', '2011-10-19', '2013-02-13', 'FRU', 8, '655w');
insert into Concesion values ('c39', '2014-01-20', null        , 'FRU', 8, '285x');
insert into Concesion values ('c71', '1975-08-06', '1995-12-03', 'ELE', 9, '300a');
insert into Concesion values ('c76', '2010-07-12', '2011-01-13', 'FRU', 9, '888j');
insert into Concesion values ('c89', '2012-03-13', '2012-10-23', 'ELE', 9, '888j');
insert into Concesion values ('c90', '2013-06-23', '2014-02-11', 'ULT', 9, '300a');
insert into Concesion values ('c98', '2016-01-24', '2017-12-13', 'ELE', 9, '300a');
insert into Concesion values ('c17', '1990-07-12', '2008-08-27', 'ELE', 10, '379k');
insert into Concesion values ('c26', '2009-03-20', '2009-03-28', 'FRU', 10, '285x');
insert into Concesion values ('c29', '2010-03-20', '2011-03-28', 'FRU', 10, '379k');
insert into Concesion values ('c60', '2011-05-11', '2012-08-07', 'ULT', 10, '978y');
insert into Concesion values ('c27', '2013-03-18', '2015-02-25', 'CAR', 10, '379k');
insert into Concesion values ('c68', '2015-05-30', null        , 'ULT', 10, '978y');

insert into Sancion values ('s001', '1997-03-11', 100, 'c15');
insert into Sancion values ('s155', '2001-04-21', 200, 'c49');
insert into Sancion values ('s172', '1978-04-19', 150, 'c16');
insert into Sancion values ('s192', '1982-07-27', 200, 'c28');
insert into Sancion values ('s241', '2009-09-08', 100, 'c39');
insert into Sancion values ('s242', '2009-09-09', 100, 'c39');
insert into Sancion values ('s256', '2001-05-10', 250, 'c17');
insert into Sancion values ('s301', '1982-09-15', 250, 'c40');
insert into Sancion values ('s394', '2001-07-24', 100, 'c36');
insert into Sancion values ('s434', '1995-12-06', 250, 'c09');
insert into Sancion values ('s488', '1982-01-15', 150, 'c26');
insert into Sancion values ('s541', '1978-03-01', 200, 'c19');
insert into Sancion values ('s545', '2004-08-07', 200, 'c04');
insert into Sancion values ('s571', '1987-04-19', 200, 'c00');
insert into Sancion values ('s586', '1998-07-21', 150, 'c10');
insert into Sancion values ('s615', '1983-08-30', 150, 'c06');
insert into Sancion values ('s638', '2007-08-09', 100, 'c47');
insert into Sancion values ('s653', '1985-03-21', 100, 'c30');
insert into Sancion values ('s743', '2002-08-28', 100, 'c34');
insert into Sancion values ('s753', '2011-11-13', 250, 'c43');
insert into Sancion values ('s773', '2007-11-09', 250, 'c27');
insert into Sancion values ('s799', '2007-09-20', 250, 'c01');
insert into Sancion values ('s867', '2010-12-08', 200, 'c55');
insert into Sancion values ('s884', '2005-10-06', 200, 'c32');
insert into Sancion values ('s974', '1972-06-24', 250, 'c02');
insert into Sancion values ('s978', '1971-05-21', 100, 'c31');
insert into Sancion values ('s979', '2000-07-03', 100, 'c36');
