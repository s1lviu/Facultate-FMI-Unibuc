SET SERVEROUTPUT ON
DECLARE
  v_nume employees.last_name%TYPE := Initcap('&p_nume');
  FUNCTION f1
    RETURN NUMBER
  IS
    salariu employees.salary%type;
  BEGIN
    SELECT salary INTO salariu FROM employees WHERE last_name = v_nume;
    RETURN salariu;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Nu exista angajati cu numele dat');
  WHEN TOO_MANY_ROWS THEN
    DBMS_OUTPUT.PUT_LINE('Exista mai multi angajati '||'cu numele dat');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Alta eroare!');
  END f1;
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Salariul este '|| f1);
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Eroarea are codul = '||SQLCODE|| ' si mesajul = ' || SQLERRM);
  END;
  /
CREATE OR REPLACE
FUNCTION f2_spr(
    v_nume employees.last_name%TYPE DEFAULT 'Bell')
  RETURN NUMBER
IS
  salariu employees.salary%type;
BEGIN
  SELECT salary INTO salariu FROM employees WHERE last_name = v_nume;
  RETURN salariu;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
WHEN TOO_MANY_ROWS THEN
  RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
WHEN OTHERS THEN
  RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END f2_spr;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE('SAL ESTE' ||f2_spr('orice'));
END;
/
SELECT f2_spr FROM dual;
VARIABLE nr NUMBER
EXECUTE :nr:=f2_spr;
PRINT nr
VARIABLE nr3 NUMBER CALL f2_spr('Bell') INTO :nr3;
PRINT nr3
VARIABLE ang_man NUMBER
BEGIN
  :ang_man:=200;
END;
/
CREATE OR REPLACE
PROCEDURE p5_spr
  BEGIN
    SELECT manager_id INTO nr FROM employees WHERE employee_id=nr;
  END p5_spr;
  /
  EXECUTE p5_spr (:ang_man)
  PRINT ang_man
CREATE OR REPLACE
FUNCTION factorial_spr(
    n NUMBER)
  RETURN NUMBER
IS
BEGIN
  IF (n=0) THEN
    RETURN 1;
  ELSE
    RETURN n*factorial_spr(n-1);
  END IF;
END factorial_spr;
/
SELECT factorial_spr(60) FROM dual;
--1. Creaţi tabelul info_*** cu următoarele coloane:
--    - utilizator (numele utilizatorului care a iniţiat o comandă)
--     - data (data şi timpul la care utilizatorul a iniţiat comanda)
--      - comanda (comanda care a fost iniţiată de utilizatorul respectiv)
--       - nr_linii (numărul de linii selectate/modificate de comandă)
--       - eroare (un mesaj pentru excepţii).
CREATE OR REPLACE TYPE tab_spr
IS
  TABLE OF VARCHAR2(200);
  /
  DROP TYPE tab3;
  CREATE TABLE info_spr2
    (
      utilizator VARCHAR2(20),
      data DATE,
      comanda tab_spr,
      nr_linii NUMBER(3),
      eroare   VARCHAR(100)
    )
    NESTED TABLE comanda STORE AS tabel_spr;
CREATE OR REPLACE
FUNCTION f2_spr
  (
    v_nume employees.last_name%TYPE DEFAULT 'Bell'
  )
  RETURN info_spr2.nr_linii%type
IS
  salariu employees.salary%type;
BEGIN
  SELECT COUNT(*) INTO salariu FROM employees WHERE last_name = v_nume;
  RETURN salariu;
EXCEPTION
WHEN NO_DATA_FOUND THEN
  RETURN -20000;
  -- RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele dat');
WHEN TOO_MANY_ROWS THEN
  RETURN -20001;
  -- RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele dat');
WHEN OTHERS THEN
  RETURN -20002;
  -- RAISE_APPLICATION_ERROR(-20002,'Alta eroare!');
END f2_spr;
/
DECLARE
  v_utilizator info_spr2.utilizator%TYPE;
  v_data info_spr2.data%type;
  v_com info_spr2.comanda%type;
  v_err info_spr2.eroare%type;
  val info_spr2.nr_linii%TYPE;
BEGIN
  SELECT USER INTO v_utilizator FROM DUAL;
  SELECT SYSDATE INTO v_data FROM dual;
  SELECT text bulk collect
  INTO v_com
  FROM user_source
  WHERE user_source.name = UPPER('f2_spr');
  SELECT f2_spr('King') INTO val FROM dual;
  IF val    = 1 THEN
    v_err  := NULL;
  elsif val = 0 THEN
    v_err  := 'Nu exista angajati cu numele dat';
  elsif val > 1 THEN
    v_err  := 'Mai multi angajati cu acelasi nume';
  elsif val = -20002 THEN
    v_err  := 'Alte erori';
  END IF;
  INSERT INTO info_spr2 VALUES
    (v_utilizator, v_data, v_com, val, v_err
    );
END;
/
SELECT * FROM user_source;
SELECT * FROM info_spr2;


--cu procedura
CREATE OR REPLACE
PROCEDURE p4_spr(
    v_nume employees.last_name%TYPE,
    v_linii OUT info_spr2.nr_linii%TYPE,
    v_err OUT info_spr2.eroare%TYPE)
IS
BEGIN
  SELECT COUNT(*) INTO v_linii FROM employees WHERE last_name = v_nume;
  if v_linii = 0 then v_err := 'Nu exista angajati cu numele dat';
  elsif v_linii > 1 then v_err := 'Exista mai multi angajati cu numele dat';
  end if;
EXCEPTION
WHEN OTHERS THEN
  v_linii := -1;
  v_err := 'Alta eroare!';
END p4_spr;
/

DECLARE
  v_utilizator info_spr2.utilizator%TYPE;
  v_data info_spr2.data%type;
  v_com info_spr2.comanda%type;
  v_err info_spr2.eroare%type;
  val info_spr2.nr_linii%TYPE;
BEGIN
  SELECT USER INTO v_utilizator FROM DUAL;
  SELECT SYSDATE INTO v_data FROM dual;
  SELECT text bulk collect
  INTO v_com
  FROM user_source
  WHERE user_source.name = UPPER('f2_spr');
  
  p4_spr('King', val, v_err);
  
  INSERT INTO info_spr2 VALUES
    (v_utilizator, v_data, v_com, val, v_err
    );
END;
/
SELECT * FROM info_spr2;
