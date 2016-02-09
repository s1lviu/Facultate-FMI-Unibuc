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
insert into excursie_spr2 values(102,'Outer Space', tip_orase_spr2('Luna',
                                                        'WormHole'));
insert into excursie_spr2 values(103,'Jamaica', tip_orase_spr2('Kongston',
                                                        'Montego Bei'));
insert into excursie_spr2 values(104,'Romania', tip_orase_spr2('Brasov',
                                            'Iasi','Cluj','Timisoara'));
insert into excursie_spr2 values(105,'Olanda', tip_orase_spr2('Amsterdam',
                                                        'Watever'));
END;
/
--b.Actualizați coloana orase pentru o linie din tabel.
UPDATE excursie_spr2
SET orase = tip_orase_spr2('Vanilla','Manila')
WHERE denumire like 'Romania';
--c. Pentru o excursie al cărui cod este dat, afișați numărul
--de orașe vizitate, respectiv numele orașelor.
DECLARE 
v_cod excursie_spr2.cod_excursie%TYPE := &p_cod;
v_lista excursie_spr2.orase%TYPE;
BEGIN
SELECT orase INTO v_lista
FROM excursie_spr2
WHERE cod_excursie=v_cod;
DBMS_OUTPUT.PUT_LINE('Nr Orase: ' || v_lista.count);
FOR i IN v_lista.first..v_lista.last LOOP
  DBMS_OUTPUT.PUT_LINE('Oras: ' || v_lista(i));
END LOOP;

END;
/

SET SERVEROUTPUT ON

ALTER TABLE excursie_spr2 ADD status NUMBER(1) DEFAULT 1;
DESC excursie_spr2
--Pentru fiecare excursie afișați lista orașelor vizitate.
DECLARE
TYPE coduri IS VARRAY(5) OF excursie_spr2.cod_excursie%TYPE;
v_coduri coduri;
v_lista excursie_spr2.orase%TYPE;
v_min NUMBER(2) := 99;
v_cod excursie_spr2.cod_excursie%TYPE;
BEGIN
  SELECT cod_excursie BULK COLLECT INTO v_coduri
  FROM excursie_spr2;
  FOR i in v_coduri.first..v_coduri.last LOOP
    SELECT orase INTO v_lista
    FROM excursie_spr2
    WHERE cod_excursie = v_coduri(i);
    if v_min > v_lista.count then
      v_min := v_lista.count;
      v_cod := v_coduri(i);
    end if;
    DBMS_OUTPUT.PUT_LINE('Nr orase pt excursie cu codul: ' ||
                          v_coduri(i) || ' este : ' || v_lista.count);
    FOR j in v_lista.first..v_lista.last LOOP
      DBMS_OUTPUT.PUT_LINE(v_lista(j));
    END LOOP;
  END LOOP;
  UPDATE excursie_spr2
  SET status=0
  WHERE cod_excursie = v_cod;
END;
/
--Anulați excursia cu cele mai puține orașe vizitate.

  
--UPDATE excursie_spr2
--SET orase = tip_orase_spr2('Balada', 'Baicoi', 'Strehaia', 'Buftea')
--WHERE cod_excursie = 104;

select * from excursie_spr2;

ALTER TABLE excursie_spr2 ADD CONSTRAINT PK1 PRIMARY KEY(cod_excursie);

--lab3
DECLARE
v_nr
number(4);
v_nume departments.department_name%TYPE;
CURSOR c IS
SELECT department_name nume, COUNT(employee_id) nr
FROM
departments d, employees e
WHERE d.department_id=e.department_id(+)
GROUP BY department_name;
BEGIN
OPEN c;
LOOP
FETCH c INTO v_nume,v_nr;
EXIT WHEN c%NOTFOUND;
IF v_nr=0 THEN
DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume||
' nu lucreaza angajati');
ELSIF v_nr=1 THEN
DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume||
' lucreaza un angajat');
ELSE
DBMS_OUTPUT.PUT_LINE('In departamentul '|| v_nume||
' lucreaza '|| v_nr||' angajati');
END IF;
END LOOP;
CLOSE c;
END;
/

SELECT --department_name nume, 
CASE WHEN COUNT(employee_id)=0 then 'Nu exista angajati'
     WHEN COUNT(employee_id)=1 THEN 'Exista un angajat'
     ELSE 'IN departamentul '||department_name||' avem '||
            COUNT(employee_id)||' angajati'
END CASE  
FROM
departments d, employees e
WHERE d.department_id=e.department_id(+)
GROUP BY department_name;

DECLARE
TYPE rec IS RECORD(nr NUMBER(4),  nume departments.department_name%TYPE);
TYPE tab IS TABLE OF rec;
v tab;
CURSOR c IS
SELECT department_name numele, COUNT(employee_id) numar
FROM
departments d, employees e
WHERE d.department_id=e.department_id(+)
GROUP BY department_name;
BEGIN
OPEN c;
FETCH c BULK COLLECT INTO v;
CLOSE c;
FOR i IN v.FIRST..v.LAST LOOP
IF v(i).nr=0 THEN
DBMS_OUTPUT.PUT_LINE('In departamentul '|| v(i).nume||
' nu lucreaza angajati');
ELSIF v(i).nr=1 THEN
DBMS_OUTPUT.PUT_LINE('In departamentul '||v(i).nume||
' lucreaza un angajat');
ELSE
DBMS_OUTPUT.PUT_LINE('In departamentul '|| v(i).nume||
' lucreaza '|| v(i).nr||' angajati');
END IF;
END LOOP;
END;
/


DECLARE
v_cod
employees.employee_id%TYPE;
v_nume
employees.last_name%TYPE;
v_nr NUMBER(4);
CURSOR c IS
SELECT
sef.employee_id cod, MAX(sef.last_name) nume,
count(*) nr
FROM
employees sef, employees ang
WHERE
ang.manager_id = sef.employee_id
GROUP BY sef.employee_id
ORDER BY nr DESC;
BEGIN
OPEN c;
LOOP
FETCH c INTO v_cod,v_nume,v_nr;
EXIT WHEN c%ROWCOUNT>3 OR c%NOTFOUND;
DBMS_OUTPUT.PUT_LINE('Managerul '|| v_cod ||' avand numele ' || v_nume ||
' conduce ' || v_nr||' angajati');
END LOOP;
CLOSE c;
END;
/

SELECT last_name, hire_date, salary
FROM
emp_SPR
WHERE TO_CHAR(hire_date, 'yyyy') = 2000;

DECLARE
CURSOR c IS
SELECT *
FROM
emp_SPR
WHERE TO_CHAR(hire_date, 'YYYY') = 2000
FOR UPDATE OF salary NOWAIT;
BEGIN
FOR i IN c LOOP
UPDATE emp_SPR
SET
salary= salary+1000
WHERE CURRENT OF c;
END LOOP;
END;
/
SELECT last_name, hire_date, salary
FROM
emp_SPR
WHERE TO_CHAR(hire_date, 'yyyy') = 2000;
ROLLBACK;

