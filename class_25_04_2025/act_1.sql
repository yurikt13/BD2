--especificacion: encabezado, firma
CREATE OR REPLACE PACKAGE PKG_PRUEBA
AS
PROCEDURE P_PRUEBA;
FUNCTION F_PRUEBA return varchar2;
END PKG_PRUEBA;
/

--cuerpo: definir las funciones y procedure que se van a usar
CREATE OR REPLACE PACKAGE BODY pkg_prueba AS
PROCEDURE P_PRUEBA
IS
    BEGIN
        dbms_output.put_line(f_prueba);
    END;
FUNCTION F_PRUEBA
RETURN VARCHAR2
IS
respuesta varchar2(50);
    begin
        respuesta := 'Procedimientos PL/SQL-FUNCTION';
        return respuesta;
        EXCEPTION
        WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001, 'OCURRIO UN ERROR EN LA FUNCTION' || SQLCODE || ' --ERROR- ' || SQLERRM);
    end;
END pkg_prueba;
/


--utilizar paquete
begin
    pkg_prueba.p_prueba;
end;
/

begin
    pkg_prueba.p_prueba;
end;
/