drop table tabla2;
drop table tabla1;
create table tabla1
(
    campo1_t1 number,
    campo2_t1 varchar2(15),
    campo3_t1 integer,
    constraint pk_tabla1 primary key (campo1_t1)
);

select * from tabla1;
create table tabla2
(
    campo1_t2 number,
    campo2_t2_campo1_t1 number,
    campo3_t2 integer,
    campo4_t2 date,
    constraint pk_tabla2 primary key (campo1_t2),
    constraint nn_campo2_t2 check(campo2_t2_campo1_t1 is not null),
    constraint nn_campo3_t2 check(campo3_t2 is not null),
    constraint nn_campo4_t2 check(campo4_t2 is not null),
    constraint fk_campo2_t2_campo1_t1 foreign key(campo2_t2_campo1_t1) references tabla1(campo1_t1)
);
select * from tabla1;

insert into tabla1 values(1,'Venta 1',100);
insert into tabla1 values(2,'Venta 2',150);

insert into tabla2 values(1,1,100, sysdate);
insert into tabla2 values(2,1,100, sysdate);
insert into tabla2 values(3,1,100, sysdate);
insert into tabla2 values(4,2,150, sysdate);


set serveroutput on;


create or replace trigger TG_Table1
before insert
on tabla1
begin

	dbms_output.put_line('Nuevo dato insertado.');
end;
/

create or replace trigger TG_Table2
before insert
on tabla2
begin

	dbms_output.put_line('Nuevo dato insertado TB2.');
end;
/
