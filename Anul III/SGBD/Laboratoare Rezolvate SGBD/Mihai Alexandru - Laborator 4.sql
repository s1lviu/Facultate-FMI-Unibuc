/* Exercitiul 1 */
CREATE TABLE info_abc
  (
    utilizator VARCHAR2(20),
    data       DATE,
    comanda    VARCHAR2(1500),
    nr_linii   NUMBER(5),
    eroare     VARCHAR2(100)
  );
/* Exercitiul 2 */
CREATE OR REPLACE FUNCTION f2_abc
  (
    v_nume employees.last_name%TYPE DEFAULT 'Bell'
  )
  RETURN NUMBER
IS
  salariu employees.salary%type;
BEGIN
  SELECT salary INTO salariu FROM employees WHERE last_name = v_nume;
  INSERT
  INTO info_abc VALUES
    (
      v_nume,
      SYSDATE,
      (SELECT text FROM USER_SOURCE WHERE NAME = UPPER('f2_abc')
      ),
      1,
      NULL
    );
  RETURN salariu;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  INSERT
  INTO info_abc VALUES
    (
      v_nume,
      SYSDATE,
      (SELECT text FROM USER_SOURCE WHERE NAME = UPPER('f2_abc')
      ) ,
      0,
      'Nu exista angajati cu numele dat'
    );
  RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
  DBMS_OUTPUT.PUT_LINE('a');
WHEN TOO_MANY_ROWS THEN
  INSERT
  INTO info_abc VALUES
    (
      v_nume,
      SYSDATE,
      (SELECT text FROM USER_SOURCE WHERE NAME = UPPER('f2_abc')
      ) ,
      (SELECT COUNT(*) FROM employees WHERE last_name = v_nume
      ) ,
      'Exista mai multi angajati cu numele dat'
    );
  RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR( -20002,'Alta eroare!');
END f2_abc;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE('Salariul este '|| f2_abc('King'));
END;
/
/* Exercitiul 3 */
/* Merge doar daca scriem codul pe o singura linie deoarece acel select text ne intoarce mai multe linii */
CREATE OR REPLACE FUNCTION numar_angajati
  (
    v_city locations.city%TYPE DEFAULT 'Seattle'
  )
  RETURN NUMBER
IS
  nr_angajati NUMBER(5);
  exista_oras NUMBER(1);
BEGIN
  SELECT COUNT(*) INTO exista_oras FROM locations l WHERE l.city = v_city;
  IF exista_oras = 1 THEN
    SELECT COUNT(*)
    INTO nr_angajati
    FROM
      (SELECT employee_id
      FROM employees e,
        departments d,
        locations l
      WHERE e.department_id = d.department_id
      AND l.location_id     = d.location_id
      AND 2                <=
        (SELECT COUNT(*) FROM job_history jh WHERE jh.employee_id = e.employee_id
        )
      AND l.city = v_city
      );
    IF nr_angajati = 0 THEN
      INSERT
      INTO info_abc VALUES
        (
          v_city,
          SYSDATE,
          (SELECT text FROM USER_SOURCE WHERE NAME = UPPER('numar_angajati')
          ),
          1,
          'Nu sunt angajati in orasul dat'
        );
    END IF;
  ELSE
    INSERT
    INTO info_abc VALUES
      (
        v_city,
        SYSDATE,
        (SELECT text FROM USER_SOURCE WHERE NAME = UPPER('numar_angajati')
        ),
        0,
        'Nu exista orasul dat'
      );
  END IF;
RETURN nr_angajati;
END numar_angajati;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE('Nr Angajati este '|| numar_angajati('Roma'));
END;
/
/* Exercitiul 4 */
/* Merge doar daca scriem codul pe o singura linie deoarece acel select text ne intoarce mai multe linii */
CREATE OR REPLACE PROCEDURE crestere_salariu
    (
      v_manager employees.manager_id%TYPE
    )
  IS
    exista_manager NUMBER(3);
  BEGIN
    SELECT COUNT(*)
    INTO exista_manager
    FROM
      (SELECT employee_id
      FROM employees
        START WITH manager_id        = v_manager
        CONNECT BY PRIOR employee_id = manager_id
      );
    IF exista_manager > 0 THEN
      UPDATE employees
      SET salary         = salary + 10 * salary / 100
      WHERE employee_id          IN
        (SELECT employee_id
        FROM employees
          START WITH manager_id        = v_manager
          CONNECT BY PRIOR employee_id = manager_id
        );
      INSERT
      INTO info_abc VALUES
        (
          TO_CHAR(v_manager),
          SYSDATE,
          (SELECT text FROM USER_SOURCE WHERE NAME = UPPER('crestere_salariu')
          ),
          exista_manager ,
          NULL
        );
    ELSE
      INSERT
      INTO info_abc VALUES
        (
          TO_CHAR(v_manager),
          SYSDATE,
          (SELECT text FROM USER_SOURCE WHERE NAME = UPPER('crestere_salariu')
          ),
          0 ,
          'Nu este managerul cu acest id'
        );
    END IF;
  END crestere_salariu;
