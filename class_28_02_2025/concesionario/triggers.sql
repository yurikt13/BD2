--v1
create or replace trigger tg_ventas
after insert
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


--v2
alter table ventas
add column vehiculos_vendidos VARCHAR2(500);

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

insert into ventas (id_factura, uuid_dian, fecha_emision, valor_total, identificacion, id_estado_factura, vehiculos_vendidos)
values (1, null, TO_DATE('2025-03-06'), 125000000.50, '112', 1, '1');

