/* Exercitiul 1 */
SELECT d.department_name AS " Nume Departament ",
  COUNT( e.employee_id ) AS " Numar Angajati ",
  CASE COUNT(e.employee_id)
    WHEN 0
    THEN 'In departamentul '
      || d.department_name
      || ' nu lucreaza angajati'
    WHEN 1
    THEN 'In departamentul '
      || d.department_name
      || ' lucreaza un angajat'
    ELSE 'In departamentul '
      || d.department_name
      || ' lucreaza '
      || COUNT(e.employee_id)
      || ' angajati'
  END AS " Angajati "
FROM departments d,
  employees e
WHERE d.department_id=e.department_id(+)
GROUP BY department_name;
/* Exercitii */
/* Exercitiul 1 */
/* Cursoare Clasice */
DECLARE
  v_numeJob JOBS.JOB_TITLE%TYPE;
  v_numeAngajat EMPLOYEES.LAST_NAME%TYPE;
  v_salariu EMPLOYEES.SALARY%TYPE;
  v_jobCurent JOBS.JOB_TITLE%TYPE;
  CURSOR c
  IS
    SELECT j.job_title AS " Nume Job ",
      e.last_name      AS " Nume Angajat ",
      e.salary         AS " Salariu "
    FROM employees e,
      jobs j
    WHERE j.job_id = e.job_id(+)
    ORDER BY j.job_title;
BEGIN
  OPEN c;
  LOOP
    FETCH c INTO v_numeJob, v_numeAngajat, v_salariu;
    EXIT
  WHEN c%NOTFOUND;
    IF v_jobCurent = v_numeJob THEN
      DBMS_OUTPUT.PUT_LINE( '               ' || v_numeAngajat || ' ' || v_salariu );
    ELSE
      DBMS_OUTPUT.PUT_LINE( '-------------------------------------------------' );
      DBMS_OUTPUT.PUT_LINE( v_numeJob || ':' );
      DBMS_OUTPUT.PUT_LINE( '               ' || v_numeAngajat || ' ' || v_salariu );
      v_jobCurent := v_numeJob;
    END IF;
  END LOOP;
  CLOSE c;
END;
/
/* Ciclu Cursoare */
DECLARE
  v_jobCurent JOBS.JOB_TITLE%TYPE;
  CURSOR c
  IS
    SELECT j.job_title AS " Nume Job ",
      e.last_name      AS " Nume Angajat ",
      e.salary         AS " Salariu "
    FROM employees e,
      jobs j
    WHERE j.job_id = e.job_id(+)
    ORDER BY j.job_title;
BEGIN
  FOR i IN c
  LOOP
    IF v_jobCurent = i." Nume Job " THEN
      DBMS_OUTPUT.PUT_LINE( '               ' || i." Nume Angajat " || ' ' || i." Salariu " );
    ELSE
      DBMS_OUTPUT.PUT_LINE( '-------------------------------------------------' );
      DBMS_OUTPUT.PUT_LINE( i." Nume Job " || ':' );
      DBMS_OUTPUT.PUT_LINE( '               ' || i." Nume Angajat " || ' ' || i." Salariu " );
      v_jobCurent := i." Nume Job ";
    END IF;
  END LOOP;
END;
/
/* Ciclu cursoare cu subcereri */
DECLARE
  v_jobCurent JOBS.JOB_TITLE%TYPE;
BEGIN
  FOR i IN
  (SELECT j.job_title AS " Nume Job ",
    e.last_name       AS " Nume Angajat ",
    e.salary          AS " Salariu "
  FROM employees e,
    jobs j
  WHERE j.job_id = e.job_id(+)
  ORDER BY j.job_title
  )
  LOOP
    IF v_jobCurent = i." Nume Job " THEN
      DBMS_OUTPUT.PUT_LINE( '               ' || i." Nume Angajat " || ' ' || i." Salariu " );
    ELSE
      DBMS_OUTPUT.PUT_LINE( '-------------------------------------------------' );
      DBMS_OUTPUT.PUT_LINE( i." Nume Job " || ':' );
      DBMS_OUTPUT.PUT_LINE( '               ' || i." Nume Angajat " || ' ' || i." Salariu " );
      v_jobCurent := i." Nume Job ";
    END IF;
  END LOOP;
