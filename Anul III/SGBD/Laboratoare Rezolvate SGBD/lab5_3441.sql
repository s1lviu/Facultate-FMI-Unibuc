CREATE OR REPLACE PROCEDURE marire_salariu_spr
(id_angajat emp_spr.employee_id%type,valoare number)
IS
BEGIN
UPDATE emp_spr
SET
salary = salary + valoare
WHERE employee_id = id_angajat;
END;
/

VARIABLE nr_job NUMBER

BEGIN
DBMS_JOB.SUBMIT(
-- întoarce numărul jobului, printr-o variabilă de legătură
JOB => :nr_job,
-- codul PL/SQL care trebuie executat
WHAT => 'marire_salariu_spr(100, 1000);',
-- data de start a execuţiei (dupa 30 secunde)
NEXT_DATE => SYSDATE+30/86400,
-- intervalul de timp la care se repetă execuţia
INTERVAL => 'SYSDATE+1');
COMMIT;
END;
/

SELECT salary FROM emp_spr WHERE employee_id = 100;

-- asteptati 30 de secunde
SELECT salary FROM emp_spr WHERE employee_id = 100;
-- numarul jobului
PRINT nr_job;
-- informatii despre joburi
SELECT JOB, NEXT_DATE, WHAT
FROM
USER_JOBS;


create or replace package test2 is
procedure do;
end test2;
/

create or replace package body test2 IS
function nobody_sees_me return number is
  begin
    return 1;
  end nobody_sees_me;
    
procedure do  is
begin
  DBMS_OUTPUT.PUT_LINE(nobody_sees_me);
  end do;
end test2;
/

SET SERVEROUTPUT ON;
begin
  test2.do;
end;
/



create or replace package angajat_spr is
function min_sal (
did employees.department_id%TYPE,
jid employees.job_id%TYPE
) return employees.salary%TYPE;

function cod_man ( 
nume employees.first_name%TYPE,
prenume employees.last_name%TYPE
) return employees.employee_id%TYPE;

function cod_dpt (
nume departments.department_name%TYPE
) return departments.department_id%TYPE;

function cod_job (
nume jobs.job_title%TYPE
) return jobs.job_id%TYPE;

procedure ins (
first_name employees.first_name%TYPE,
last_name employees.last_name%TYPE,
email employees.email%TYPE,
phone employees.phone_number%TYPE,
job_title jobs.job_title%TYPE,
dept_name departments.department_name%TYPE,
nume_man employees.first_name%TYPE,
prenume_man employees.last_name%TYPE
);

end angajat_spr;
/

create or replace package body angajat_spr is
function min_sal (
did employees.department_id%TYPE,
jid employees.job_id%TYPE
) return employees.salary%type is
v_sal employees.salary%TYPE;
BEGIN
  select min(salary) 
  into v_sal
  from employees 
  where department_id = did and 
            job_id = jid;
  return v_sal;
end min_sal;

function cod_man ( 
nume employees.first_name%TYPE,
prenume employees.last_name%TYPE
) return employees.employee_id%TYPE
IS
v_cod employees.employee_id%TYPE;
BEGIN
  SELECT employee_id
  into v_cod
  from employees 
  where first_name = nume and
           last_name = prenume and 
           employee_id in (SELECT distinct manager_id from employees);
  return v_cod;
  end cod_man;

function cod_dpt (
nume departments.department_name%TYPE
) return departments.department_id%TYPE
IS
v_cod departments.department_id%TYPE;
BEGIN
  SELECT department_id
  into v_cod
  from departments
  where department_name = nume;
  return v_cod;
end cod_dpt;

function cod_job (
nume jobs.job_title%TYPE
) return jobs.job_id%TYPE
IS
v_cod jobs.job_id%TYPE;
BEGIN
  SELECT job_id
  into v_cod
  from jobs
  where job_title = nume;
  return v_cod;
  end cod_job;

procedure ins (
first_name employees.first_name%TYPE,
last_name employees.last_name%TYPE,
email employees.email%TYPE,
phone employees.phone_number%TYPE,
job_title jobs.job_title%TYPE,
dept_name departments.department_name%TYPE,
nume_man employees.first_name%TYPE,
prenume_man employees.last_name%TYPE
) IS
BEGIN
  INSERT INTO employees
  VALUES(
  employees_seq.nextval, 
  first_name, 
  last_name, 
  email, 
  phone,
  SYSDATE, 
  cod_job(job_title), 
  min_sal(cod_dpt(dept_name), cod_job(job_title)),
  NULL,
  cod_man(nume_man,prenume_man),
  cod_dpt(dept_name)
  );
  END ins;

end angajat_spr;
/

select angajat_spr.min_sal(50, 'SH_CLERK') from dual;
select angajat_spr.cod_man('Steven', 'King') from dual;

execute angajat_spr.ins('Gigel', 'Dorica', 'dorel@camp.ro', '072202000', 'IT_PROG','Marketing', 'Steven', 'King');

SELECT distinct manager_id from employees;
select manager_id from departments where manager_id is not null;