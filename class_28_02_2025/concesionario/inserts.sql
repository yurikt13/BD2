--clientes
insert into tipos_documentos (id_tipo_documento, nombre) values (1, 'Cedula de Ciudadania');
select * from tipos_documentos;
commit;

insert into clientes (identificacion, id_tipo_documento, nombres, primer_apellido, segundo_apellido, correo, celular) 
values ('112', 1, 'Yuri Alejandra', 'Monroy', 'Bautista', 'bangtantaejunk@gmail.com', '+573103604115');
commit;
select * from clientes;


--ventas

insert into estados_facturas (id_estado_factura, nombre) values (1, 'Emitida');
insert into estados_facturas (id_estado_factura, nombre) values (2, 'Anulada');
insert into estados_facturas (id_estado_factura, nombre) values (3, 'Validada');
insert into estados_facturas (id_estado_factura, nombre) values (4, 'En proceso');
commit;
select * from estados_facturas;

--insert into ventas (id_factura, uuid_dian, fecha_emision, valor_total, identificacion, id_estado_factura)
--values (1, null, TO_DATE('2025-03-06'), 125000000.50, '112', 1);
insert into ventas (id_factura, uuid_dian, fecha_emision, valor_total, identificacion, id_estado_factura)
values (1, null, SYSDATE, 0, '112', 4);
select * from ventas;
delete from ventas where id_factura=1;
commit;

--vehiculos
insert into marcas (id_marca, nombre) values (1, 'Toyota');
commit;
select * from marcas;

insert into modelos (id_modelo, nombre, id_marca) values (1, 'XE', 1);
commit;
select * from modelos;

insert into referencias (id_referencia, nombre, id_modelo, ano_ref) values (1, 'GG', 1, 2024);
commit;
select * from referencias;

insert into colores (id_color, nombre) values (1, 'Rojo');
commit;
select * from colores;

insert into estados_vehiculos (id_estado_vehiculo, nombre) values (1, 'Disponible');

insert into estados_vehiculos (id_estado_vehiculo, nombre) values (2, 'Vendido');
commit;
select * from estados_vehiculos;

insert into vehiculos (id_vehiculo, id_referencia, año, precio, id_color, vin, placa, id_estado_vehiculo, id_factura) 
values (1, 1, 2025, 60000000.10, 1, '1HGCM82633A123456', null,1, null);
commit;
select * from vehiculos;