END;
/
/* Expresii cursor */
DECLARE
TYPE refcursor
IS
  REF
  CURSOR;
    CURSOR c_jobs
    IS
      SELECT j.job_title AS " Nume Job ",
        CURSOR
        (SELECT e.last_name AS " Nume Angajat ",
          e.salary          AS " Salariu "
        FROM employees e
        WHERE j.job_id = e.job_id
        )
    FROM jobs j
    ORDER BY j.job_title;
    v_numeJob JOBS.JOB_TITLE%TYPE;
    v_numeAngajat EMPLOYEES.LAST_NAME%TYPE;
    v_salariu EMPLOYEES.SALARY%TYPE;
    v_cursor refcursor;
  BEGIN
    OPEN c_jobs;
    LOOP
      FETCH c_jobs INTO v_numeJob,v_cursor;
      EXIT
    WHEN c_jobs%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE( '-------------------------------------------------' );
      DBMS_OUTPUT.PUT_LINE( v_numeJob || ':' );
      LOOP
        FETCH v_cursor INTO v_numeAngajat,v_salariu;
        EXIT
      WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( '               ' || v_numeAngajat || ' ' || v_salariu );
      END LOOP;
    END LOOP;
    CLOSE c_jobs;
  END;
  /
  /* Exercitiul 2 */
  /* Cursoare Clasice */
  DECLARE
    v_numeJob JOBS.JOB_TITLE%TYPE;
    v_numeAngajat EMPLOYEES.LAST_NAME%TYPE;
    v_salariu EMPLOYEES.SALARY%TYPE;
    v_jobCurent JOBS.JOB_TITLE%TYPE;
    v_numar_de_ordine        NUMBER(4) := 1;
    v_numarAngajati          NUMBER(5);
    v_salariuLunar           NUMBER(10);
    v_medieSalariuLunar      NUMBER(10);
    v_numarTotalAngajati     NUMBER(5);
    v_salariuLunarTotal      NUMBER(10);
    v_medieSalariuLunarTotal NUMBER(10);
    CURSOR c1
    IS
      SELECT COUNT(*) AS " Numar Total de Angajati ",
        SUM( salary ) AS " Salariu Total ",
        AVG( salary ) AS " Media Salariului "
      FROM employees;
    CURSOR c
    IS
      SELECT j.job_title AS " Nume Job ",
        e.last_name      AS " Nume Angajat ",
        e.salary         AS " Salariu ",
        (SELECT COUNT(*) FROM employees WHERE job_id =j.job_id
        ) AS " Numar Angajati Job ",
      (SELECT NVL(SUM(salary),0) FROM employees WHERE job_id =j.job_id
      ) AS " Salariu Lunar ",
      (SELECT NVL(AVG(salary),0) FROM employees WHERE job_id =j.job_id
      ) AS " Media Salariului "
    FROM employees e,
      jobs j
    WHERE j.job_id = e.job_id(+)
    ORDER BY j.job_title;
  BEGIN
    OPEN c1;
    FETCH c1
    INTO v_numarTotalAngajati,
      v_salariuLunarTotal,
      v_medieSalariuLunarTotal;
    DBMS_OUTPUT.PUT_LINE( v_numarTotalAngajati || ' - angajati, ' || v_salariuLunarTotal || ' - salariu total, ' || v_medieSalariuLunarTotal || ' - media salariului total lunar ' );
    CLOSE c1;
    OPEN c;
    LOOP
      FETCH c
      INTO v_numeJob,
        v_numeAngajat,
        v_salariu,
        v_numarAngajati,
        v_salariuLunar,
        v_medieSalariuLunar;
      EXIT
    WHEN c%NOTFOUND;
      IF v_jobCurent       = v_numeJob THEN
        v_numar_de_ordine := v_numar_de_ordine + 1;
        DBMS_OUTPUT.PUT_LINE( '               ' || v_numar_de_ordine || '. ' || v_numeAngajat || ' ' || v_salariu );
      ELSE
        v_numar_de_ordine := 1;
        DBMS_OUTPUT.PUT_LINE( '-------------------------------------------------' );
        DBMS_OUTPUT.PUT_LINE( v_numeJob || '( ' || v_numarAngajati || ' - angajati, ' || v_salariuLunar || ' - salariu lunar, ' || v_medieSalariuLunar || ' - media salariului lunar ' || ' )' || ':' );
        IF v_numeAngajat IS NOT NULL THEN
          DBMS_OUTPUT.PUT_LINE( '               ' || v_numar_de_ordine || '. ' || v_numeAngajat || ' ' || v_salariu );
          v_jobCurent := v_numeJob;
        END IF;
      END IF;
    END LOOP;
    CLOSE c;
  END;
  /
  /* Ciclu Cursoare */
  DECLARE
    v_jobCurent JOBS.JOB_TITLE%TYPE;
    v_numar_de_ordine        NUMBER(4) := 1;
    v_numarTotalAngajati     NUMBER(5);
    v_salariuLunarTotal      NUMBER(10);
    v_medieSalariuLunarTotal NUMBER(10);
    CURSOR c1
    IS
      SELECT COUNT(*) AS " Numar Total de Angajati ",
        SUM( salary ) AS " Salariu Total ",
        AVG( salary ) AS " Media Salariului "
      FROM employees;
    CURSOR c
    IS
      SELECT j.job_title AS " Nume Job ",
        e.last_name      AS " Nume Angajat ",
        e.salary         AS " Salariu ",
        (SELECT COUNT(*) FROM employees WHERE job_id =j.job_id
        ) AS " Numar Angajati Job ",
      (SELECT NVL(SUM(salary),0) FROM employees WHERE job_id =j.job_id
      ) AS " Salariu Lunar ",
      (SELECT NVL(AVG(salary),0) FROM employees WHERE job_id =j.job_id
      ) AS " Media Salariului "
    FROM employees e,
      jobs j
    WHERE j.job_id = e.job_id(+)
    ORDER BY j.job_title;
  BEGIN
    OPEN c1;
    FETCH c1
    INTO v_numarTotalAngajati,
      v_salariuLunarTotal,
      v_medieSalariuLunarTotal;
    DBMS_OUTPUT.PUT_LINE( v_numarTotalAngajati || ' - angajati, ' || v_salariuLunarTotal || ' - salariu total, ' || v_medieSalariuLunarTotal || ' - media salariului total lunar ' );
    CLOSE c1;
    FOR i IN c
    LOOP
      IF v_jobCurent       = i." Nume Job " THEN
        v_numar_de_ordine := v_numar_de_ordine + 1;
        DBMS_OUTPUT.PUT_LINE( '               ' || v_numar_de_ordine || '. ' || i." Nume Angajat " || ' ' || i." Salariu " );
      ELSE
        v_numar_de_ordine := 1;
        DBMS_OUTPUT.PUT_LINE( '-------------------------------------------------' );
        DBMS_OUTPUT.PUT_LINE( i." Nume Job " || '( ' || i." Numar Angajati Job " || ' - angajati, ' || i." Salariu Lunar " || ' - salariu lunar, ' || i." Media Salariului " || ' - media salariului lunar ' || ' )' || ':' );
        IF i." Nume Angajat " IS NOT NULL THEN
          DBMS_OUTPUT.PUT_LINE( '               ' || v_numar_de_ordine || '. ' || i." Nume Angajat " || ' ' || i." Salariu " );
          v_jobCurent := i." Nume Job ";
        END IF;
      END IF;
    END LOOP;
  END;
  /
  /* Ciclu cursoare cu subcereri */
  DECLARE
    v_numar_de_ordine NUMBER(4) := 1;
    v_jobCurent JOBS.JOB_TITLE%TYPE;
    v_numarTotalAngajati     NUMBER(5);
    v_salariuLunarTotal      NUMBER(10);
    v_medieSalariuLunarTotal NUMBER(10);
    CURSOR c1
    IS
      SELECT COUNT(*) AS " Numar Total de Angajati ",
        SUM( salary ) AS " Salariu Total ",
        AVG( salary ) AS " Media Salariului "
      FROM employees;
  BEGIN
    OPEN c1;
    FETCH c1
    INTO v_numarTotalAngajati,
      v_salariuLunarTotal,
      v_medieSalariuLunarTotal;
    DBMS_OUTPUT.PUT_LINE( v_numarTotalAngajati || ' - angajati, ' || v_salariuLunarTotal || ' - salariu total, ' || v_medieSalariuLunarTotal || ' - media salariului total lunar ' );
    CLOSE c1;
    FOR i IN
    (SELECT j.job_title AS " Nume Job ",
      e.last_name       AS " Nume Angajat ",
      e.salary          AS " Salariu ",
      (SELECT COUNT(*) FROM employees WHERE job_id =j.job_id
      ) AS " Numar Angajati Job ",
      (SELECT NVL(SUM(salary),0) FROM employees WHERE job_id =j.job_id
      ) AS " Salariu Lunar ",
      (SELECT NVL(AVG(salary),0) FROM employees WHERE job_id =j.job_id
      ) AS " Media Salariului "
    FROM employees e,
      jobs j
    WHERE j.job_id = e.job_id(+)
    ORDER BY j.job_title
    )
    LOOP
      IF v_jobCurent       = i." Nume Job " THEN
        v_numar_de_ordine := v_numar_de_ordine + 1;
        DBMS_OUTPUT.PUT_LINE( '               ' || v_numar_de_ordine || '. ' || i." Nume Angajat " || ' ' || i." Salariu " );
      ELSE
        v_numar_de_ordine := 1;
        DBMS_OUTPUT.PUT_LINE( '-------------------------------------------------' );
        DBMS_OUTPUT.PUT_LINE( i." Nume Job " || '( ' || i." Numar Angajati Job " || ' - angajati, ' || i." Salariu Lunar " || ' - salariu lunar, ' || i." Media Salariului " || ' - media salariului lunar ' || ' )' || ':' );
        IF i." Nume Angajat " IS NOT NULL THEN
          DBMS_OUTPUT.PUT_LINE( '               ' || v_numar_de_ordine || '. ' || i." Nume Angajat " || ' ' || i." Salariu " );
          v_jobCurent := i." Nume Job ";
        END IF;
      END IF;
    END LOOP;
  END;
  /
  /* Expresii cursor */
  DECLARE
    v_numarTotalAngajati     NUMBER(5);
    v_salariuLunarTotal      NUMBER(10);
    v_medieSalariuLunarTotal NUMBER(10);
    CURSOR c1
    IS
      SELECT COUNT(*) AS " Numar Total de Angajati ",
        SUM( salary ) AS " Salariu Total ",
        AVG( salary ) AS " Media Salariului "
      FROM employees;
  TYPE refcursor
