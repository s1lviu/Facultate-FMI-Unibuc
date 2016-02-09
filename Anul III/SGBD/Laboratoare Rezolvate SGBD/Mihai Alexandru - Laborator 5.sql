/* Exercitiul 1 */
CREATE SEQUENCE emp MINVALUE 1000 MAXVALUE 9000 START WITH 1000 INCREMENT BY 1 CACHE 20;
CREATE OR REPLACE PACKAGE gestiune_angajati
AS
  /* a */
  PROCEDURE adaugare(
      v_last_name employees.last_name%TYPE,
      v_first_name employees.first_name%TYPE,
      v_phone_number employees.phone_number%TYPE := NULL,
      v_email employees.email%TYPE,
      v_nume_job jobs.job_title%TYPE,
      v_nume_manager employees.last_name%TYPE,
      v_prenume_manager employees.first_name%TYPE,
      v_nume_departament departments.department_name%TYPE);
  /* b */
  PROCEDURE mutare(
      v_first_name employees.first_name%TYPE,
      v_last_name employees.last_name%TYPE,
      v_nume_departament departments.department_name%TYPE,
      v_nume_job jobs.job_title%TYPE,
      v_prenume_manager employees.first_name%TYPE,
      v_nume_manager employees.last_name%TYPE);
  /* c */
  FUNCTION numar_subalterni(
      v_first_name employees.first_name%TYPE,
      v_last_name employees.last_name%TYPE)
    RETURN NUMBER;
  /* d */
  PROCEDURE promovare(
      v_first_name employees.first_name%TYPE,
      v_last_name employees.last_name%TYPE);
  /* e */
  PROCEDURE actualizare_salariu(
      v_salary employees.salary%TYPE,
      v_first_name employees.first_name%TYPE,
      v_last_name employees.last_name%TYPE);
  /* f */
  CURSOR lista_angajati(v_job_id employees.job_id%TYPE)
    RETURN employees%ROWTYPE;
    /* g */
    CURSOR lista_job
      RETURN jobs%ROWTYPE;
      /* h */
      PROCEDURE afisare_job_angajat;
    END gestiune_angajati;
    /
CREATE OR REPLACE PACKAGE BODY gestiune_angajati
AS
  /* f */
  CURSOR lista_angajati(v_job_id employees.job_id%TYPE)
    RETURN employees%ROWTYPE
  IS
    SELECT * FROM employees WHERE job_id = v_job_id;
  /* g */
  CURSOR lista_job
    RETURN jobs%ROWTYPE
  IS
    SELECT * FROM jobs;
  /* a */
  FUNCTION get_min_salary(
      v_nume_departament departments.department_name%TYPE,
      v_nume_job jobs.job_title%TYPE)
    RETURN employees.salary%TYPE
  IS
    v_salary employees.salary%TYPE;
  BEGIN
    SELECT MIN(e.salary)
    INTO v_salary
    FROM employees e,
      departments d,
      jobs j
    WHERE e.department_id        = d.department_id
    AND e.job_id                 = j.job_id
    AND LOWER(j.job_title)       = LOWER(v_nume_job)
    AND LOWER(d.department_name) = LOWER(v_nume_departament);
    RETURN v_salary;
  END get_min_salary;
  FUNCTION get_manager(
      v_prenume_manager employees.first_name%TYPE,
      v_nume_manager employees.last_name%TYPE)
    RETURN employees.employee_id%TYPE
  IS
    v_id_manager employees.employee_id%TYPE;
  BEGIN
    SELECT employee_id
    INTO v_id_manager
    FROM employees
    WHERE LOWER(last_name) = LOWER(v_nume_manager)
    AND LOWER(first_name)  = LOWER(v_prenume_manager);
    RETURN v_id_manager;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20000, 'Nu exista manager cu numele dat');
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi manageri cu numele dat');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR( -20002,'Alta eroare!');
  END get_manager;
  FUNCTION get_id_job(
      v_nume_job jobs.job_title%TYPE)
    RETURN jobs.job_id%TYPE
  IS
    v_id_job jobs.job_id%TYPE;
  BEGIN
    SELECT job_id
    INTO v_id_job
    FROM jobs
    WHERE LOWER(job_title) = LOWER(v_nume_job);
    RETURN v_id_job;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20000, 'Nu exista jobul cu numele dat');
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20001, 'Exista mai multe joburi cu numele dat');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR( -20002,'Alta eroare!');
  END get_id_job;
  FUNCTION get_id_departament(
      v_nume_departament departments.department_name%TYPE)
    RETURN departments.department_id%TYPE
  IS
    v_id_departament departments.department_id%TYPE;
  BEGIN
    SELECT department_id
    INTO v_id_departament
    FROM departments
    WHERE LOWER(department_name) = LOWER(v_nume_departament);
    RETURN v_id_departament;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20000, 'Nu exista departamentul cu numele dat');
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20001, 'Exista mai multe departamente cu numele dat');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR( -20002,'Alta eroare!');
  END get_id_departament;
  PROCEDURE adaugare(
      v_last_name employees.last_name%TYPE,
      v_first_name employees.first_name%TYPE,
      v_phone_number employees.phone_number%TYPE := NULL,
      v_email employees.email%TYPE,
      v_nume_job jobs.job_title%TYPE,
      v_nume_manager employees.last_name%TYPE,
      v_prenume_manager employees.first_name%TYPE,
      v_nume_departament departments.department_name%TYPE)
  AS
    v_salary employees.salary%TYPE;
    v_manager employees.employee_id%TYPE;
    v_id_departament departments.department_id%TYPE;
    v_id_job jobs.job_id%TYPE;
  BEGIN
    v_salary         := get_min_salary(v_nume_departament,v_nume_job);
    v_manager        := get_manager(v_prenume_manager,v_nume_manager);
    v_id_departament := get_id_departament(v_nume_departament);
    v_id_job         := get_id_job(v_nume_job);
    INSERT
    INTO employees VALUES
      (
        emp.NEXTVAL,
        v_first_name,
        v_last_name,
        v_email,
        v_phone_number,
        SYSDATE,
        v_id_job,
        v_salary,
        NULL,
        v_manager,
        v_id_departament
      );
  END adaugare;
