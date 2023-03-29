CREATE TABLE EMPLEADOS (
	DNI int(8) PRIMARY KEY,
    NOMBRE varchar(10) NOT NULL,
    APELLIDO1 varchar(15) NOT NULL,
    APELLIDO2 varchar(15),
    DIRECC1 varchar(25),
    DIRECC2 varchar(20),
    CIUDAD varchar(20),
    PROVINCIA varchar(20),
    COD_POSTAL varchar(5),
    SEXO enum("M","H"),
    FECHA_NAC DATE
    
);

CREATE TABLE DEPARTAMENTOS (
	DPTO_COD int(5) PRIMARY KEY,
    NOMBRE_DPTO varchar(30) UNIQUE NOT NULL,
    DPTO_PADRE int(5),
    PRESUPUESTO int NOT NULL,
    PRES_ACTUAL int

);

CREATE TABLE ESTUDIOS (
	EMPLEADO_DNI int(8) PRIMARY KEY,
    UNIVERSIDAD int(5),
    AÑO int,
    GRADO varchar(3),
    ESPECIALIDAD varchar(20),
    FOREIGN KEY (EMPLEADO_DNI) REFERENCES EMPLEADOS(DNI) on delete cascade on update cascade
    
);

CREATE TABLE TRABAJOS (
	TRABAJO_COD int(5) PRIMARY KEY,
	NOMBRE_TRAB VARCHAR(20) UNIQUE NOT NULL,
	SALARIO_MIN int(2)NOT NULL,
	SALARIO_MAX int(2) NOT NULL
    
);

CREATE TABLE HISTORIAL_LABORAL (
	EMPLEADO_DNI int(8) PRIMARY KEY,
	TRABAJO_COD int(5),
	FECHA_INICIO DATE,
	FECHA_FIN DATE,
	DPTO_COD int(5),
	SUPERVISOR_DNI int(8),
    TRABAJO_ACTUAL int(5),
    FOREIGN KEY (EMPLEADO_DNI) REFERENCES EMPLEADOS(DNI) on delete cascade on update cascade,
    FOREIGN KEY (TRABAJO_ACTUAL) REFERENCES TRABAJOS(TRABAJO_COD) on delete cascade on update cascade

);

CREATE TABLE UNIVERSIDADES (
	UNIV_COD int(5) PRIMARY KEY,
	NOMBRE_UNIV VARCHAR(25) NOT NULL,
	CIUDAD VARCHAR(20),
	MUNICIPIO VARCHAR(2),
	COD_POSTAL VARCHAR(5)

);

CREATE TABLE HISTORIAL_SALARIAL (
	EMPLEADO_DNI int(8) PRIMARY KEY,
	SALARIO int NOT NULL,
	FECHA_COMIENZO DATE,
	FECHA_FIN DATE,
    FOREIGN KEY (EMPLEADO_DNI) REFERENCES EMPLEADOS(DNI) on delete cascade on update cascade

);


INSERT into empleados VALUES (35595786,'David','Valles','Garcia','Calle Calderon Barca','n9 pta24','Valencia','Valencia','46010','H','1991-10-07');
INSERT into empleados VALUES (21008943,'Neus','Puig','Real','Calle Calderon Barca','n9 pta24','Valencia','Valencia','46010','M','1994-01-02');

INSERT into departamentos VALUES (13,'Desarrollo',1,150,50);
INSERT into departamentos VALUES (21,'Educacion',2,200,47);

INSERT into estudios VALUES (35595786,201,2013,'Ingenieria','Teleco');
INSERT into estudios VALUES (21008943,202,2017,'Magisterio','Matematicas');

INSERT into historial_laboral VALUES (35595786,6262,'2020-01-07','2023-03-28',13,13009051,1001);
INSERT into historial_laboral VALUES (21008943,6759,'2019-10-03','2023-03-28',21,21202266,1002);

