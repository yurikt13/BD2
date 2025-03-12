--v1
create or replace trigger tg_ventas
before insert
on ventas
for each row
declare
    new_id_factura number;
    
BEGIN
    --obtener siguiente valor de la secuencia
    select seq_ventas_id_factura.nextval into new_id_factura from dual;
    
    -- id_factura con codigo
    :NEW.id_factura := 'FACT-' || to_char(new_id_factura);
    
    EXCEPTION 
        WHEN OTHERS THEN
            raise_application_error(-20001, 'Se ha producido un error.');
END tg_ventas;
/


create or replace procedure registrar_venta (
    ids_vehiculos in sys.ODCINUMBERLIST,
    cl_identificacion in varchar2
) as
    vt_id_factura ventas.id_factura%TYPE;
    vt_valor_total ventas.valor_total%TYPE := 0;
    vh_count number;
    cl_validate number;
begin

    if ids_vehiculos.count = 0 or ids_vehiculos is null then
        RAISE_APPLICATION_ERROR(-20001, 'Debe proporcionar al menos un veh�culo.');
    end if;

    -- contar vehiculos disponibles y calcular valor total
    select count(*), sum(precio)
    into vh_count, vt_valor_total
    from vehiculos
    where id_vehiculo in (select column_value from table(ids_vehiculos))
    and id_estado_vehiculo = 1;
    
    -- validar que todos los vehiculos esten disponibles
    if vh_count != ids_vehiculos.COUNT THEN
        RAISE_APPLICATION_ERROR(-20002, 'Uno o m�s veh�culos no est�n disponibles.');
    END IF;
    
    -- validar que el cliente exista
    select count(*)
    into cl_validate
    from clientes
    where identificacion = cl_identificacion;
    
    if cl_validate = 0 then
        RAISE_APPLICATION_ERROR(-20003, 'El cliente no existe.');
    end if;
    
    -- insertar venta
    insert into ventas (uuid_dian, fecha_emision, valor_total, identificacion, id_estado_factura)
    values (null, SYSDATE, vt_valor_total, cl_identificacion, 1)
    returning id_factura into vt_id_factura;
    
    -- validar que la factura se haya generado y actualizar vehiculos con id_factura
    if vt_id_factura is not null then
        update vehiculos
        set id_factura = vt_id_factura,
        id_estado_vehiculo = 2
        where id_vehiculo in (select column_value from table(ids_vehiculos));
    else
        RAISE_APPLICATION_ERROR(-20004, 'Fall� al registrar la venta.');
    end if;
    
    commit;
exception 
    when others then
     rollback;
     raise;
end registrar_venta;
/


DECLARE
    ids_vehiculos SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();
BEGIN
    registrar_venta(ids_vehiculos, '112');
    DBMS_OUTPUT.PUT_LINE('Venta registrada correctamente.');
END;
/

select * from ventas;
select * from vehiculos;

delete from vehiculos where id_vehiculo in (1, 2, 3);
delete from ventas where id_factura in ('FACT-1', 'FACT-2');
commit;


--NOOO
CREATE OR REPLACE TRIGGER tg_ventas
BEFORE INSERT
ON ventas
FOR EACH ROW
DECLARE
    _id_factura VARCHAR2(50);
    _contador NUMBER;
BEGIN
    -- Generar ID de factura
    SELECT 'FACT-' || TO_CHAR(seq_ventas_id_factura.NEXTVAL) INTO _id_factura FROM dual;
    :NEW.id_factura := _id_factura;

    -- Validar que se han ingresado vehículos a vender
    IF :NEW.vehiculos_vendidos IS NULL OR LENGTH(:NEW.vehiculos_vendidos) = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Debe seleccionar al menos un vehículo para la venta.');
    END IF;

    -- Contar cuántos de los vehículos ingresados están disponibles
    SELECT COUNT(*)
    INTO _contador
    FROM vehiculos
    WHERE id_vehiculo IN (SELECT REGEXP_SUBSTR(:NEW.vehiculos_vendidos, '[^,]+', 1, LEVEL)
                          FROM dual
                          CONNECT BY REGEXP_SUBSTR(:NEW.vehiculos_vendidos, '[^,]+', 1, LEVEL) IS NOT NULL)
          AND id_estado_vehiculo = 1;

    -- Si no todos los vehículos están disponibles, lanzar error
    IF _contador <> (LENGTH(:NEW.vehiculos_vendidos) - LENGTH(REPLACE(:NEW.vehiculos_vendidos, ',', '')) + 1) THEN
        RAISE_APPLICATION_ERROR(-20004, 'Uno o más vehículos no están disponibles.');
    END IF;


    DBMS_OUTPUT.PUT_LINE('Factura generada: ' || :NEW.id_factura);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END tg_ventas;
/


CREATE OR REPLACE TRIGGER tg_ventas_update
after INSERT
ON ventas
FOR EACH ROW

DECLARE
    update_id_vehiculo number[];

BEGIN

    select into update_id_vehiculo
    from vehiculos
    where id_vehiculo in (
                SELECT REGEXP_SUBSTR(:NEW.vehiculos_vendidos, '[^,]+', 1, LEVEL)
                FROM dual
                CONNECT BY REGEXP_SUBSTR(:NEW.vehiculos_vendidos, '[^,]+', 1, LEVEL) IS NOT NULL
    );
    
    -- Actualizar los vehículos con el ID de la factura generada
    UPDATE vehiculos
    SET id_factura = :NEW.id_factura,
        id_estado_vehiculo = 2  -- Cambia el estado a "Vendido"
    WHERE id_vehiculo IN (SELECT REGEXP_SUBSTR(:NEW.vehiculos_vendidos, '[^,]+', 1, LEVEL)
                          FROM dual
                          CONNECT BY REGEXP_SUBSTR(:NEW.vehiculos_vendidos, '[^,]+', 1, LEVEL) IS NOT NULL);

    DBMS_OUTPUT.PUT_LINE('Vehiculo actualizado.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END tg_ventas;
/

--insert into ventas (id_factura, uuid_dian, fecha_emision, valor_total, identificacion, id_estado_factura, vehiculos_vendidos)
--values (1, null, TO_DATE('2025-03-06'), 125000000.50, '112', 1, '1');