IS
  REF
  CURSOR;
    CURSOR c_jobs
    IS
      SELECT j.job_title AS " Nume Job ",
        (SELECT COUNT(*) FROM employees WHERE job_id =j.job_id
        ) AS " Numar Angajati Job ",
      (SELECT NVL(SUM(salary),0) FROM employees WHERE job_id =j.job_id
      ) AS " Salariu Lunar ",
      (SELECT NVL(AVG(salary),0) FROM employees WHERE job_id =j.job_id
      ) AS " Media Salariului ",
      CURSOR
      (SELECT e.last_name AS " Nume Angajat ",
        e.salary          AS " Salariu "
      FROM employees e
      WHERE j.job_id = e.job_id
      )
    FROM jobs j
    ORDER BY j.job_title;
    v_numeJob JOBS.JOB_TITLE%TYPE;
    v_numeAngajat EMPLOYEES.LAST_NAME%TYPE;
    v_salariu EMPLOYEES.SALARY%TYPE;
    v_cursor refcursor;
    v_numar_de_ordine   NUMBER(4) := 1;
    v_numarAngajati     NUMBER(5);
    v_salariuLunar      NUMBER(10);
    v_medieSalariuLunar NUMBER(10);
  BEGIN
    OPEN c1;
    FETCH c1
    INTO v_numarTotalAngajati,
      v_salariuLunarTotal,
      v_medieSalariuLunarTotal;
    DBMS_OUTPUT.PUT_LINE( v_numarTotalAngajati || ' - angajati, ' || v_salariuLunarTotal || ' - salariu total, ' || v_medieSalariuLunarTotal || ' - media salariului total lunar ' );
    CLOSE c1;
    OPEN c_jobs;
    LOOP
      FETCH c_jobs
      INTO v_numeJob,
        v_numarAngajati,
        v_salariuLunar,
        v_medieSalariuLunar,
        v_cursor;
      EXIT
    WHEN c_jobs%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE( '-------------------------------------------------' );
      DBMS_OUTPUT.PUT_LINE( v_numeJob || '( ' || v_numarAngajati || ' - angajati, ' || v_salariuLunar || ' - salariu lunar, ' || v_medieSalariuLunar || ' - media salariului lunar ' || ' )' || ':' );
      v_numar_de_ordine := 1;
      LOOP
        FETCH v_cursor INTO v_numeAngajat,v_salariu;
        EXIT
      WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( '               ' || v_numar_de_ordine || '. ' || v_numeAngajat || ' ' || v_salariu );
        v_numar_de_ordine := v_numar_de_ordine + 1;
      END LOOP;
    END LOOP;
    CLOSE c_jobs;
  END;
  /
  /* Exercitiul 3 */
  /* Cursoare Clasice */
  DECLARE
    v_numeAngajat EMPLOYEES.LAST_NAME%TYPE;
    v_prenumeAngajat EMPLOYEES.FIRST_NAME%TYPE;
    v_salariu EMPLOYEES.SALARY%TYPE;
    v_procent         NUMBER(3,4);
    v_numar_de_ordine NUMBER(4) := 1;
    v_salariuTotal    NUMBER(10);
    CURSOR cursor1
    IS
      SELECT SUM( " Salariu Total " ) AS " Salariu Total "
      FROM
        (SELECT NVL(salary + salary * commission_pct,salary) AS " Salariu Total "
        FROM employees
        );
    CURSOR cursor2
    IS
      SELECT NVL(salary + salary * commission_pct,salary) AS " Salariu ",
        last_name                                         AS " Nume ",
        first_name                                        AS " Prenume "
      FROM employees;
  BEGIN
    -- Cursorul 1
    OPEN cursor1;
    FETCH cursor1 INTO v_salariuTotal;
    DBMS_OUTPUT.PUT_LINE( 'Salariu Total: ' || v_salariuTotal );
    CLOSE cursor1;
    -- Cursorul 2
    OPEN cursor2;
    LOOP
      FETCH cursor2 INTO v_salariu, v_numeAngajat, v_prenumeAngajat;
      EXIT
    WHEN cursor2%NOTFOUND;
      v_procent := v_salariu / v_salariuTotal;
      DBMS_OUTPUT.PUT_LINE( '            ' || v_numar_de_ordine || ': ' || v_numeAngajat || ' ' || v_prenumeAngajat || ' - ' || v_procent );
      v_numar_de_ordine := v_numar_de_ordine + 1;
    END LOOP;
    CLOSE cursor2;
  END;
  /
  /* Ciclu Cursoare */
  DECLARE
    v_numar_de_ordine NUMBER(4) := 1;
    v_salariuTotal    NUMBER(10);
    v_procent         NUMBER(3,4);
    CURSOR cursor1
    IS
      SELECT SUM( " Salariu Total " ) AS " Salariu Total "
      FROM
        (SELECT NVL(salary + salary * commission_pct,salary) AS " Salariu Total "
        FROM employees
        );
    CURSOR cursor2
    IS
      SELECT NVL(salary + salary * commission_pct,salary) AS " Salariu ",
        last_name                                         AS " Nume ",
        first_name                                        AS " Prenume "
      FROM employees;
  BEGIN
    -- Cursorul 1
    OPEN cursor1;
    FETCH cursor1 INTO v_salariuTotal;
    DBMS_OUTPUT.PUT_LINE( 'Salariu Total: ' || v_salariuTotal );
    CLOSE cursor1;
    -- Cursorul 2
    FOR i IN cursor2
    LOOP
      v_procent := i." Salariu " / v_salariuTotal;
      DBMS_OUTPUT.PUT_LINE( '            ' || v_numar_de_ordine || ': ' || i." Nume " || ' ' || i." Prenume " || ' - ' || v_procent );
      v_numar_de_ordine := v_numar_de_ordine + 1;
    END LOOP;
  END;
  /
  /* Ciclu cursoare cu subcereri */
  DECLARE
    v_numar_de_ordine NUMBER(4) := 1;
    v_salariuTotal    NUMBER(10);
    v_procent         NUMBER(3,4);
    CURSOR cursor1
    IS
      SELECT SUM( " Salariu Total " ) AS " Salariu Total "
      FROM
        (SELECT NVL(salary + salary * commission_pct,salary) AS " Salariu Total "
        FROM employees
        );
  BEGIN
    -- Cursorul 1
    OPEN cursor1;
    FETCH cursor1
    INTO v_salariuTotal;
    DBMS_OUTPUT.PUT_LINE( 'Salariu Total: ' || v_salariuTotal );
    CLOSE cursor1;
    -- Cursorul 2
    FOR i             IN
    (SELECT NVL(salary + salary * commission_pct,salary) AS " Salariu ",
      last_name                                          AS " Nume ",
      first_name                                         AS " Prenume "
    FROM employees
    )
    LOOP
      v_procent := i." Salariu " / v_salariuTotal;
      DBMS_OUTPUT.PUT_LINE( '            ' || v_numar_de_ordine || ': ' || i." Nume " || ' ' || i." Prenume " || ' - ' || v_procent );
      v_numar_de_ordine := v_numar_de_ordine + 1;
    END LOOP;
  END;
  /
  /* Expresii cursor */
  DECLARE
  TYPE refcursor