/
BEGIN
  crestere_salariu(100);
END;
/
/* Exercitiul 5 */
/* Varianta 1 - fara sa se tina cont de istoricul joburilor */
CREATE OR REPLACE PROCEDURE zi_angajati
  IS
  TYPE refcursor
IS
  REF
  CURSOR;
    CURSOR c_dept
    IS
      SELECT d.department_name AS " Nume Departament ",
        z." Zi "               AS " Zi ",
        CURSOR
        (SELECT first_name                                              AS " Prenume ",
          SYSDATE                    - hire_date                        AS " Vechime ",
          NVL2(commission_pct,salary + salary * commission_pct, salary) AS " Venit "
        FROM employees
        WHERE department_id        = d.department_id
        AND TO_CHAR(hire_date,'d') = z." Zi "
        )
    FROM departments d,
      (SELECT d1.department_id AS " Id Departament ",
        CASE
            (SELECT COUNT(*) FROM employees e WHERE e.department_id = d1.department_id
            )
          WHEN 0
          THEN 0
          ELSE
            (SELECT MIN(" Zi ")
            FROM
              (SELECT
                CASE zi
                  WHEN 1
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 1
                    )
                  WHEN 2
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 2
                    )
                  WHEN 3
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 3
                    )
                  WHEN 4
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 4
                    )
                  WHEN 5
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 5
                    )
                  WHEN 6
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 6
                    )
                  WHEN 7
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 7
                    )
                END AS " Numar Angajati ",
                zi  AS " Zi "
              FROM
                (SELECT 1 AS zi FROM dual
                UNION
                SELECT 2 AS zi FROM dual
                UNION
                SELECT 3 AS zi FROM dual
                UNION
                SELECT 4 AS zi FROM dual
                UNION
                SELECT 5 AS zi FROM dual
                UNION
                SELECT 6 AS zi FROM dual
                UNION
                SELECT 7 AS zi FROM dual
                )
              )
            WHERE " Numar Angajati " =
              (SELECT MAX(" Numar Angajati ")
              FROM
                (SELECT
                  CASE zi
                    WHEN 1
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 1
                      )
                    WHEN 2
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 2
                      )
                    WHEN 3
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 3
                      )
                    WHEN 4
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 4
                      )
                    WHEN 5
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 5
                      )
                    WHEN 6
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 6
                      )
                    WHEN 7
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 7
                      )
                  END AS " Numar Angajati ",
                  zi  AS " Zi "
                FROM
                  (SELECT 1 AS zi FROM dual
                  UNION
                  SELECT 2 AS zi FROM dual
                  UNION
                  SELECT 3 AS zi FROM dual
                  UNION
                  SELECT 4 AS zi FROM dual
                  UNION
                  SELECT 5 AS zi FROM dual
                  UNION
                  SELECT 6 AS zi FROM dual
                  UNION
                  SELECT 7 AS zi FROM dual
                  )
                )
              )
            )
        END AS " Zi "
      FROM departments d1
      ) z
    WHERE z." Id Departament " = d.department_id;
    v_nume_departament departments.department_name%TYPE;
    v_numar_zi NUMBER(1);
    v_cursor refcursor;
    v_first_name employees.first_name%TYPE;
    v_vechime NUMBER(10,2);
    v_venit   NUMBER(10,2);
  BEGIN
    OPEN c_dept;
    LOOP
      FETCH c_dept INTO v_nume_departament, v_numar_zi, v_cursor;
      EXIT
    WHEN c_dept%NOTFOUND;
      IF v_numar_zi = 0 THEN
        DBMS_OUTPUT.PUT_LINE( 'Nu exista angajati in -> ' || v_nume_departament );
      ELSE
        DBMS_OUTPUT.PUT_LINE( v_numar_zi || ' -> ' || v_nume_departament );
        LOOP
          FETCH v_cursor INTO v_first_name, v_vechime, v_venit;
          EXIT
        WHEN v_cursor%NOTFOUND;
          DBMS_OUTPUT.PUT_LINE( '               ' || v_first_name || ' - ' || v_vechime || ' - ' || v_venit );
        END LOOP;
      END IF;
    END LOOP;
    CLOSE c_dept;
  END zi_angajati;
