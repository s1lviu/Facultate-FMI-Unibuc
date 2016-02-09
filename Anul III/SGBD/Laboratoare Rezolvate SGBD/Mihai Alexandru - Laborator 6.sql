/* Exercitiul 1 */
CREATE OR REPLACE TRIGGER validare_utilizator BEFORE
  DELETE ON departments BEGIN IF USER = UPPER('c##alex') THEN RAISE_APPLICATION_ERROR(-20900,'Nu ai voie sa stergi!');
END IF;
END;
/
DELETE FROM departments WHERE department_id = 100;
/* Exercitiul 2 */
CREATE OR REPLACE TRIGGER validare_comision BEFORE
  UPDATE OF commission_pct ON employees FOR EACH ROW BEGIN IF (:NEW.commission_pct > 0.5) THEN RAISE_APPLICATION_ERROR(-20900,'Valoarea comisionul incorecta!');
END IF;
END;
/
UPDATE employees SET commission_pct = NVL(commission_pct,0) + 0.2;
ROLLBACK;
/* Exercitiul 3 */
/* a */
ALTER TABLE info_dept_a ADD numar NUMBER(5);
UPDATE info_dept_a i
SET numar =
  (SELECT COUNT(e.employee_id)
  FROM employees e
  WHERE e.department_id = i.department_id
  );
/* b */
CREATE OR REPLACE PROCEDURE modific_dept(
    v_old departments.department_id%TYPE,
    v_new departments.department_id%TYPE )
AS
BEGIN
  UPDATE info_dept_a SET numar = numar + 1 WHERE department_id = v_new;
  UPDATE info_dept_a SET numar = numar - 1 WHERE department_id = v_old;
END;
/
CREATE OR REPLACE TRIGGER actualizare_numar_angajati AFTER
  INSERT OR
  DELETE OR
  UPDATE ON info_emp_a FOR EACH ROW BEGIN IF DELETING THEN modific_dept(:OLD.department_id, NULL);
ELSIF UPDATING THEN
  modific_dept(:OLD.department_id, :NEW.department_id);
ELSE
  modific_dept(NULL, :NEW.department_id);
END IF;
END;
/
DELETE FROM info_emp_a WHERE employee_id = 100;
UPDATE info_emp_a SET department_id = 10 WHERE employee_id = 100;
/* Exercitiul 4 */
CREATE OR REPLACE TRIGGER validare_numar_angajati BEFORE
  INSERT OR
  UPDATE ON info_emp_a FOR EACH ROW DECLARE numar_angajati NUMBER(5);
  BEGIN
    SELECT COUNT(*)
    INTO numar_angajati
    FROM info_emp_a
    WHERE department_id = :NEW.department_id;
    IF numar_angajati  >= 45 THEN
      RAISE_APPLICATION_ERROR(-20900,'Nu pot exista mai mult de 45 de angajati in acest departament!');
    END IF;
  END;
  /
  INSERT
  INTO info_emp_a VALUES
    (
      1000,
      'first_name',
      'last_name',
      'email',
      NULL,
      SYSDATE,
      'AD_PRES',
      30000,
      NULL,
      NULL,
      50
    );
  ROLLBACK;
  /* Exercitiul 5 */
  /* a */
  CREATE TABLE emp_test_a AS
  SELECT employee_id,last_name,first_name,department_id FROM employees;
  ALTER TABLE emp_test_a ADD PRIMARY KEY (employee_id);
  CREATE TABLE dept_test_a AS
  SELECT department_id,department_name FROM departments;
  ALTER TABLE dept_test_a ADD PRIMARY KEY (department_id);
  /* b */
  /* Nu este definita constrangerea de cheie externa */
CREATE OR REPLACE TRIGGER sterge_cascada AFTER
  UPDATE OR
  DELETE ON dept_test_a FOR EACH ROW BEGIN IF DELETING THEN
  DELETE FROM emp_test_a WHERE department_id = :OLD.department_id;
ELSE
  UPDATE emp_test_a
  SET department_id   = :NEW.department_id
  WHERE department_id = :OLD.department_id;
END IF;
END;
/
DELETE FROM dept_test_a WHERE department_id = 10;
ROLLBACK;
UPDATE dept_test_a SET department_id = 11 WHERE department_id = 10;
ROLLBACK;
/* Este definita constrangerea de cheie externa */
/* asemanator cu triggerul de mai sus */
ALTER TABLE emp_test_a ADD CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES dept_test_a (department_id);
DELETE FROM dept_test_a WHERE department_id = 10;
ROLLBACK;
UPDATE dept_test_a SET department_id = 11 WHERE department_id = 10;
ROLLBACK;
/* ON DELETE CASCADE */
/* nu mai este nevoie sa adaugam before delete */
ALTER TABLE emp_test_a
DROP CONSTRAINT fk_emp_dept;
ALTER TABLE emp_test_a ADD CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES dept_test_a (department_id) ON
DELETE CASCADE;
CREATE OR REPLACE TRIGGER sterge_cascada BEFORE
  UPDATE ON dept_test_a FOR EACH ROW BEGIN
  UPDATE emp_test_a
  SET department_id   = :NEW.department_id
  WHERE department_id = :OLD.department_id;
END;
/
DELETE FROM dept_test_a WHERE department_id = 10;
ROLLBACK;
UPDATE dept_test_a SET department_id = 11 WHERE department_id = 10;
ROLLBACK;
/* ON DELETE SET NULL */
/* asemanator ca la ON DELETE CASCADE */
ALTER TABLE emp_test_a
DROP CONSTRAINT fk_emp_dept;
ALTER TABLE emp_test_a ADD CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES dept_test_a (department_id) ON
DELETE SET NULL;
CREATE OR REPLACE TRIGGER sterge_cascada BEFORE
  UPDATE ON dept_test_a FOR EACH ROW BEGIN
  UPDATE emp_test_a
  SET department_id   = :NEW.department_id
  WHERE department_id = :OLD.department_id;
END;
/
DELETE FROM dept_test_a WHERE department_id = 10;
DROP TRIGGER sterge_cascada;
ROLLBACK;
UPDATE dept_test_a SET department_id = 11 WHERE department_id = 10;
ROLLBACK;
/* Exercitiul 6 */
/* a */
CREATE TABLE erori
  (
    user_id VARCHAR2(30),
    nume_bd VARCHAR2(50),
    erori   VARCHAR2(2000),
    data    DATE
  );
/* b */
CREATE OR REPLACE TRIGGER log_erori AFTER SERVERERROR ON DATABASE
  BEGIN
    INSERT
    INTO erori VALUES
      (
        SYS.LOGIN_USER,
        SYS.DATABASE_NAME,
        DBMS_UTILITY.FORMAT_ERROR_STACK,
        SYSDATE
      );
  END;
  /
  SELECT * FROM erori;