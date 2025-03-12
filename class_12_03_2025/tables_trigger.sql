create table ventas (
    id_venta numeric(4),
    fecha_venta date
);
select * from ventas;


create table parametros (
	creacion_empresa date
);
select * from parametros;
delete from parametros;
insert into parametros (creacion_empresa) values (to_date('12-03-2018'));
commit;

select to_date('12-03-2018') from dual;

drop table errores;
create table errores (
	codigo varchar2(6),
	nombre varchar2(100),
	descripcion varchar(200)
);
select * from errores;
insert into errores (codigo, nombre, descripcion) values (-20002, 'Fecha de creacion_empresa nula.', 'Validar que la fecha de la empresa este registrada en la tabla parametros');

create or replace trigger tg_ventas
before insert
on ventas
for each row
declare
	creacion_empresa parametros.creacion_empresa%TYPE;
    
begin
    
	select creacion_empresa
	into creacion_empresa
	from parametros;
    
    if (new.fecha_venta > creacion_empresa) then
        -- insertar
        begin
        exception
        --fecha de venta no valida
        end;
    end if;

exception 
    when no_data_found then
    
    declare
        problema_02 errores%rowtype;
    begin
        select *
        into problema_02
        from errores
        where codigo = 20002;
        
        raise_application_error(problema_02.codigo,problema_02.nombre || 'Detalle: ' || problema_02.descripcion);
        
    exception
        when no_data_found then
            raise_application_error(-20001, 'Mal parametrizacion de errores.');
    end;

end;
/