CREATE OR REPLACE TRIGGER trg_empleados_mayor_edad
BEFORE INSERT OR UPDATE ON empleados
FOR EACH ROW
BEGIN
    IF TRUNC(MONTHS_BETWEEN(SYSDATE, :NEW.fecha_nacimiento) / 12) < 18 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El empleado debe ser mayor de edad.');
    END IF;
END;
/
