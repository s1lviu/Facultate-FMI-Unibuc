set serveroutput on
DECLARE
TYPE tablou_imbricat IS TABLE OF CHAR(1);
t tablou_imbricat := tablou_imbricat('m', 'i', 'n', 'i', 'm');
i INTEGER;
BEGIN
i := t.FIRST;
WHILE i <= t.LAST LOOP
DBMS_OUTPUT.PUT(t(i));
i := t.NEXT(i);
END LOOP;
DBMS_OUTPUT.NEW_LINE;
i := t.LAST;
WHILE i >= t.FIRST LOOP
DBMS_OUTPUT.PUT(t(i));
i := t.PRIOR(i);
END LOOP;
DBMS_OUTPUT.NEW_LINE;
t.delete(2);
t.delete(4);
i := t.FIRST;
WHILE i <= t.LAST LOOP
DBMS_OUTPUT.PUT(t(i));
i := t.NEXT(i);
END LOOP;
DBMS_OUTPUT.NEW_LINE;
i := t.LAST;
WHILE i >= t.FIRST LOOP
DBMS_OUTPUT.PUT(t(i));
i := t.PRIOR(i);
END LOOP;
DBMS_OUTPUT.NEW_LINE;
END;
/

CREATE OR REPLACE TYPE subordonati_spr AS VARRAY(10) OF NUMBER(4);
/

CREATE TABLE manageri_spr (cod_mgr NUMBER(10),
nume VARCHAR2(20),
lista subordonati_spr);

DECLARE
v_sub
subordonati_spr:= subordonati_spr(100,200,300);
v_lista manageri_spr.lista%TYPE;
BEGIN
INSERT INTO manageri_spr
VALUES (1, 'Mgr 1', v_sub);
INSERT INTO manageri_spr
VALUES (2, 'Mgr 2', null);
INSERT INTO manageri_spr
VALUES (3, 'Mgr 3', subordonati_spr(400,500));
SELECT
lista
into v_lista
from manageri_spr
where cod_mgr=1;
FOR j IN v_lista.FIRST..v_lista.LAST loop
DBMS_OUTPUT.PUT_LINE (v_lista(j));
END LOOP;
END;
/
SELECT * FROM manageri_spr;

drop table manageri_spr;
drop type subordonati_spr;

CREATE TABLE emp_test_spr AS
SELECT employee_id, last_name FROM employees
WHERE ROWNUM <= 2;

CREATE OR REPLACE TYPE tip_telefon_spr IS TABLE OF VARCHAR(12);
/
ALTER TABLE emp_test_spr
ADD (telefon tip_telefon_spr)
NESTED TABLE telefon STORE AS tabel_telefon_spr;

INSERT INTO emp_test_spr
VALUES (500, 'XYZ',tip_telefon_spr('074XXX', '0213XXX', '037XXX'));
update emp_test_spr
SET telefon = tip_telefon_spr('073XXX', '0214XXX')
WHERE employee_id=100;

SELECT a.employee_id, b.*
FROM
emp_test_spr a, TABLE (a.telefon) b;

drop table tabel_telefon_spr;


--1. Mențineți într-o colecție codurile celor mai prost plătiți 5 angajați care nu câștigă comision. Folosind această
--colecție măriți cu 5% salariul acestor angajați. Afișați valoarea veche a salariului, respectiv valoarea nouă a
--salariului.


DECLARE
TYPE rec IS RECORD(cod employees.employee_id%TYPE,
                    salariu employees.salary%TYPE);
TYPE vect_cod is VARRAY(5) OF rec;
vct vect_cod;
crestere_sal NUMBER(2) := 1.05;
BEGIN
  SELECT * BULK COLLECT INTO vct FROM(
    SELECT employee_id, salary
    FROM emp_spr
    WHERE commission_pct IS NULL
    ORDER BY salary ASC)
  WHERE ROWNUM <= 5;
  FOR i in vct.first..vct.last LOOP
    UPDATE emp_spr
    SET salary = salary * crestere_sal
    WHERE employee_id=vct(i).cod;
    DBMS_OUTPUT.PUT_LINE('Salariu vechi: ' ||vct(i).cod || ' ' || vct(i).salariu);
    --DBMS_OUTPUT.PUT_LINE('Salariu nou: ' || vct(i).cod || ' ' || vct(i).salariu * crestere_sal);
  END LOOP;
END;
/




SELECT * FROM(
    SELECT employee_id, salary
    FROM emp_spr
    WHERE commission_pct IS NULL
    ORDER BY salary ASC)
  WHERE ROWNUM <= 5;
  
--ex 2


CREATE OR REPLACE  TYPE tip_orase_spr2 is TABLE of VARCHAR2(20);
/
drop table excursie_spr2;
CREATE TABLE  excursie_spr2(cod_excursie NUMBER(4), 
                           denumire VARCHAR2(20));
ALTER TABLE excursie_spr2
ADD  (orase tip_orase_spr2) 
nested table orase store as tabel_orase2;
BEGIN
insert into excursie_spr2 values(101,'New York',tip_orase_spr2('Manhattan'));
insert into excursie_spr2 values(102,'Outer Space', tip_orase_spr2('Luna','WormHole'));
insert into excursie_spr2 values(103,'Jamaica', tip_orase_spr2('Kongston','Montego Bei'));
insert into excursie_spr2 values(104,'Romania', tip_orase_spr2('Brasov','Iasi','Cluj','Timisoara'));
insert into excursie_spr2 values(105,'Olanda', tip_orase_spr2('Amsterdam','Watever'));
--b


END;
/
UPDATE TABLE excursie_spr2
SET orase = tip_orase_spr2('Vanilla','Manila')
WHERE denumire like 'Romania';


select * from excursie_spr2;




