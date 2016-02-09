/* Exercitiul 1 */
DECLARE
  numar NUMBER(3) := 100;
  mesaj1 VARCHAR2(255) := 'text 1';
  mesaj2 VARCHAR2(255) := 'text 2';
BEGIN
  DECLARE
    numar NUMBER(3) := 1;
    mesaj1 VARCHAR2(255) := 'text 2';
    mesaj2 VARCHAR2(255) := 'text 3';
  BEGIN
    numar := numar + 1;
    mesaj2 := mesaj2 || ' adaugat in sub-bloc';
    dbms_output.put_line(numar);
    dbms_output.put_line(mesaj1);
    dbms_output.put_line(mesaj2);
  END;
  numar := numar + 1;
  mesaj1 := mesaj1 || ' adaugat in blocul principal';
  mesaj2 := mesaj2 || ' adaugat in blocul principal';
  dbms_output.put_line(numar);
  dbms_output.put_line(mesaj1);
  dbms_output.put_line(mesaj2);
END;
-- a: 2
-- b: text 2
-- c: text 3 adaugat in sub-bloc
-- d: 101
-- e: text 1 adaugat in blocul principal
-- f: text 2 adaugat in blocul principal
/

/* Exercitiul 2 */
DECLARE
  i NUMBER(2) := 1;
  v_data NUMBER(10);
BEGIN
    WHILE i <= 31 LOOP
      SELECT COUNT(*)
      INTO v_data
      FROM rental
      WHERE TO_DATE( '01-OCT-14', 'DD-MON-YY' ) + ( i - 1 ) = TO_DATE( book_date, 'DD-MON-YY' ) ;
      dbms_output.put_line( TO_DATE( '01-OCT-14', 'DD-MON-YY' ) + ( i - 1 ) || ' -> ' || v_data );
      i := i + 1;
    END LOOP;
END; 
/

DECLARE
  i NUMBER(2) := 1;
  v_data NUMBER(10);
BEGIN
    WHILE i <= 31 LOOP
      SELECT COUNT(*)
      INTO v_data
      FROM rental
      WHERE i = extract ( DAY FROM book_date );
      dbms_output.put_line(i || ' -> ' || v_data);
      i := i + 1;
    END LOOP;
END; 
/

SELECT TO_DATE( '01-OCT-2014', 'DD-MON-YYYY' ) + ( a." Day " - 1 ) AS " Zi ",
  ( SELECT COUNT(*) 
    FROM rental
    WHERE EXTRACT ( DAY FROM book_date ) = a." Day " ) AS " Numar "
  FROM ( SELECT LEVEL AS " Day "
         FROM dual
         CONNECT BY LEVEL <= 31 ) a;

CREATE TABLE octombrie_abc(
  i NUMBER(2),
  oct DATE,
  nr NUMBER(10) );

DECLARE
  i NUMBER(2) := 1;
  v_data NUMBER(10);
BEGIN
    WHILE i <= 31 LOOP
      SELECT COUNT(*)
      INTO v_data
      FROM rental
      WHERE TO_DATE( '01-OCT-14', 'DD-MON-YY' ) + ( i - 1 ) = TO_DATE( book_date, 'DD-MON-YY' ) ;
      INSERT INTO octombrie_abc     
      VALUES ( i, TO_DATE( '01-OCT-14', 'DD-MON-YY' ) + ( i - 1 ), v_data );
      i := i + 1;
    END LOOP;
END; 
/

/* Exercitiul 3 */
SELECT COUNT(*) AS " Numar Filme "
FROM 
(SELECT UNIQUE m.member_id AS " ID Membru ",
  m.last_name AS " Nume ",
    m.first_name AS " Prenume ",
      t.title AS " Titlu "
  FROM member m
  LEFT OUTER JOIN rental r ON m.member_id = r.member_id
  LEFT OUTER JOIN title t ON r.title_id = t.title_id
  WHERE m.member_id = &id_membru);
  
DECLARE
v_data NUMBER(2);
v_last_name member.last_name%TYPE := &name;
v_nr NUMBER(2);
BEGIN

  SELECT COUNT(*)
  INTO v_nr
  FROM member
  WHERE LOWER( last_name ) = LOWER( v_last_name );
  
  IF v_nr = 0 THEN
      dbms_output.put_line( 'Numele ' || v_last_name || ' nu este in baza de date!' );
      ELSIF v_nr > 1 THEN
        dbms_output.put_line( 'Numele ' || v_last_name || ' exista de mai multe ori in baza de date!' );
      ELSE
      SELECT COUNT(*) AS " Numar Filme "
      INTO v_data
      FROM 
      ( SELECT UNIQUE m.member_id AS " ID Membru ",
        m.last_name AS " Nume ",
          m.first_name AS " Prenume ",
            t.title AS " Titlu "
        FROM member m, title t, rental r
        WHERE m.member_id = r.member_id (+)
        AND r.title_id = t.title_id
        AND LOWER( m.last_name ) = LOWER( v_last_name ) );
        dbms_output.put_line( v_data );
      END IF;
  
