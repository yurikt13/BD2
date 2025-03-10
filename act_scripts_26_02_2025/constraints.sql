--start F:/BD2/act_scripts_26_02_2025/constraints.sql

prompt Creando reglas empleados
-- clave primaria empleados
ALTER TABLE empleados
ADD CONSTRAINT empleados_identificacion_pk PRIMARY KEY(identificacion);

-- clave foranea empleados
alter table empleados
add CONSTRAINT empleados_jefe_fk FOREIGN KEY (jefe) REFERENCES empleados(identificacion);

-- Restricción NOT NULL empleados
ALTER TABLE empleados
ADD CONSTRAINT empleados_nombres_nn CHECK(nombres is not null);

ALTER TABLE empleados
ADD CONSTRAINT empleados_primer_apellido_nn CHECK(primer_apellido is not null);

ALTER TABLE empleados
ADD CONSTRAINT empleados_correo_personal_nn CHECK(correo_personal is not null);

ALTER TABLE empleados
ADD CONSTRAINT empleados_correo_empresarial_nn CHECK(correo_empresarial is not null);

ALTER TABLE empleados
ADD CONSTRAINT empleados_fecha_nacimiento_nn CHECK(fecha_nacimiento is not null);

ALTER TABLE empleados
ADD CONSTRAINT empleados_nacionalidad_nn CHECK(nacionalidad  is not null);

-- Reglas CHECK empleados
alter table empleados
ADD CONSTRAINT empleados_correos_diferentes CHECK (correo_personal <> correo_empresarial);

--alter table empleados
--ADD CONSTRAINT empleados_mayor_edad CHECK (TRUNC(MONTHS_BETWEEN(SYSDATE, fecha_nacimiento) / 12) >= 18);

alter table empleados
ADD CONSTRAINT empleados_nacionalidad_colombiana CHECK (nacionalidad = 'Colombiana');

-- índice unico empleados
--create unique index empleados_correo_empresarial_ind on empleados(correo_empresarial);
ALTER TABLE empleados
ADD CONSTRAINT empleados_correo_empresarial_uk UNIQUE (correo_empresarial);



prompt Creando reglas novedades_empleados

-- clave primaria novedades_empleados
ALTER TABLE novedades_empleados
ADD CONSTRAINT novedades_empleados_codigo_pk PRIMARY KEY (codigo);

-- claves foraneas novedades_empleados
alter table novedades_empleados
ADD CONSTRAINT novedades_empleados_identificacion_fk FOREIGN KEY (identificacion) REFERENCES empleados(identificacion);

-- claves foraneas novedades_empleados
alter table novedades_empleados
ADD CONSTRAINT novedades_empleados_correo_empresarial_fk FOREIGN KEY (correo_empresarial) REFERENCES empleados(correo_empresarial);


-- Restricción NOT NULL novedades_empleados
ALTER TABLE novedades_empleados
ADD CONSTRAINT novedades_empleados_identificacion_nn CHECK(identificacion is not null);

ALTER TABLE novedades_empleados
ADD CONSTRAINT novedades_empleados_correo_empresarial_nn CHECK(correo_empresarial is not null);

ALTER TABLE novedades_empleados
ADD CONSTRAINT novedades_empleados_fecha_creado_nn CHECK(fecha_creado is not null);

