--start F:/BD2/act_scripts_26_02_2025/create_tables.sql

CREATE TABLE empleados (
	identificacion VARCHAR2(15),
	nombres VARCHAR2(100),
	primer_apellido VARCHAR2(50),
	segundo_apellido VARCHAR2(50),
	correo_personal VARCHAR2(100),
	correo_empresarial VARCHAR2(100),
	celular VARCHAR2(15),
	fecha_nacimiento DATE,
	nacionalidad VARCHAR2(50),
	jefe VARCHAR2(15)
);

CREATE TABLE novedades_empleados (
	codigo number(4),
	identificacion VARCHAR2(15),
	correo_empresarial VARCHAR2(100),
	fecha_creado DATE DEFAULT SYSDATE
	--fecha_creado TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);