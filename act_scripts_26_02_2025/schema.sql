--start F:/BD2/act_scripts_26_02_2025/schema.sql

CLEAR SCREEN;
--ALTER DATABASE CLOSE;


prompt ====================================
prompt |   Esquema de la Base de Datos    |
prompt ====================================

connect system/123;

show con_name;

ALTER SESSION SET CONTAINER=CDB$ROOT;
ALTER DATABASE OPEN;

DROP TABLESPACE ts_ingreso INCLUDING CONTENTS and DATAFILES;

CREATE TABLESPACE ts_ingreso LOGGING
DATAFILE 'F:/BD2/act_scripts_26_02_2025/DB_ingreso.dbf' size 1m;

alter session set "_ORACLE_SCRIPT"=true; 


drop user us_usuario cascade;

CREATE user us_usuario profile default 
identified by 1234
default tablespace ts_ingreso 
temporary tablespace temp 
account unlock;

prompt Privilegios asignados correctamente al nuevo usuario.
grant connect, resource,dba to us_usuario; 

prompt Conectado como usuario us_usuario.
connect us_usuario/1234

show user