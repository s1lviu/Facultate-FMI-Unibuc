SET SERVEROUTPUT ON
--ex10
--var1.3
BEGIN
  FOR v_dept IN
  (SELECT department_id,
    department_name
  FROM departments
  WHERE department_id IN (10,20,30,40)
  )
  LOOP
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_dept.department_name);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    FOR v_emp IN
    (SELECT last_name FROM employees WHERE department_id = v_dept.department_id
    )
    LOOP
      DBMS_OUTPUT.PUT_LINE (v_emp.last_name);
    END LOOP;
  END LOOP;
END;
/
--var1.1
DECLARE
  CURSOR v_dept
  IS
    SELECT department_id,
      department_name
    FROM departments
    WHERE department_id IN (10,20,30,40);
  CURSOR v_emp
  IS
    SELECT last_name, department_id FROM employees;
  v_cod1 departments.department_id%TYPE;
  v_cod2 departments.department_id%TYPE;
  v_name_emp employees.last_name%TYPE;
  v_name_dept departments.department_name%TYPE;
BEGIN
  OPEN v_dept;
  LOOP
    FETCH v_dept INTO v_cod1, v_name_dept;
    EXIT
  WHEN v_dept%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||v_name_dept);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    OPEN v_emp;
    LOOP
      FETCH v_emp INTO v_name_emp, v_cod2;
      EXIT
    WHEN v_emp%NOTFOUND;
      IF v_cod1 = v_cod2 THEN
        DBMS_OUTPUT.PUT_LINE( v_name_emp);
      END IF;
    END LOOP;
    CLOSE v_emp;
  END LOOP;
  CLOSE v_dept;
END;
/
--var1.2
DECLARE
  CURSOR v_dept
  IS
    SELECT department_id,
      department_name
    FROM departments
    WHERE department_id IN (10,20,30,40);
  CURSOR v_emp
  IS
    SELECT last_name, department_id FROM employees;
  v_cod1 departments.department_id%TYPE;
  v_cod2 departments.department_id%TYPE;
  v_name_emp employees.last_name%TYPE;
  v_name_dept departments.department_name%TYPE;
BEGIN
  FOR i IN v_dept
  LOOP
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    DBMS_OUTPUT.PUT_LINE ('DEPARTAMENT '||i.department_name);
    DBMS_OUTPUT.PUT_LINE('-------------------------------------');
    FOR j IN v_emp
    LOOP
      IF j.department_id = i.department_id THEN
        DBMS_OUTPUT.PUT_LINE(j.last_name);
      END IF;
    END LOOP;
  END LOOP;
END;
/
DECLARE
TYPE emp_tip
IS
  REF
  CURSOR
    RETURN employees%ROWTYPE;
    v_emp emp_tip;
    v_optiune NUMBER := &p_optiune;
    v_ang employees%ROWTYPE;
  BEGIN
    IF v_optiune = 1 THEN
      OPEN v_emp FOR SELECT * FROM employees;
    ELSIF v_optiune = 2 THEN
      OPEN v_emp FOR SELECT * FROM employees WHERE salary BETWEEN 10000 AND 20000;
    ELSIF v_optiune                                                           = 3 THEN
      OPEN v_emp FOR SELECT * FROM employees WHERE TO_CHAR(hire_date, 'YYYY') = 2000;
    ELSE
      DBMS_OUTPUT.PUT_LINE('Optiune incorecta');
    END IF;
    LOOP
      FETCH v_emp INTO v_ang;
    EXIT
  WHEN v_emp%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_ang.last_name);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Au fost procesate '||v_emp%ROWCOUNT || ' linii');
  CLOSE v_emp;
END;
/
--ex12
DECLARE
TYPE empref IS REF CURSOR;
    v_emp empref;
    v_nr INTEGER := &n;
    TYPE detalii is RECORD(cod employees.employee_id%TYPE,
                                              salariu employees.salary%TYPE,
                                              comp employees.commission_pct%TYPE,
                                              nume employees.last_name%TYPE);
   v_ang detalii;
  BEGIN
    OPEN v_emp FOR SELECT employee_id, salary, commission_pct, last_name 
    FROM employees 
    WHERE salary > v_nr;
    LOOP
      FETCH v_emp INTO v_ang;
      EXIT WHEN v_emp%NOTFOUND;
      IF NVL(v_ang.comp,0) <> 0 THEN
        DBMS_OUTPUT.PUT_LINE('Are comision: ' || v_ang.nume ||
        ' cu salariul ' || v_ang.salariu || ' si comisionul ' || v_ang.comp);
      ELSE
        DBMS_OUTPUT.PUT_LINE('Nu are comision: ' || v_ang.nume ||
        ' cu salariul ' || v_ang.salariu);
    END IF;
    END LOOP;
  END;
  /

--propuse
--ex1

DECLARE
CURSOR v_jobs IS SELECT DISTINCT job_title,job_id
                               FROM jobs;
CURSOR v_emp IS SELECT  job_id,last_name,salary
                               FROM employees;
 v_jt jobs.job_title%TYPE;
 v_j1_id jobs.job_id%TYPE;
 v_j2_id employees.job_id%TYPE;
 v_nume employees.last_name%TYPE;
 v_salariu employees.salary%TYPE; 
BEGIN
  OPEN v_jobs;
  LOOP
    FETCH v_jobs INTO v_jt,v_j1_id;
  EXIT WHEN v_jobs%NOTFOUND;
  DBMS_OUTPUT.PUT_LINE('--');
  DBMS_OUTPUT.PUT_LINE(v_jt);
  DBMS_OUTPUT.PUT_LINE('--');
  OPEN v_emp;
  LOOP
    FETCH v_emp INTO v_j2_id,v_nume,v_salariu;
  EXIT WHEN v_emp%NOTFOUND;
  --IF v_emp%ROWCOUNT = 0 THEN
   
  --ELSE  
  IF v_j1_id = v_j2_id THEN
   DBMS_OUTPUT.PUT_LINE('Angajatul ' || v_nume || 'are salariul ' || v_salariu);
  END IF;
 -- END IF;
  END LOOP;
   DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
  CLOSE v_emp;
  END LOOP;
  CLOSE v_jobs;
END;
/