--3. Definiți un bloc anonim în care să se determine numărul de
--filme (titluri) împrumutate de un membru al cărui nume este 
--introdus de la tastatură. Tratați următoarele două situații: 
--nu există nici un membru cu nume dat; există mai mulți membrii 
--cu același nume.
DECLARE
v_nume member.last_name%TYPE := &p_nume;
v_id member.member_id%TYPE := -1;
v_nr NUMBER := 0;
BEGIN
 SELECT count(*)
 INTO v_nr
 FROM rental r 
 JOIN member m 
 on (r.member_id = m.member_id)
 where m.last_name = v_nume;
 DBMS_OUTPUT.PUT_LINE('randuri: ' || SQL%ROWCOUNT);
 if SQL%ROWCOUNT = 0 then 
  DBMS_OUTPUT.PUT_LINE('nu exista membru cu acest nume');
 else DBMS_OUTPUT.PUT_LINE(v_nume || ' a imprumutat ' || v_nr || ' filme');
  end if;
END;
/





--. Se dă următorul enunț: Pentru fiecare zi a lunii octombrie 
--(se vor lua în considerare și zilele din
--lună în care nu au fost realizate împrumuturi) obțineți
--numărul de împrumuturi efectuate.

DECLARE
imprumuturi NUMBER := 0;
zi_cur NUMBER := 1;
zile_luna NUMBER := 31;
luna NUMBER := 10;--luna oct
BEGIN
 LOOP
  SELECT count(*)
  INTO imprumuturi
  FROM RENTAL
  WHERE to_char(book_date, 'MM') = luna
  and to_char(book_date, 'DD') = zi_cur;
  DBMS_OUTPUT.PUT_LINE('Imprumuturi: '|| imprumuturi || ' in ziua: ' || zi_cur);
  zi_cur := zi_cur + 1;
  EXIT WHEN zi_cur >= zile_luna;
 END LOOP;
END;
/









VARIABLE g_dep VARCHAR2(25)

SET SERVEROUTPUT ON
BEGIN
SELECT department_name
INTO
:g_dep
FROM
employees e, departments d
WHERE e.department_id=d.department_id
GROUP BY department_name
HAVING COUNT(*) = (SELECT MAX(COUNT(*))
FROM
employees
GROUP BY department_id);
DBMS_OUTPUT.PUT_LINE('Departamentul '|| :g_dep);
END;
/

PRINT g_dep

SELECT department_name,count(*)
FROM
employees e, departments d
WHERE e.department_id=d.department_id
GROUP BY department_name
--HAVING COUNT(*) = (SELECT MAX(COUNT(*))
--FROM
--employees
--GROUP BY department_id)
;

DEFINE p_var=20

SET SERVEROUTPUT ON
declare
v_var NUMBER :=&p_var;
BEGIN
v_var:=v_var+1;
DBMS_OUTPUT.PUT_LINE(v_var);
END;
/

CREATE TABLE zile_aar(id NUMBER, data DATE, nume_zi VARCHAR2(16));

DECLARE
contor NUMBER(6) := 1;
v_data DATE;
maxim
NUMBER(2) := LAST_DAY(SYSDATE)-SYSDATE;
BEGIN
LOOP
v_data := sysdate+contor;
INSERT INTO zile_aar
VALUES (contor,v_data,to_char(v_data,'Day'));
dbms_output.put_line(contor || ' ' || v_data || ' ' || to_char(v_data,'Day'));
contor := contor + 1;
EXIT WHEN contor > maxim;
END LOOP;
END;
/


CREATE TABLE emp_spr
AS SELECT * FROM employees;

CREATE TABLE dept_spr
AS SELECT * FROM edepartments;

DEFINE p_cod_sal= 200
DEFINE p_cod_dept = 80
DEFINE p_procent =20

DECLARE
v_cod_sal
emp_spr.employee_id%TYPE:= &p_cod_sal;
v_cod_dept emp_spr.department_id%TYPE:= &p_cod_dept;
v_procent
NUMBER(8):=&p_procent;
BEGIN
UPDATE emp_spr
SET department_id = v_cod_dept,
salary=salary + (salary* v_procent/100)
WHERE employee_id= v_cod_sal;
IF SQL%ROWCOUNT =0 THEN
DBMS_OUTPUT.PUT_LINE('Nu exista un angajat cu acest cod');
ELSE DBMS_OUTPUT.PUT_LINE('Actualizare realizata');
END IF;
END;
/
ROLLBACK;


DECLARE
i
POSITIVE:=1;
max_loop CONSTANT POSITIVE:=10;
BEGIN
LOOP
i:=i+1;
IF i>max_loop THEN
DBMS_OUTPUT.PUT_LINE('in loop i=' || i);
GOTO urmator;
END IF;
END LOOP;
<<urmator>>
i:=1;
DBMS_OUTPUT.PUT_LINE('dupa loop i=' || i);
END;
/

DECLARE
i
POSITIVE:=1;
max_loop CONSTANT POSITIVE:=10;
BEGIN
i:=1;
LOOP
i:=i+1;
DBMS_OUTPUT.PUT_LINE('in loop i=' || i);
EXIT WHEN i>max_loop;
END LOOP;
i:=1;
DBMS_OUTPUT.PUT_LINE('dupa loop i=' || i);
END;
/