/
BEGIN
  zi_angajati;
END;
/

CREATE OR REPLACE PROCEDURE zi_angajati_5b
IS 
  TYPE tablou_imbricat_numar_zi IS TABLE OF NUMBER(1);
  tablou_zi tablou_imbricat_numar_zi := tablou_imbricat_numar_zi();
  TYPE tablou_imbricat_departament IS TABLE OF departments.department_id%TYPE;
  tablou_departament tablou_imbricat_departament := tablou_imbricat_departament();
  
  CURSOR cursor_departamente IS
    SELECT department_name AS " Nume Departament ",
      department_id AS " ID Departament "
      FROM departments;
  
  v_lista_angajati employees%ROWTYPE;
  v_numar_zi NUMBER(1);
  v_numar_angajati NUMBER(5);
  v_numar_angajati_zi NUMBER(5);
  v_id_departament departments.department_id%TYPE;
  v_nume_departament departments.department_name%TYPE;
  v_numar_departamente NUMBER(2);
BEGIN
  OPEN cursor_departamente;
  
  -- Cautam numarul de departamente;
  SELECT COUNT(*)
  INTO v_numar_departamente
  FROM departments;
  
  FOR k IN 1..v_numar_departamente LOOP
    FETCH cursor_departamente INTO v_nume_departament, v_id_departament;
    DBMS_OUTPUT.PUT_LINE('-------------------------  ' || v_nume_departament || '  -------------------------');
    -- Cautam ziua din saptamana cu cei mai multi angajati;
    v_numar_angajati := 0;
    v_numar_zi := 0;
    FOR i IN 1..7 LOOP
      -- Selectam numarul de angajati din ziua a i-a
      SELECT COUNT(*)
      INTO v_numar_angajati_zi
      FROM employees
      WHERE department_id = v_id_departament
      AND TO_CHAR(hire_date,'d') = i;
      IF v_numar_angajati < v_numar_angajati_zi THEN
        v_numar_angajati := v_numar_angajati_zi;
        v_numar_zi := i;
      END IF;
      DBMS_OUTPUT.PUT_LINE('       ' || ' Ziua ' || i || ' -> ' || v_numar_angajati_zi || ' angajati');
    END LOOP;
    
    IF v_numar_angajati = 0 THEN
      DBMS_OUTPUT.PUT_LINE(' ### In departamentul ' || v_nume_departament || ' nu lucreaza nimeni ###');
    END IF;
    -- Memoram numarul de angajati si ziua in care au fost angajati cei mai multi muncitori;
    tablou_zi.extend;
    tablou_departament.extend;
    tablou_zi(k) := v_numar_zi;
    tablou_departament(k) := v_id_departament;
    
  END LOOP;
  -- Inchidem cursorul( nu ne mai trebuie );
  CLOSE cursor_departamente;
  
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE('Lista angajati: ');
  FOR k IN 1..v_numar_departamente LOOP
    FOR i IN (SELECT first_name AS " Prenume ",
            SYSDATE - hire_date AS " Vechime ",
              NVL2(commission_pct, salary + salary * commission_pct, salary) AS " Venit "
        FROM employees
        WHERE department_id = tablou_departament(k)
        AND TO_CHAR(hire_date,'d') = tablou_zi(k)) LOOP
        DBMS_OUTPUT.PUT_LINE(i." Prenume " || ' -> ' || i." Vechime " || ' -> ' || i." Venit " );
    END LOOP;
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
  
END zi_angajati_5b;
/
BEGIN
  zi_angajati_5b;
END;
/
/* Exercitiul 6 */
CREATE OR REPLACE PROCEDURE zi_angajati_6
  IS
  TYPE refcursor
