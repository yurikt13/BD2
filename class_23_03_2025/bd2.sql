select * from tipos_documentos;
insert into tipos_documentos (id_tipo_documento, nombre) values (1, 'Cedula de Ciudadania');
insert into tipos_documentos (id_tipo_documento, nombre) values (2, 'Pasaporte');

select * from estados;
insert into estados (id_estado, nombre) values (1, 'Activo');
insert into estados (id_estado, nombre) values (2, 'Inactivo');

select sysdate from dual;

select * from usuarios;
insert into usuarios (identificacion, id_tipo_documento, correo_institucional, correo_personal, celular, nombres, primer_apellido, segundo_apellido, fecha_nacimiento, id_estado) 
values ('111796070', 1, 'yuri_monroy23211@elpoli.edu.co', 'bangtantaejunk@gmail.com', '+573103604115', 'Yuri Alejandra', 'Monroy', 'Bautista', '26/03/2004', 1);

create table auditorias (
    id_log integer,
    nombre_tabla varchar2(15),
    identificacion_usuario varchar2(15),
    evento varchar2(7),
    fecha_creacion date,
    informacion varchar2(4000),
    constraint pk_auditorias_id_log primary key(id_log),
    constraint fk_auditorias_identificacion_usuario foreign key(identificacion_usuario) references usuarios(identificacion) 
);

drop sequence seq_auditoria;
Create sequence seq_auditoria
start with 1
increment by 1
nocache
nocycle;


create or replace trigger aud_usuarios
before insert or update or delete
on usuarios
for each row 
declare 
    v_evento varchar(7);
    v_informacion varchar2(4000);
begin
    
    if INSERTING THEN
     v_evento := 'INSERT';
     v_informacion := 'Nuevo registro -> IDENTIFICACION: ' || :NEW.IDENTIFICACION || ', ID_TIPO_DOCUMENTO: ' || :NEW.ID_TIPO_DOCUMENTO || ', CORREO_INSTITUCIONAL: ' || :NEW.CORREO_INSTITUCIONAL || ', CORREO_PERSONAL: ' || :NEW.CORREO_PERSONAL || ', CELULAR: ' || :NEW.CELULAR || ', NOMBRES: ' || :NEW.NOMBRES || ', PRIMER_APELLIDO: ' || :NEW.PRIMER_APELLIDO || ', SEGUNDO_APELLIDO: ' || :NEW.SEGUNDO_APELLIDO || ', FECHA_NACIMIENTO: ' || :NEW.FECHA_NACIMIENTO  || ', ID_ESTADO: ' || :NEW.ID_ESTADO;
    end if;
    
    if UPDATING THEN
     v_evento := 'UPDATE';
     v_informacion := 'Antes -> IDENTIFICACION: ' || :OLD.IDENTIFICACION || ', ID_TIPO_DOCUMENTO: ' || :OLD.ID_TIPO_DOCUMENTO || ', CORREO_INSTITUCIONAL: ' || :OLD.CORREO_INSTITUCIONAL || ', CORREO_PERSONAL: ' || :OLD.CORREO_PERSONAL || ', CELULAR: ' || :OLD.CELULAR || ', NOMBRES: ' || :OLD.NOMBRES || ', PRIMER_APELLIDO: ' || :OLD.PRIMER_APELLIDO || ', SEGUNDO_APELLIDO: ' || :OLD.SEGUNDO_APELLIDO || ', FECHA_NACIMIENTO: ' || :OLD.FECHA_NACIMIENTO  || ', ID_ESTADO: ' || :OLD.ID_ESTADO || CHR(10) ||
     'Despues: -> IDENTIFICACION: ' || :NEW.IDENTIFICACION || ', ID_TIPO_DOCUMENTO: ' || :NEW.ID_TIPO_DOCUMENTO || ', CORREO_INSTITUCIONAL: ' || :NEW.CORREO_INSTITUCIONAL || ', CORREO_PERSONAL: ' || :NEW.CORREO_PERSONAL || ', CELULAR: ' || :NEW.CELULAR || ', NOMBRES: ' || :NEW.NOMBRES || ', PRIMER_APELLIDO: ' || :NEW.PRIMER_APELLIDO || ', SEGUNDO_APELLIDO: ' || :NEW.SEGUNDO_APELLIDO || ', FECHA_NACIMIENTO: ' || :NEW.FECHA_NACIMIENTO  || ', ID_ESTADO: ' || :NEW.ID_ESTADO;
    end if;
    
    if DELETING THEN
     v_evento := 'DELETE';
     v_informacion := 'Eliminado -> IDENTIFICACION: ' || :OLD.IDENTIFICACION || ', ID_TIPO_DOCUMENTO: ' || :OLD.ID_TIPO_DOCUMENTO || ', CORREO_INSTITUCIONAL: ' || :OLD.CORREO_INSTITUCIONAL || ', CORREO_PERSONAL: ' || :OLD.CORREO_PERSONAL || ', CELULAR: ' || :OLD.CELULAR || ', NOMBRES: ' || :OLD.NOMBRES || ', PRIMER_APELLIDO: ' || :OLD.PRIMER_APELLIDO || ', SEGUNDO_APELLIDO: ' || :OLD.SEGUNDO_APELLIDO || ', FECHA_NACIMIENTO: ' || :OLD.FECHA_NACIMIENTO  || ', ID_ESTADO: ' || :OLD.ID_ESTADO;
    end if;
    
    insert into auditorias(
        id_log, 
        nombre_tabla, 
        identificacion_usuario, 
        evento, 
        fecha_creacion,
        informacion
    ) values (
        seq_auditoria.nextval, 
        'usuarios', 
        :NEW.IDENTIFICACION, 
        v_evento, 
            sysdate,
        v_informacion
    );
end aud_usuarios;
/