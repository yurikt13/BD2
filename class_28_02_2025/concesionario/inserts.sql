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
insert into estados_facturas (id_estado_factura, nombre) values (2, 'Validada');
insert into estados_facturas (id_estado_factura, nombre) values (3, 'Anulada');
commit;
select * from estados_facturas;
/*
insert into ventas (id_factura, uuid_dian, fecha_emision, valor_total, identificacion, id_estado_factura)
values (1, null, SYSDATE, 0, '112', 4);

delete from ventas where id_factura=1;
commit;
*/
select * from ventas;

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

insert into vehiculos (id_vehiculo, id_referencia, ano_veh, precio, id_color, vin, placa, id_estado_vehiculo, id_factura) 
values (3, 1, 2024, 80000000.10, 1, '1HGCM82633A123451', null,1, null);
commit;
select * from vehiculos;


select count(*), sum(precio)
   -- into vh_count
    from vehiculos
    where id_vehiculo in (1, 2)
    and id_estado_vehiculo = 1;