IS
  REF
  CURSOR;
    CURSOR c_dept
    IS
      SELECT d.department_name AS " Nume Departament ",
        z." Zi "               AS " Zi ",
        CURSOR
        (SELECT first_name                                              AS " Prenume ",
          SYSDATE                    - hire_date                        AS " Vechime ",
          NVL2(commission_pct,salary + salary * commission_pct, salary) AS " Venit "
        FROM employees
        WHERE department_id        = d.department_id
        AND TO_CHAR(hire_date,'d') = z." Zi "
        ORDER BY " Vechime " DESC
        )
    FROM departments d,
      (SELECT d1.department_id AS " Id Departament ",
        CASE
            (SELECT COUNT(*) FROM employees e WHERE e.department_id = d1.department_id
            )
          WHEN 0
          THEN 0
          ELSE
            (SELECT MIN(" Zi ")
            FROM
              (SELECT
                CASE zi
                  WHEN 1
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 1
                    )
                  WHEN 2
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 2
                    )
                  WHEN 3
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 3
                    )
                  WHEN 4
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 4
                    )
                  WHEN 5
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 5
                    )
                  WHEN 6
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 6
                    )
                  WHEN 7
                  THEN
                    (SELECT COUNT(*)
                    FROM employees e
                    WHERE e.department_id        = d1.department_id
                    AND TO_CHAR(e.hire_date,'d') = 7
                    )
                END AS " Numar Angajati ",
                zi  AS " Zi "
              FROM
                (SELECT 1 AS zi FROM dual
                UNION
                SELECT 2 AS zi FROM dual
                UNION
                SELECT 3 AS zi FROM dual
                UNION
                SELECT 4 AS zi FROM dual
                UNION
                SELECT 5 AS zi FROM dual
                UNION
                SELECT 6 AS zi FROM dual
                UNION
                SELECT 7 AS zi FROM dual
                )
              )
            WHERE " Numar Angajati " =
              (SELECT MAX(" Numar Angajati ")
              FROM
                (SELECT
                  CASE zi
                    WHEN 1
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 1
                      )
                    WHEN 2
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 2
                      )
                    WHEN 3
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 3
                      )
                    WHEN 4
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 4
                      )
                    WHEN 5
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 5
                      )
                    WHEN 6
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 6
                      )
                    WHEN 7
                    THEN
                      (SELECT COUNT(*)
                      FROM employees e
                      WHERE e.department_id        = d1.department_id
                      AND TO_CHAR(e.hire_date,'d') = 7
                      )
                  END AS " Numar Angajati ",
                  zi  AS " Zi "
                FROM
                  (SELECT 1 AS zi FROM dual
                  UNION
                  SELECT 2 AS zi FROM dual
                  UNION
                  SELECT 3 AS zi FROM dual
                  UNION
                  SELECT 4 AS zi FROM dual
                  UNION
                  SELECT 5 AS zi FROM dual
                  UNION
                  SELECT 6 AS zi FROM dual
                  UNION
                  SELECT 7 AS zi FROM dual
                  )
                )
              )
            )
        END AS " Zi "
      FROM departments d1
      ) z
    WHERE z." Id Departament " = d.department_id;
    v_nume_departament departments.department_name%TYPE;
    v_numar_zi NUMBER(1);
    v_cursor refcursor;
    v_first_name employees.first_name%TYPE;
    v_vechime  NUMBER(10,2);
    v_vechime2 NUMBER(10,2) := 0;
    v_venit    NUMBER(10,2);
    v_pozitie  NUMBER(5);
  BEGIN
    OPEN c_dept;
    LOOP
      FETCH c_dept INTO v_nume_departament, v_numar_zi, v_cursor;
      EXIT
    WHEN c_dept%NOTFOUND;
      IF v_numar_zi = 0 THEN
        DBMS_OUTPUT.PUT_LINE( 'Nu exista angajati in -> ' || v_nume_departament );
      ELSE
        v_pozitie := 0;
        DBMS_OUTPUT.PUT_LINE( v_numar_zi || ' -> ' || v_nume_departament );
        LOOP
          FETCH v_cursor INTO v_first_name, v_vechime, v_venit;
          EXIT
        WHEN v_cursor%NOTFOUND;
          IF v_vechime2 <> v_vechime THEN
            v_pozitie   := v_pozitie + 1;
            v_vechime2  := v_vechime;
            DBMS_OUTPUT.PUT_LINE( '               ' || v_pozitie || '. ' || v_first_name || ' - ' || v_vechime || ' - ' || v_venit );
          ELSE
            DBMS_OUTPUT.PUT_LINE( '               ' || v_pozitie || '. ' || v_first_name || ' - ' || v_vechime || ' - ' || v_venit );
          END IF;
        END LOOP;
      END IF;
    END LOOP;
    CLOSE c_dept;
  END zi_angajati_6;