IS
  REF
  CURSOR;
    CURSOR cursor1
    IS
      SELECT " Salariu Total ",
        CURSOR
        (SELECT NVL(salary + salary * commission_pct,salary) AS " Salariu ",
          last_name                                          AS " Nume ",
          first_name                                         AS " Prenume "
        FROM employees
        )
    FROM
      (SELECT SUM( " Salariu Total " ) AS " Salariu Total "
      FROM
        (SELECT NVL(salary + salary * commission_pct,salary) AS " Salariu Total "
        FROM employees
        )
      );
    v_cursor refcursor;
    v_numeAngajat EMPLOYEES.LAST_NAME%TYPE;
    v_prenumeAngajat EMPLOYEES.FIRST_NAME%TYPE;
    v_salariu EMPLOYEES.SALARY%TYPE;
    v_procent         NUMBER(3,4);
    v_numar_de_ordine NUMBER(4) := 1;
    v_salariuTotal    NUMBER(10);
  BEGIN
    OPEN cursor1;
    LOOP
      FETCH cursor1 INTO v_salariuTotal,v_cursor;
      EXIT
    WHEN cursor1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE( 'Salariu Total: ' || v_salariuTotal );
      LOOP
        FETCH v_cursor INTO v_salariu,v_numeAngajat,v_prenumeAngajat;
        EXIT
      WHEN v_cursor%NOTFOUND;
        v_procent := v_salariu / v_salariuTotal;
        DBMS_OUTPUT.PUT_LINE( '            ' || v_numar_de_ordine || ': ' || v_numeAngajat || ' ' || v_prenumeAngajat || ' - ' || v_procent );
        v_numar_de_ordine := v_numar_de_ordine + 1;
      END LOOP;
    END LOOP;
    CLOSE cursor1;
  END;
  /
  /* Exercitiul 4 */
  /* Cursoare Clasice */
  /* Ciclu Cursoare */
  /* Ciclu cursoare cu subcereri */
  /* Expresii cursor */
  DECLARE
  TYPE refcursor
