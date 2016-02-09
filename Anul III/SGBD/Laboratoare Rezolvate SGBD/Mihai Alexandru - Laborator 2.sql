/* Exercitiul 1 */
DECLARE
TYPE tablou_imbricat
IS
  TABLE OF employees.employee_id%TYPE;
  t tablou_imbricat := tablou_imbricat();
  v_nr employees.employee_id%TYPE;
  v_salary employees.salary%TYPE;
BEGIN
  FOR i IN 1..5
  LOOP
    SELECT *
    INTO v_nr
    FROM
      (SELECT employee_id
      FROM
        ( SELECT * FROM employees WHERE commission_pct IS NULL ORDER BY salary
        )
      WHERE ROWNUM <= i
      MINUS
      SELECT employee_id
      FROM
        ( SELECT * FROM employees WHERE commission_pct IS NULL ORDER BY salary
        )
      WHERE ROWNUM < i
      );
    t.extend;
    t(i) := v_nr;
  END LOOP;
  FOR i IN t.FIRST..t.LAST
  LOOP
    SELECT salary INTO v_salary FROM employees WHERE employee_id = t(i);
    dbms_output.put(v_salary || ' -> ');
    UPDATE employees
    SET salary        = salary + 5 * salary / 100
    WHERE employee_id = t(i);
    SELECT salary INTO v_salary FROM employees WHERE employee_id = t(i);
    dbms_output.put(v_salary);
    dbms_output.new_line;
  END LOOP;
END;
/
-- Selectam cele mai mici 5 salarii
SELECT employee_id,
  salary
FROM
  ( SELECT * FROM employees WHERE commission_pct IS NULL ORDER BY salary
  )
WHERE ROWNUM <= 5;
ROLLBACK;
/* Exercitiul 2 */
CREATE OR REPLACE TYPE tip_orase_abc AS VARRAY(10) OF VARCHAR2(20);
CREATE TABLE excursie_abc
  (
    cod_excursie NUMBER(4),
    denumire     VARCHAR2(20),
    orase tip_orase_abc,
    status VARCHAR2(15)
  );
/* a */
DECLARE
BEGIN
  INSERT
  INTO excursie_abc VALUES
    (
      1,
      'Bucla Mica',
      tip_orase_abc( 'Bacau', 'Onesti'),
      'disponibila'
    );
  INSERT
  INTO excursie_abc VALUES
    (
      2,
      'Bucla Mare',
      tip_orase_abc( 'Bacau', 'Onesti', 'Adjud', 'Barlad', 'Vaslui'),
      'disponibila'
    );
  INSERT
  INTO excursie_abc VALUES
    (
      3,
      'B_B_B',
      tip_orase_abc( 'Bacau', 'Bucuresti', 'Brasov'),
      'disponibila'
    );
  INSERT
  INTO excursie_abc VALUES
    (
      4,
      'Portugalia',
      tip_orase_abc( 'Porto', 'Lisabona', 'Braga'),
      'anulata'
    );
  INSERT INTO excursie_abc VALUES
    ( 5, 'Acasa', NULL, 'disponibila'
    );
END;
/
DROP TYPE tip_orase_abc;
/* b */
DECLARE
BEGIN
  UPDATE excursie_abc
  SET orase          = tip_orase_abc('Onesti')
  WHERE cod_excursie = 5;
END;
/
/* c */
DECLARE
  t tip_orase_abc                      := tip_orase_abc();
  v_cod excursie_abc.cod_excursie%TYPE := &cod;
BEGIN
  SELECT orase INTO t FROM excursie_abc WHERE cod_excursie = v_cod;
  dbms_output.put('Excursia cu ID-ul ' || v_cod || ' are ' || t.COUNT || ' orase: ');
  FOR I IN t.FIRST..t.LAST
  LOOP
    dbms_output.put( t(i) || ' ' );
  END LOOP;
  dbms_output.new_line;
