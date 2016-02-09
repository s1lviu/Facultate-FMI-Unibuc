/* Exercitiul 1 */
CREATE TABLE error_a
  (cod NUMBER, mesaj VARCHAR2(100)
  );
/* Definirea exceptiei de catre utilizator */
DECLARE
  exceptie EXCEPTION;
  v_cod error_a.cod%TYPE;
  v_mesaj error_a.mesaj%TYPE;
  v_numar NUMBER := &p;
BEGIN
  IF v_numar < 0 THEN
    RAISE exceptie;
  ELSE
    DBMS_OUTPUT.PUT_LINE(SQRT(v_numar));
  END IF;
EXCEPTION
WHEN exceptie THEN
  v_cod   := -20001;
  v_mesaj := 'Numarul negativ nu este permis';
  INSERT INTO error_a VALUES
    (v_cod,v_mesaj
    );
END;
/
/* Capturarea erorii interne a sistemului */
DECLARE
  v_cod error_a.cod%TYPE;
  v_mesaj error_a.mesaj%TYPE;
  v_numar NUMBER := &p;
BEGIN
  DBMS_OUTPUT.PUT_LINE(SQRT(v_numar));
EXCEPTION
WHEN OTHERS THEN
  v_cod   := SQLCODE;
  v_mesaj := SUBSTR(SQLERRM,1,100);
  INSERT INTO error_a VALUES
    (v_cod,v_mesaj
    );
END;
/
SELECT * FROM error_a;
/* Exercitiul 2 */
DECLARE
  v_first_name employees.first_name%TYPE;
  v_last_name employees.last_name%TYPE;
  v_salary employees.salary%TYPE := &p;
BEGIN
  SELECT first_name,
    last_name
  INTO v_first_name,
    v_last_name
  FROM employees
  WHERE salary = v_salary;
  DBMS_OUTPUT.PUT_LINE(v_last_name || ' ' || v_first_name);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE('Nu exista salariati care sa castige acest salariu');
WHEN TOO_MANY_ROWS THEN
  DBMS_OUTPUT.PUT_LINE('Exista mai mul?i salariati care castiga acest salariu');
END;
/
/* Exercitiul 3 */
DECLARE
  exceptie EXCEPTION;
  v_id_vechi departments.department_id%TYPE := &p;
  v_id_nou departments.department_id%TYPE   := &p;
  v_numar_angajati NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_numar_angajati
  FROM employees
  WHERE department_id = v_id_vechi;
  IF v_numar_angajati > 0 THEN
    RAISE exceptie;
  ELSE
    UPDATE departments
    SET department_id   = v_id_nou
    WHERE department_id = v_id_vechi;
  END IF;
EXCEPTION
WHEN exceptie THEN
  DBMS_OUTPUT.PUT_LINE ('Sunt angajati in acest departament');
END;
/
/* Exercitiul 4 */
DECLARE
  v_a NUMBER := &a;
  v_b NUMBER := &b;
  v_nume_departament departments.department_name%TYPE;
  v_nr     NUMBER;
  exceptie EXCEPTION;
BEGIN
  SELECT COUNT(*) INTO v_nr FROM employees WHERE department_id = 10;
  SELECT department_name
  INTO v_nume_departament
  FROM departments
  WHERE department_id = 10;
  IF v_a             <= v_nr AND v_nr <= v_b THEN
    DBMS_OUTPUT.PUT_LINE(v_nume_departament);
  ELSE
    RAISE exceptie;
  END IF;
EXCEPTION
WHEN exceptie THEN
  DBMS_OUTPUT.PUT_LINE('Numarul de angajati nu se afla in interval');
END;
/
/* Exercitiul 5 */
DECLARE
  v_id_departament departments.department_id%TYPE     := &id;
  v_nume_departament departments.department_name%TYPE := &nume_nou_departament;
  exceptie EXCEPTION;
BEGIN
  UPDATE departments
  SET department_name = v_nume_departament
  WHERE department_id = v_id_departament;
  IF SQL%NOTFOUND THEN
    RAISE_APPLICATION_ERROR(-20999,'Departamentul nu exista');
  END IF;
END;
/
/* Exercitiul 6 */
/* Varianta 1 */
DECLARE
  v_city locations.city%TYPE := &locatie;
  v_nume_departament departments.department_name%TYPE;
  v_cod departments.department_id%TYPE := &cod;
BEGIN
  BEGIN
    SELECT d.department_name
    INTO v_nume_departament
    FROM departments d,
      locations l
    WHERE d.location_id = l.location_id
    AND l.city          = v_city;
    DBMS_OUTPUT.PUT_LINE(v_nume_departament);
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('comanda SELECT1 nu returneaza nimic');
  END;
  BEGIN
    SELECT department_name
    INTO v_nume_departament
    FROM departments
    WHERE department_id = v_cod;
    DBMS_OUTPUT.PUT_LINE(v_nume_departament);
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('comanda SELECT2 nu returneaza nimic');
  END;
END;
/
/* Varianta 2 */
DECLARE
  v_localizare NUMBER(1)     := 1;
  v_city locations.city%TYPE := &locatie;
  v_nume_departament departments.department_name%TYPE;
  v_cod departments.department_id%TYPE := &cod;
BEGIN
  SELECT d.department_name
  INTO v_nume_departament
  FROM departments d,
    locations l
  WHERE d.location_id = l.location_id
  AND l.city          = v_city;
  DBMS_OUTPUT.PUT_LINE(v_nume_departament);
  v_localizare := 2;
  SELECT department_name
  INTO v_nume_departament
  FROM departments
  WHERE department_id = v_cod;
  DBMS_OUTPUT.PUT_LINE(v_nume_departament);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE('comanda SELECT ' || v_localizare || ' nu returneaza nimic');
END;
/