IS
  REF
  CURSOR;
    CURSOR cursor1
    IS
      SELECT j.job_title,
        CURSOR
        (SELECT last_name AS " Nume ",
          first_name      AS " Prenume ",
          salary AS " Salariu "
        FROM employees
        WHERE job_id = j.job_id
        AND ROWNUM <= 5
        ORDER BY salary DESC
        )
    FROM jobs j;
    v_cursor refcursor;
    v_numeAngajat EMPLOYEES.LAST_NAME%TYPE;
    v_prenumeAngajat EMPLOYEES.FIRST_NAME%TYPE;
    v_job JOBS.JOB_TITLE%TYPE;
    v_salariu EMPLOYEES.SALARY%TYPE;
    v_numar_de_ordine NUMBER(4) := 1;
  BEGIN
    OPEN cursor1;
    LOOP
      FETCH cursor1 INTO v_job,v_cursor;
      EXIT
    WHEN cursor1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE( v_job );
      v_numar_de_ordine := 1;
      LOOP
        FETCH v_cursor INTO v_numeAngajat,v_prenumeAngajat,v_salariu;
        EXIT
      WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE( '            ' || v_numar_de_ordine || ': ' || v_numeAngajat || ' ' || v_prenumeAngajat || ' - ' || v_salariu );
        v_numar_de_ordine := v_numar_de_ordine + 1;
      END LOOP;
      FOR i IN v_numar_de_ordine..5 LOOP
        DBMS_OUTPUT.PUT_LINE( '            ' || v_numar_de_ordine || ': ' );
        v_numar_de_ordine := v_numar_de_ordine + 1;
      END LOOP;
    END LOOP;
    CLOSE cursor1;
  END;
  / 
  /* Exercitiul 5 */
  /* Cursoare Clasice */
  /* Ciclu Cursoare */
  /* Ciclu cursoare cu subcereri */
  /* Expresii cursor */
  DECLARE
  TYPE refcursor