INSERT into universidades VALUES (201,'UPV','Valencia','Valencia',46025);
INSERT into universidades VALUES (202,'CEU','Valencia','Valencia',46026);

INSERT into historial_salarial VALUES (35595786,1500,'2017-03-25',NULL);
INSERT into historial_salarial VALUES (21008943,1900,'2016-01-06',NULL);

INSERT into trabajos VALUES (1001,'Programador',1000,1300);
INSERT into trabajos VALUES (1002,'Profesor',1600,2000);


// 2.
INSERT INTO empleados (
nombre, apellido1, apellido2, dni, sexo )
VALUES (
'Sergio', 'Palma', 'Entrena', '111222', 'H') ;
INSERT INTO empleados (
nombre, apellido1, apellido2, dni, sexo)
VALUES (
'Lucia', 'Ortega', 'Plus', '222333', 'M') ;

// 3.
UPDATE historial_laboral SET SUPERVISOR_DNI=35595787 WHERE EMPLEADO_DNI=15595226

// 4.
ALTER TABLE estudios
 ADD CONSTRAINT fk_estudios_universidad
 FOREIGN KEY (universidad)
 REFERENCES universidades (univ_cod)
 ON DELETE SET NULL;

 // 5.

DROP TRIGGER IF EXISTS comprobarCP;
DELIMITER $$
CREATE TRIGGER comprobarCP BEFORE INSERT ON empleados
FOR EACH ROW
BEGIN
    IF NEW.ciudad is NOT null AND NEW.cod_postal is null THEN
        SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Al haber Ciudad debe insertar Codigo Postal!';
    END IF;
END
DELIMITER ;

// 6.
ALTER TABLE empleados
 ADD valoracion NUMBER DEFAULT 5 ;
ALTER TABLE empleados
 ADD CONSTRAINR ck_valoracion
 CHECK (valoración BETWEEN 1 AND 10) ;

// 7.
 ALTER TABLE empleados MODIFY nombre VARCHAR(10) NULL ;

// 8.
ALTER TABLE empleados MODIFY direcc1 VARCHAR(40) ;

// 9.
ALTER TABLE empleados MODIFY FECHA_NAC varchar(10) ; --> Si siempre que los datos ya introducidos sean compatible con el nuevo tipo de datos


// 10.
--> suponiendo que hubiesemos llamado a la constraint "pk_empleados"
ALTER TABLE empleados DROP CONSTRAINT pk_empleados ; --> Elimina la restriccion
ALTER TABLE empleados ADD CONSTRAINT pk_empleados PRIMARY KEY (nombre, apellido1, apellido2) ; --> añade una nueva restriccion


// 11.
CREATE TABLE información_universitaria
AS SELECT
    Concat (e.nombre, ' ', e.apellido1, ' ', e.apellido2) as Nombre_completo, 
    u.nombre_univ as Universidad 
FROM
    empleados as e,
    estudios as es,
    universidades as u
WHERE
    e.dni=es.empleado_dni
    AND es.universidad=u.univ_cod;

// 12.
CREATE VIEW nombre_empleados
AS SELECT
    Concat (e.nombre, ' ', e.apellido1, ' ', e.apellido2) as Nombre_completo
FROM
    empleados as e
WHERE
    e.provincia = 'Malaga'

// 13.
CREATE VIEW informacion_empleados
AS SELECT
    Concat (e.nombre, ' ', e.apellido1, ' ', e.apellido2) as Nombre_completo,
    round(DATEDIFF(NOW(), e.FECHA_NAC)/365) as Edad
FROM
    empleados as e

// 14.
CREATE VIEW informacion_actual
AS SELECT
    ie.Nombre_completo, 
    hs.salario
FROM
    informacion_empleados as ie,
    historial_salarial as hs
WHERE
    ie.dni=hs.empleado_dni --> no funciona por que en la vista "ie" no hay ningun campo llamado "dni"
    AND fecha_fin IS NULL;

