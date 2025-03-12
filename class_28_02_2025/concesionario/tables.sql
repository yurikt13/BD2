-- FALTA: AGREGAR CONTRAINTS NOT NULL A TODO

-- Permitir outputs
set serveroutput on;

--clientes
create table tipos_documentos (
    id_tipo_documento number(4),
    nombre varchar2(30)
);
alter table tipos_documentos
add constraint pk_tipos_documentos_id_tipo_documento primary key(id_tipo_documento);

create table clientes (
    identificacion varchar2(15),
    id_tipo_documento number(4),
    nombres varchar2(100),
    primer_apellido varchar2(50),
    segundo_apellido varchar2(50),
    correo varchar2(100),
    celular varchar2(15)
);
alter table clientes
add constraint pk_clientes_identificacion primary key(identificacion);
alter table clientes
add CONSTRAINT fk_clientes_id_tipo_documento FOREIGN KEY (id_tipo_documento) REFERENCES tipos_documentos(id_tipo_documento);


--ventas
create table estados_facturas (
    id_estado_factura number(4),
    nombre varchar2(15)
);
alter table estados_facturas
add constraint pk_estados_facturas_id_estado_factura primary key(id_estado_factura);

create table ventas (
    id_factura varchar2(50),
    uuid_dian varchar2(100),
    fecha_emision date,
    valor_total number(15, 2),
    identificacion varchar2(15),
    id_estado_factura number(4)
    --vehiculos_vendidos VARCHAR2(500)
);
alter table ventas
add constraint pk_ventas_id_factura primary key(id_factura);
alter table ventas
add constraint fk_ventas_identificacion foreign key (identificacion) references clientes(identificacion);
alter table ventas
add constraint fk_ventas_id_estado_factura foreign key (id_estado_factura) references estados_facturas(id_estado_factura);
--alter table ventas
--drop column vehiculos_vendidos;

--seq
drop sequence seq_ventas_id_factura;
CREATE SEQUENCE seq_ventas_id_factura
START WITH 1
INCREMENT BY 1
NOCACHE NOCYCLE;

--vehiculos
create table marcas (
    id_marca number(4),
    nombre varchar2(15)
);
alter table marcas
add constraint pk_marcas_id_marca primary key(id_marca);

create table modelos (
    id_modelo number(4),
    nombre varchar2(15),
    id_marca number(4)
);
alter table modelos
add constraint pk_modelos_id_modelo primary key(id_modelo);
alter table modelos
add CONSTRAINT fk_modelos_id_marca FOREIGN KEY (id_marca) REFERENCES marcas(id_marca);

create table referencias (
    id_referencia number(4), 
    nombre varchar2(15),
    id_modelo number(4),
    ano_ref number(4)
);
alter table referencias
add constraint pk_referencias_id_referencia primary key(id_referencia);
alter table referencias
add CONSTRAINT fk_referencias_id_modelo FOREIGN KEY (id_modelo) REFERENCES modelos(id_modelo);

create table colores (
    id_color number(4),
    nombre varchar2(15)
);
alter table colores
add constraint pk_colores_id_color primary key(id_color);

create table estados_vehiculos (
    id_estado_vehiculo number(4),
    nombre varchar2(15)
);
alter table estados_vehiculos
add constraint pk_estados_vehiculos_id_estado_vehiculo primary key(id_estado_vehiculo);

select * from estados_vehiculos;

create table vehiculos (
    id_vehiculo number(4),
    id_referencia number(4),
    ano_veh number(4),
    precio number(10, 2),
    id_color number(4),
    vin varchar2(17),
    placa varchar2(6),
    id_estado_vehiculo number(4),
    id_factura varchar2(50)
);
alter table vehiculos
add constraint pk_vehiculos_id_vehiculo primary key(id_vehiculo);
alter table vehiculos
add constraint fk_vehiculos_id_referencia foreign key (id_referencia) references referencias(id_referencia);
alter table vehiculos
add constraint fk_vehiculos_id_color foreign key (id_color) references colores(id_color);
alter table vehiculos
add constraint fk_vehiculos_id_estado_vehiculo foreign key (id_estado_vehiculo) references estados_vehiculos(id_estado_vehiculo);
alter table vehiculos
add constraint fk_vehiculos_id_factura foreign key (id_factura) references ventas(id_factura);
alter table vehiculos
add constraint uk_vehiculos_vin unique (vin);
alter table vehiculos
add constraint uk_vehiculos_placa unique (placa);