END;
/
/* d */
DECLARE
TYPE tablou_imbricat
IS
  TABLE OF excursie_abc.cod_excursie%TYPE;
  t tablou_imbricat := tablou_imbricat();
  t1 tip_orase_abc  := tip_orase_abc();
  v_nr excursie_abc.cod_excursie%TYPE;
  v_count NUMBER(5);
BEGIN
  SELECT COUNT(*) INTO v_count FROM excursie_abc;
  FOR i IN 1..v_count
  LOOP
    SELECT *
    INTO v_nr
    FROM
      (SELECT cod_excursie
      FROM
        ( SELECT cod_excursie FROM excursie_abc ORDER BY cod_excursie
        )
      WHERE ROWNUM <= i
      MINUS
      SELECT cod_excursie
      FROM
        ( SELECT cod_excursie FROM excursie_abc ORDER BY cod_excursie
        )
      WHERE ROWNUM < i
      );
    t.extend;
    t(i) := v_nr;
  END LOOP;
  FOR i IN t.FIRST..t.LAST
  LOOP
    SELECT orase INTO t1 FROM excursie_abc WHERE cod_excursie = t(i);
    dbms_output.put( 'Excursia ' || t(i) || ' are ' || t1.COUNT || ' orase: ');
    FOR J IN t1.FIRST..t1.LAST
    LOOP
      dbms_output.put( t1(j) || ' ' );
    END LOOP;
    dbms_output.new_line;
  END LOOP;
END;
/
/* e */
DECLARE
TYPE tablou_imbricat
IS
  TABLE OF excursie_abc.cod_excursie%TYPE;
  t tablou_imbricat := tablou_imbricat();
  t1 tip_orase_abc  := tip_orase_abc();
  v_nr excursie_abc.cod_excursie%TYPE;
  v_count NUMBER(5);
  v_min   NUMBER(5) := 1000;
  v_id excursie_abc.cod_excursie%TYPE;
BEGIN
  SELECT COUNT(*) INTO v_count FROM excursie_abc;
  FOR i IN 1..v_count
  LOOP
    SELECT *
    INTO v_nr
    FROM
      (SELECT cod_excursie
      FROM
        ( SELECT cod_excursie FROM excursie_abc ORDER BY cod_excursie
        )
      WHERE ROWNUM <= i
      MINUS
      SELECT cod_excursie
      FROM
        ( SELECT cod_excursie FROM excursie_abc ORDER BY cod_excursie
        )
      WHERE ROWNUM < i
      );
    t.extend;
    t(i) := v_nr;
  END LOOP;
  FOR i IN t.FIRST..t.LAST
  LOOP
    SELECT orase INTO t1 FROM excursie_abc WHERE cod_excursie = t(i);
    IF t1.COUNT < v_min THEN
      v_id     := t(i);
      v_min    := t1.COUNT;
    END IF;
  END LOOP;
  DELETE FROM excursie_abc WHERE cod_excursie = v_id;
END;
/
/* Exercitiul 3 */
CREATE OR REPLACE TYPE tip_orase_abc
IS
  TABLE OF VARCHAR2(20);
  CREATE TABLE excursie_abc
    (
      cod_excursie NUMBER(4),
      denumire     VARCHAR2(20),
      orase tip_orase_abc,
      status VARCHAR2(15)
    )
    NESTED TABLE orase STORE AS tabel_orase_abc;
  /* a */
  DECLARE
  BEGIN
    INSERT
    INTO excursie_abc VALUES
      (
        1,
        'Bucla Mica',
        tip_orase_abc( 'Bacau', 'Onesti'),
        'disponibila'
      );
    INSERT
    INTO excursie_abc VALUES
      (
        2,
        'Bucla Mare',
        tip_orase_abc( 'Bacau', 'Onesti', 'Adjud', 'Barlad', 'Vaslui'),
        'disponibila'
      );
    INSERT
    INTO excursie_abc VALUES
      (
        3,
        'B_B_B',
        tip_orase_abc( 'Bacau', 'Bucuresti', 'Brasov'),
        'disponibila'
      );
    INSERT
    INTO excursie_abc VALUES
      (
        4,
        'Portugalia',
        tip_orase_abc( 'Porto', 'Lisabona', 'Braga'),
        'anulata'
      );
    INSERT INTO excursie_abc VALUES
      ( 5, 'Acasa', NULL, 'disponibila'
      );
  END;
  /
  /* b */
  DECLARE
  BEGIN
    UPDATE excursie_abc
    SET orase          = tip_orase_abc('Onesti')
    WHERE cod_excursie = 5;
  END;
  /
  /* c */
  DECLARE
    t tip_orase_abc                      := tip_orase_abc();
    v_cod excursie_abc.cod_excursie%TYPE := &cod;
  BEGIN
    SELECT orase INTO t FROM excursie_abc WHERE cod_excursie = v_cod;
    dbms_output.put('Excursia cu ID-ul ' || v_cod || ' are ' || t.COUNT || ' orase: ');
    FOR I IN t.FIRST..t.LAST
    LOOP
      dbms_output.put( t(i) || ' ' );
    END LOOP;
    dbms_output.new_line;
  END;
  /
  /* d */
  DECLARE
  TYPE tablou_imbricat