END; 
/

/* Exercitiul 4 */
DECLARE
v_data NUMBER(2);
v_last_name member.last_name%TYPE := &name;
v_nr NUMBER(2);
v_t NUMBER(2);
BEGIN

  SELECT COUNT(*)
  INTO v_nr
  FROM member
  WHERE LOWER( last_name ) = LOWER( v_last_name );
  
  SELECT COUNT(*)
  INTO v_t
  FROM title;
  
  IF v_nr = 0 THEN
      dbms_output.put_line( 'Numele ' || v_last_name || ' nu este in baza de date!' );
      ELSIF v_nr > 1 THEN
        dbms_output.put_line( 'Numele ' || v_last_name || ' exista de mai multe ori in baza de date!' );
      ELSE
      SELECT COUNT(*) AS " Numar Filme "
      INTO v_data
      FROM 
      ( SELECT UNIQUE m.member_id AS " ID Membru ",
        m.last_name AS " Nume ",
          m.first_name AS " Prenume ",
            t.title AS " Titlu "
        FROM member m, title t, rental r
        WHERE m.member_id = r.member_id (+)
        AND r.title_id = t.title_id
        AND LOWER( m.last_name ) = LOWER( v_last_name ) );
        
        dbms_output.put_line( v_data || ' -> ' || v_t );
        
        CASE WHEN v_data * 100 / v_t >= 75 THEN 
              dbms_output.put_line( 'Categoria 1' );
            WHEN v_data * 100 / v_t >= 50 THEN
              dbms_output.put_line( 'Categoria 2' );
            WHEN v_data * 100 / v_t >= 50 THEN
              dbms_output.put_line( 'Categoria 3' );
            ELSE
              dbms_output.put_line( 'Categoria 4' );
        END CASE;
        
      END IF;
  
END; 
/

/* Exercitiul 5 */
CREATE TABLE member_abc
AS ( SELECT * FROM member );

ALTER TABLE member_abc
ADD ( discount NUMBER( 4,4 ) );

DECLARE
i NUMBER(2) := 1;
v_data NUMBER(2);
v_last_name member.last_name%TYPE := &name;
v_nr NUMBER(2);
v_t NUMBER(2);
BEGIN

  SELECT COUNT(*)
  INTO v_nr
  FROM member_abc;
  
  SELECT COUNT(*)
  INTO v_t
  FROM title;
  
  UPDATE member_abc mb
  SET discount = 
      (SELECT COUNT(*) / v_t AS " Numar Filme "
      FROM 
      ( SELECT UNIQUE m.member_id AS " ID Membru ",
        m.last_name AS " Nume ",
          m.first_name AS " Prenume ",
            t.title AS " Titlu "
        FROM member m, title t, rental r
        WHERE m.member_id = r.member_id (+)
        AND r.title_id = t.title_id ) ma
      WHERE ma." ID Membru " = mb.member_id );
  
END; 
/

DECLARE
v_data NUMBER(2);
v_last_name member.last_name%TYPE := &name;
v_nr NUMBER(2);
v_t NUMBER(2);
v_member_id member.member_id%TYPE;
BEGIN

  SELECT COUNT(*)
  INTO v_nr
  FROM member_abc
  WHERE LOWER( last_name ) = LOWER( v_last_name );
  
  SELECT COUNT(*)
  INTO v_t
  FROM title;
  
  IF v_nr = 0 THEN
        dbms_output.put_line( 'Numele ' || v_last_name || ' nu este in baza de date!' );
      ELSIF v_nr > 1 THEN
        dbms_output.put_line( 'Numele ' || v_last_name || ' exista de mai multe ori in baza de date!' );
      ELSE
      
        SELECT member_id 
        INTO v_member_id
        FROM member_abc
        WHERE LOWER( last_name ) = LOWER( v_last_name );
        
      SELECT COUNT(*) AS " Numar Filme "
      INTO v_data
      FROM 
      ( SELECT UNIQUE m.member_id AS " ID Membru ",
        m.last_name AS " Nume ",
          m.first_name AS " Prenume ",
            t.title AS " Titlu "
        FROM member_abc m, title t, rental r
        WHERE m.member_id = r.member_id (+)
        AND r.title_id = t.title_id
        AND LOWER( m.last_name ) = LOWER( v_last_name ) );
        
        CASE WHEN v_data * 100 / v_t >= 75 THEN 
                UPDATE member_abc 
                SET discount = 0.1
                WHERE member_id = v_member_id;
            WHEN v_data * 100 / v_t >= 50 THEN
                UPDATE member_abc 
                SET discount = 0.05
                WHERE member_id = v_member_id;
            WHEN v_data * 100 / v_t >= 50 THEN
                UPDATE member_abc 
                SET discount = 0.03
                WHERE member_id = v_member_id;
            ELSE
                UPDATE member_abc 
                SET discount = 0
                WHERE member_id = v_member_id;
        END CASE;

      END IF;
END; 
/