/* b */
  FUNCTION get_employee_id
    (
      v_first_name employees.first_name%TYPE,
      v_last_name employees.last_name%TYPE
    )
    RETURN employees.employee_id%TYPE
  IS
    v_employee_id employees.employee_id%TYPE;
  BEGIN
    SELECT employee_id
    INTO v_employee_id
    FROM employees
    WHERE LOWER(first_name) = LOWER(v_first_name)
    AND LOWER(last_name)    = LOWER(v_last_name);
    RETURN v_employee_id;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajatul cu numele dat');
  WHEN TOO_MANY_ROWS THEN
    RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR( -20002,'Alta eroare!');
  END get_employee_id;
  FUNCTION get_comision(
      v_nume_departament departments.department_name%TYPE,
      v_nume_job jobs.job_title%TYPE)
    RETURN employees.commission_pct%TYPE
  IS
    v_comision employees.commission_pct%TYPE;
  BEGIN
    SELECT MIN(e.commission_pct)
    INTO v_comision
    FROM employees e,
      departments d,
      jobs j
    WHERE e.department_id        = d.department_id
    AND e.job_id                 = j.job_id
    AND LOWER(j.job_title)       = LOWER(v_nume_job)
    AND LOWER(d.department_name) = LOWER(v_nume_departament);
    RETURN v_comision;
  END get_comision;
  PROCEDURE mutare(
      v_first_name employees.first_name%TYPE,
      v_last_name employees.last_name%TYPE,
      v_nume_departament departments.department_name%TYPE,
      v_nume_job jobs.job_title%TYPE,
      v_prenume_manager employees.first_name%TYPE,
      v_nume_manager employees.last_name%TYPE)
  AS
    v_employee_id employees.employee_id%TYPE;
    v_salary employees.salary%TYPE;
    v_salary2 employees.salary%TYPE;
    v_manager employees.employee_id%TYPE;
    v_id_departament departments.department_id%TYPE;
    v_id_job jobs.job_id%TYPE;
    v_comision employees.commission_pct%TYPE;
  BEGIN
    v_employee_id    := get_employee_id(v_first_name, v_last_name);
    v_salary         := get_min_salary(v_nume_departament,v_nume_job);
    v_manager        := get_manager(v_prenume_manager,v_nume_manager);
    v_id_departament := get_id_departament(v_nume_departament);
    v_id_job         := get_id_job(v_nume_job);
    v_comision       := get_comision(v_nume_departament,v_nume_job);
    SELECT salary INTO v_salary2 FROM employees WHERE employee_id = v_employee_id;
    IF v_salary > v_salary2 THEN
      v_salary := v_salary2;
    END IF;
    INSERT
    INTO job_history VALUES
      (
        v_employee_id,
        (SELECT hire_date FROM employees WHERE employee_id = v_employee_id
        ),
        SYSDATE,
        (SELECT job_id FROM employees WHERE employee_id = v_employee_id
        ),
        (SELECT department_id FROM employees WHERE employee_id = v_employee_id
        )
      );
    UPDATE employees
    SET department_id = v_id_departament,
      job_id          = v_id_job,
      manager_id      = v_manager,
      salary          = v_salary,
      commission_pct  = NULL,
      hire_date       = SYSDATE
    WHERE employee_id = v_employee_id;
  END mutare;
/* c */
  FUNCTION numar_subalterni(
      v_first_name employees.first_name%TYPE,
      v_last_name employees.last_name%TYPE)
    RETURN NUMBER
  IS
    v_numar_subalterni NUMBER := 0;
    v_employee_id employees.employee_id%TYPE;
  BEGIN
    v_employee_id := get_employee_id(v_first_name, v_last_name);
    SELECT COUNT(employee_id)
    INTO v_employee_id
    FROM employees
      START WITH manager_id        = v_employee_id
      CONNECT BY PRIOR employee_id = manager_id;
    RETURN v_employee_id;
  END numar_subalterni;