IS
  REF
  CURSOR;
    CURSOR cursor1
    IS
      SELECT j.job_title,
        CURSOR
        (SELECT last_name AS " Nume ",
          first_name      AS " Prenume ",
          salary AS " Salariu "
        FROM employees
        WHERE job_id = j.job_id
        ORDER BY salary DESC
        )
    FROM jobs j;
    v_cursor refcursor;
    v_numeAngajat EMPLOYEES.LAST_NAME%TYPE;
    v_prenumeAngajat EMPLOYEES.FIRST_NAME%TYPE;
    v_job JOBS.JOB_TITLE%TYPE;
    v_salariu EMPLOYEES.SALARY%TYPE;
    v_numar_de_ordine NUMBER(4) := 1;
    v_salariu2 EMPLOYEES.SALARY%TYPE;
  BEGIN
    OPEN cursor1;
    LOOP
      FETCH cursor1 INTO v_job,v_cursor;
      EXIT
    WHEN cursor1%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE( v_job );
      v_numar_de_ordine := 1;
      
      -- Scriem primii 5 angajati care castiga cel mai mult
      LOOP
        FETCH v_cursor INTO v_numeAngajat,v_prenumeAngajat,v_salariu;
        EXIT WHEN v_cursor%NOTFOUND OR v_numar_de_ordine >= 6;
          DBMS_OUTPUT.PUT_LINE( '            ' || v_numar_de_ordine || ': ' || v_numeAngajat || ' ' || v_prenumeAngajat || ' - ' || v_salariu );
          v_numar_de_ordine := v_numar_de_ordine + 1;
      END LOOP;
      
      v_salariu2 := v_salariu;
      -- Cazul in care avem mai multi angajati cu acelasi salariu
      LOOP
        FETCH v_cursor INTO v_numeAngajat,v_prenumeAngajat,v_salariu;
        EXIT WHEN v_cursor%NOTFOUND OR v_salariu <> v_salariu2;
          DBMS_OUTPUT.PUT_LINE( '            ' || v_numar_de_ordine || ': ' || v_numeAngajat || ' ' || v_prenumeAngajat || ' - ' || v_salariu );
          v_numar_de_ordine := v_numar_de_ordine + 1;
      END LOOP;
      
      -- Cazul in care v_cursor%NOTFOUND
      FOR i IN v_numar_de_ordine..5 LOOP
        DBMS_OUTPUT.PUT_LINE( '            ' || v_numar_de_ordine || ': ' );
        v_numar_de_ordine := v_numar_de_ordine + 1;
      END LOOP;
      
    END LOOP;
    CLOSE cursor1;
  END;
  /