IS
  TABLE OF excursie_abc.cod_excursie%TYPE;
  t tablou_imbricat := tablou_imbricat();
  t1 tip_orase_abc  := tip_orase_abc();
  v_nr excursie_abc.cod_excursie%TYPE;
  v_count NUMBER(5);
BEGIN
  SELECT COUNT(*) INTO v_count FROM excursie_abc;
  FOR i IN 1..v_count
  LOOP
    SELECT *
    INTO v_nr
    FROM
      (SELECT cod_excursie
      FROM
        ( SELECT cod_excursie FROM excursie_abc ORDER BY cod_excursie
        )
      WHERE ROWNUM <= i
      MINUS
      SELECT cod_excursie
      FROM
        ( SELECT cod_excursie FROM excursie_abc ORDER BY cod_excursie
        )
      WHERE ROWNUM < i
      );
    t.extend;
    t(i) := v_nr;
  END LOOP;
  FOR i IN t.FIRST..t.LAST
  LOOP
    SELECT orase INTO t1 FROM excursie_abc WHERE cod_excursie = t(i);
    dbms_output.put( 'Excursia ' || t(i) || ' are ' || t1.COUNT || ' orase: ');
    FOR J IN t1.FIRST..t1.LAST
    LOOP
      dbms_output.put( t1(j) || ' ' );
    END LOOP;
    dbms_output.new_line;
  END LOOP;
END;
/
/* e */
DECLARE
TYPE tablou_imbricat
IS
  TABLE OF excursie_abc.cod_excursie%TYPE;
  t tablou_imbricat := tablou_imbricat();
  t1 tip_orase_abc  := tip_orase_abc();
  v_nr excursie_abc.cod_excursie%TYPE;
  v_count NUMBER(5);
  v_min   NUMBER(5) := 1000;
  v_id excursie_abc.cod_excursie%TYPE;
BEGIN
  SELECT COUNT(*) INTO v_count FROM excursie_abc;
  FOR i IN 1..v_count
  LOOP
    SELECT *
    INTO v_nr
    FROM
      (SELECT cod_excursie
      FROM
        ( SELECT cod_excursie FROM excursie_abc ORDER BY cod_excursie
        )
      WHERE ROWNUM <= i
      MINUS
      SELECT cod_excursie
      FROM
        ( SELECT cod_excursie FROM excursie_abc ORDER BY cod_excursie
        )
      WHERE ROWNUM < i
      );
    t.extend;
    t(i) := v_nr;
  END LOOP;
  FOR i IN t.FIRST..t.LAST
  LOOP
    SELECT orase INTO t1 FROM excursie_abc WHERE cod_excursie = t(i);
    IF t1.COUNT < v_min THEN
      v_id     := t(i);
      v_min    := t1.COUNT;
    END IF;
  END LOOP;
  DELETE FROM excursie_abc WHERE cod_excursie = v_id;
END;
/