/* d */
  PROCEDURE promovare(
      v_first_name employees.first_name%TYPE,
      v_last_name employees.last_name%TYPE)
  AS
    v_employee_id employees.employee_id%TYPE;
    v_manager_id employees.manager_id%TYPE;
    v_manager_id2 employees.manager_id%TYPE;
  BEGIN
    v_employee_id := get_employee_id(v_first_name, v_last_name);
    SELECT manager_id
    INTO v_manager_id
    FROM employees
    WHERE employee_id = v_employee_id;
    IF v_manager_id  IS NOT NULL THEN
      SELECT manager_id
      INTO v_manager_id2
      FROM employees
      WHERE employee_id = v_manager_id;
      IF v_manager_id2 IS NULL THEN
        UPDATE employees SET manager_id = NULL WHERE employee_id = v_employee_id;
      ELSE
        UPDATE employees
        SET manager_id    = v_manager_id2
        WHERE employee_id = v_employee_id;
      END IF;
      DBMS_OUTPUT.PUT_LINE('Valoare actualizata');
    ELSE
      DBMS_OUTPUT.PUT_LINE('Nu mai poate fi promovat');
    END IF;
  END promovare;
/* e */
  PROCEDURE actualizare_salariu(
      v_salary employees.salary%TYPE,
      v_first_name employees.first_name%TYPE,
      v_last_name employees.last_name%TYPE)
  IS
    v_id employees.employee_id%TYPE;
    v_nume employees.last_name%TYPE;
    v_prenume employees.first_name%TYPE;
    v_numar_angajati NUMBER(2);
    v_min_salary jobs.min_salary%TYPE;
    v_max_salary jobs.max_salary%TYPE;
    CURSOR lista_angajati
    IS
      SELECT employee_id,
        first_name,
        last_name
      FROM employees
      WHERE LOWER(first_name) = LOWER(v_first_name)
      AND LOWER(last_name)    = LOWER(v_last_name);
  BEGIN
    SELECT COUNT(*)
    INTO v_numar_angajati
    FROM employees
    WHERE LOWER(first_name) = LOWER(v_first_name)
    AND LOWER(last_name)    = LOWER(v_last_name);
    IF v_numar_angajati     = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat!');
    ELSIF v_numar_angajati > 1 THEN
      DBMS_OUTPUT.PUT_LINE('Sunt mai multi angajati cu numele dat: !');
      OPEN lista_angajati;
      LOOP
        FETCH lista_angajati INTO v_id,v_prenume,v_nume;
        EXIT
      WHEN lista_angajati%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_id || ' ' || v_prenume || ' ' || v_nume);
      END LOOP;
      CLOSE lista_angajati;
    ELSE
      SELECT j.min_salary
      INTO v_min_salary
      FROM jobs j,
        employees e
      WHERE LOWER(e.first_name) = LOWER(v_first_name)
      AND LOWER(e.last_name)    = LOWER(v_last_name)
      AND e.job_id              = j.job_id;
      SELECT j.max_salary
      INTO v_max_salary
      FROM jobs j,
        employees e
      WHERE LOWER(e.first_name) = LOWER(v_first_name)
      AND LOWER(e.last_name)    = LOWER(v_last_name)
      AND e.job_id              = j.job_id;
      IF v_salary              >= v_min_salary AND v_salary <= v_max_salary THEN
        UPDATE employees
        SET salary              = v_salary
        WHERE LOWER(first_name) = LOWER(v_first_name)
        AND LOWER(last_name)    = LOWER(v_last_name);
        DBMS_OUTPUT.PUT_LINE('Valoarea salariului actualizata');
      ELSE
        DBMS_OUTPUT.PUT_LINE('Valoarea salariului eronata');
      END IF;
    END IF;
  END actualizare_salariu;
/* h */
  PROCEDURE afisare_job_angajat
  IS
    job jobs%ROWTYPE;
    angajat employees%ROWTYPE;
    v_nr_job NUMBER(2);
  BEGIN
    OPEN lista_job;
    LOOP
      FETCH lista_job INTO job;
      EXIT
    WHEN lista_job%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(job.job_title || ':');
      OPEN lista_angajati(job.job_id);
      LOOP
        FETCH lista_angajati INTO angajat;
        EXIT
      WHEN lista_angajati%NOTFOUND;
        SELECT COUNT(*)
        INTO v_nr_job
        FROM job_history
        WHERE employee_id = angajat.employee_id;
        IF v_nr_job       > 0 THEN
          DBMS_OUTPUT.PUT_LINE('           ' || angajat.first_name || ' ' || angajat.last_name || '  - DA');
        ELSE
          DBMS_OUTPUT.PUT_LINE('           ' || angajat.first_name || ' ' || angajat.last_name || '  - NU');
        END IF;
      END LOOP;
      CLOSE lista_angajati;
    END LOOP;
    CLOSE lista_job;
  END afisare_job_angajat;
END gestiune_angajati;
/