/
BEGIN
  zi_angajati_6;
END;
/

CREATE OR REPLACE PROCEDURE zi_angajati_6b
IS 
  TYPE tablou_imbricat_numar_zi IS TABLE OF NUMBER(1);
  tablou_zi tablou_imbricat_numar_zi := tablou_imbricat_numar_zi();
  TYPE tablou_imbricat_departament IS TABLE OF departments.department_id%TYPE;
  tablou_departament tablou_imbricat_departament := tablou_imbricat_departament();
  
  CURSOR cursor_departamente IS
    SELECT department_name AS " Nume Departament ",
      department_id AS " ID Departament "
      FROM departments;
  
  v_lista_angajati employees%ROWTYPE;
  v_numar_zi NUMBER(1);
  v_numar_angajati NUMBER(5);
  v_numar_angajati_zi NUMBER(5);
  v_id_departament departments.department_id%TYPE;
  v_nume_departament departments.department_name%TYPE;
  v_numar_departamente NUMBER(2);
  v_index NUMBER(2);
  v_vechime NUMBER(10);
  v_vechime2 NUMBER(10);
BEGIN
  OPEN cursor_departamente;
  
  -- Cautam numarul de departamente;
  SELECT COUNT(*)
  INTO v_numar_departamente
  FROM departments;
  
  FOR k IN 1..v_numar_departamente LOOP
    FETCH cursor_departamente INTO v_nume_departament, v_id_departament;
    DBMS_OUTPUT.PUT_LINE('-------------------------  ' || v_nume_departament || '  -------------------------');
    -- Cautam ziua din saptamana cu cei mai multi angajati;
    v_numar_angajati := 0;
    v_numar_zi := 0;
    FOR i IN 1..7 LOOP
      -- Selectam numarul de angajati din ziua a i-a
      SELECT COUNT(*)
      INTO v_numar_angajati_zi
      FROM employees
      WHERE department_id = v_id_departament
      AND TO_CHAR(hire_date,'d') = i;
      IF v_numar_angajati < v_numar_angajati_zi THEN
        v_numar_angajati := v_numar_angajati_zi;
        v_numar_zi := i;
      END IF;
      DBMS_OUTPUT.PUT_LINE('       ' || ' Ziua ' || i || ' -> ' || v_numar_angajati_zi || ' angajati');
    END LOOP;
    
    IF v_numar_angajati = 0 THEN
      DBMS_OUTPUT.PUT_LINE(' ### In departamentul ' || v_nume_departament || ' nu lucreaza nimeni ###');
    END IF;
    -- Memoram numarul de angajati si ziua in care au fost angajati cei mai multi muncitori;
    tablou_zi.extend;
    tablou_departament.extend;
    tablou_zi(k) := v_numar_zi;
    tablou_departament(k) := v_id_departament;
    
  END LOOP;
  -- Inchidem cursorul( nu ne mai trebuie );
  CLOSE cursor_departamente;
  
  DBMS_OUTPUT.NEW_LINE;
  DBMS_OUTPUT.PUT_LINE('Lista angajati: ');
  FOR k IN 1..v_numar_departamente LOOP
    v_index := 0;
    DBMS_OUTPUT.PUT_LINE(' ---- ' || tablou_departament(k) || ' ---- ' );
    FOR i IN (SELECT first_name AS " Prenume ",
            SYSDATE - hire_date AS " Vechime ",
              NVL2(commission_pct, salary + salary * commission_pct, salary) AS " Venit "
        FROM employees
        WHERE department_id = tablou_departament(k)
        AND TO_CHAR(hire_date,'d') = tablou_zi(k)
        ORDER BY " Vechime " DESC) LOOP
        v_vechime := i." Vechime ";
        IF v_vechime2 = v_vechime THEN
          DBMS_OUTPUT.PUT_LINE(v_index || '. ' || i." Prenume " || ' -> ' || i." Vechime " || ' -> ' || i." Venit " );
        ELSE 
          v_index := v_index + 1;
          DBMS_OUTPUT.PUT_LINE(v_index || '. ' || i." Prenume " || ' -> ' || i." Vechime " || ' -> ' || i." Venit " );
          v_vechime2 := v_vechime;
        END IF;
    END LOOP;
  END LOOP;
  DBMS_OUTPUT.NEW_LINE;
  
END zi_angajati_6b;
/
BEGIN
  zi_angajati_6b;
END;
/