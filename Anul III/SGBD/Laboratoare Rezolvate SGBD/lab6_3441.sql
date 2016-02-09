CREATE OR REPLACE TRIGGER trig1_spr
BEFORE INSERT OR UPDATE OR DELETE ON emp_spr
BEGIN
IF (TO_CHAR(SYSDATE,'D') = 1)
OR (TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 12 AND 20)
THEN
RAISE_APPLICATION_ERROR(-20001,'tabelul nu poate fi actualizat');
END IF;
END;
/

update emp_spr set salary=10000 where employee_id=101;

drop trigger trig1_pva;
create or replace
TRIGGER trig1_pva BEFORE
  INSERT OR
  UPDATE OR
  DELETE ON emp_spr
  BEGIN IF (TO_CHAR(SYSDATE,'D') = 1)
  OR (TO_CHAR(SYSDATE,'HH24') NOT BETWEEN 12 AND 20) THEN RAISE_APPLICATION_ERROR(-20001,'trigerul lui vali este utilizat');
END IF;
END;
/

CREATE OR REPLACE TRIGGER trig21_spr
BEFORE UPDATE OF salary ON emp_spr
FOR EACH ROW
BEGIN
IF (:NEW.salary < :OLD.salary) THEN
RAISE_APPLICATION_ERROR(-20002,'salariul nu poate fi micsorat');
END IF;
END;
/

alter trigger  trig1_pva disable;
alter trigger  trig1_spr disable;
UPDATE emp_spr
SET
salary = salary-100;

CREATE TABLE info_dept_spr
(
id number(10) PRIMARY KEY,
nume_dept varchar2(30),
plati number(10,2)
);

insert into info_dept_spr select d.department_id,department_name,sum(salary)
from departments d, employees e
where d.department_id=e.department_id
group by d.department_id,department_name ;

CREATE OR REPLACE PROCEDURE modific_plati_spr
(v_codd info_dept_spr.id%TYPE,
v_plati info_dept_spr.plati%TYPE) AS
BEGIN
UPDATE info_dept_spr
SET
plati = NVL (plati, 0) + v_plati
WHERE
id = v_codd;
END;
/

CREATE OR REPLACE TRIGGER trig4_spr
AFTER DELETE OR UPDATE OR INSERT OF salary ON emp_spr
FOR EACH ROW
BEGIN
IF DELETING THEN
-- se sterge un angajat
modific_plati_spr (:OLD.department_id, -1*:OLD.salary);
ELSIF UPDATING THEN
--se modifica salariul unui angajat
modific_plati_spr(:OLD.department_id,:NEW.salary-:OLD.salary);
ELSE
-- se introduce un nou angajat
modific_plati_spr(:NEW.department_id, :NEW.salary);
END IF;
END;
/

INSERT INTO emp_spr (employee_id, last_name, email, hire_date,
job_id, salary, department_id)
VALUES (300, 'N1', 'n1@g.com',sysdate, 'SA_REP', 2000, 90);

select * from emp_spr;

SELECT * FROM
info_dept_spr WHERE id=90;


CREATE TABLE info_emp_spr
(
id number(10) PRIMARY KEY,
nume varchar2(30),
prenume varchar2(30),
salariu number(8,2),
id_dept number(10)
);

ALTER TABLE info_emp_spr
ADD CONSTRAINT fk_dep_emp foreign key (id_dept) references info_dept_spr(id);

insert into info_emp_spr select employee_id,first_name, last_name,salary,department_id
from  employees;

create view v_info_spr as select d.id,nume_dept,plati,nume,prenume,salariu,id_dept
from info_dept_spr d,info_emp_spr e;

drop view v_info_spr;

select * from user_updatable_columns where table_name=;



--exercitii
--ex1
CREATE OR REPLACE TRIGGER trig1234_spr
  BEFORE DELETE ON grupa44.dept_spr
BEGIN
  IF USER = UPPER('grupa44') THEN
    RAISE_APPLICATION_ERROR(-20000, 'Nu aveti voie sa faceti modificari');
  END IF;
END;
/

DELETE FROM dept_spr WHERE department_id = 100;
ALTER TRIGGER trig1234_spr disable;

--ex2
CREATE OR REPLACE TRIGGER trg1243_spr
  BEFORE UPDATE OF commission_pct ON emp_spr
  FOR EACH ROW
BEGIN
  IF :NEW.commission_pct > 0.5 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Comision prea mare!!!');
  END IF;
END;
/
