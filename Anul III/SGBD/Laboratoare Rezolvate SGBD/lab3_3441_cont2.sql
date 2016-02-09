--ex 1. b
SET SERVEROUTPUT ON
DECLARE
CURSOR v_jobs IS SELECT DISTINCT job_title,job_id
                               FROM jobs;
CURSOR v_emp IS SELECT  job_id,last_name,salary
                               FROM employees;
BEGIN
  
  FOR i IN v_jobs LOOP
  DBMS_OUTPUT.PUT_LINE('--');
  DBMS_OUTPUT.PUT_LINE(i.job_title);
  DBMS_OUTPUT.PUT_LINE('--');
      FOR j in v_emp LOOP
          IF i.job_id = j.job_id THEN
              DBMS_OUTPUT.PUT_LINE('Angajatul ' || j.last_name || 'are salariul ' || j.salary);
           END IF;
     END LOOP;
  
   DBMS_OUTPUT.PUT_LINE(v_jobs%ROWCOUNT);
  END LOOP;
END;
/

--1.c
SET SERVEROUTPUT ON
BEGIN
  
  FOR i IN (SELECT DISTINCT job_title,job_id
                               FROM jobs) LOOP
  DBMS_OUTPUT.PUT_LINE('--');
  DBMS_OUTPUT.PUT_LINE(i.job_title);
  DBMS_OUTPUT.PUT_LINE('--');
      FOR j in (SELECT  job_id,last_name,salary
                               FROM employees) LOOP
          IF i.job_id = j.job_id THEN
              DBMS_OUTPUT.PUT_LINE('Angajatul ' || j.last_name || 'are salariul ' || j.salary);
           END IF;
     END LOOP;
  
   --DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT); not working
  END LOOP;
END;
/




--vers 1
SET SERVEROUTPUT ON
DECLARE
TYPE ref_curs IS REF CURSOR;
CURSOR v_jobs IS SELECT job_title,CURSOR(SELECT last_name,salary
                               FROM employees e WHERE e.job_id = j.job_id)
                               FROM jobs j;
v_cursor ref_curs;
 v_jt jobs.job_title%TYPE;
 v_nume employees.last_name%TYPE;
 v_salariu employees.salary%TYPE; 
BEGIN
  OPEN v_jobs;
  LOOP
    FETCH v_jobs INTO v_jt,v_cursor;
  EXIT WHEN v_jobs%NOTFOUND;
  DBMS_OUTPUT.PUT_LINE('--');
  DBMS_OUTPUT.PUT_LINE(v_jt);
  DBMS_OUTPUT.PUT_LINE('--');

  LOOP
    FETCH v_cursor INTO v_nume,v_salariu;
  EXIT WHEN v_cursor%NOTFOUND;

   DBMS_OUTPUT.PUT_LINE('Angajatul ' || v_nume || 'are salariul ' || v_salariu);
  
 -- END IF;
  END LOOP;
  END LOOP;
  CLOSE v_jobs;
END;
/


--ex2

SET SERVEROUTPUT ON
DECLARE
TYPE ref_curs IS REF CURSOR;
CURSOR v_jobs IS SELECT job_title,CURSOR(SELECT last_name,salary
                               FROM employees e WHERE e.job_id = j.job_id)
                               FROM jobs j;
v_cont number(3) := -1;
v_sum number(10) := 0;
v_avg  number(10,2) := 0;
v_cursor ref_curs;
 v_jt jobs.job_title%TYPE;
 v_nume employees.last_name%TYPE;
 v_salariu employees.salary%TYPE; 
BEGIN
  OPEN v_jobs;
  LOOP
    FETCH v_jobs INTO v_jt,v_cursor;
  EXIT WHEN v_jobs%NOTFOUND;
  
  DBMS_OUTPUT.PUT_LINE('--');
  DBMS_OUTPUT.PUT_LINE(v_jt);
  DBMS_OUTPUT.PUT_LINE('--');
 
  v_cont := 0;
  v_sum := 0;
 
  LOOP
    FETCH v_cursor INTO v_nume,v_salariu;
  EXIT WHEN v_cursor%NOTFOUND;
   v_cont := v_cont + 1;
   v_sum := v_sum + v_salariu;
   DBMS_OUTPUT.PUT_LINE(v_cont || '.  Angajatul ' || v_nume || 'are salariul ' || v_salariu);
  
 -- END IF;
  END LOOP;
      DBMS_OUTPUT.PUT_LINE('Angajati : ' || v_cont);
      DBMS_OUTPUT.PUT_LINE('Suma salarii:' || v_sum);
      DBMS_OUTPUT.PUT_LINE('Media salarii:' || v_sum / v_cont);
  END LOOP;
  CLOSE v_jobs;
END;
/



SELECT e.job_id, SUM(salary), AVG(salary)
                               FROM employees e, jobs j WHERE e.job_id = j.job_id
                               GROUP BY e.job_id;
                               
--INDIFERENT DE ANG
SET SERVEROUTPUT ON
DECLARE
TYPE ref_curs IS REF CURSOR;
CURSOR v_jobs IS SELECT job_title,CURSOR(SELECT last_name,salary
                               FROM employees e WHERE e.job_id = j.job_id)
                               FROM jobs j;
v_cont number(3) := -1;
v_sum number(10) := 0;
v_avg  number(10,2) := 0;
v_cursor ref_curs;
 v_jt jobs.job_title%TYPE;
 v_nume employees.last_name%TYPE;
 v_salariu employees.salary%TYPE; 
BEGIN
  OPEN v_jobs;
  LOOP
    FETCH v_jobs INTO v_jt,v_cursor;
  EXIT WHEN v_jobs%NOTFOUND;
  
  DBMS_OUTPUT.PUT_LINE('--');
  DBMS_OUTPUT.PUT_LINE(v_jt);
  DBMS_OUTPUT.PUT_LINE('--');
 
 
  LOOP
    FETCH v_cursor INTO v_nume,v_salariu;
  EXIT WHEN v_cursor%NOTFOUND;
   v_cont := v_cont + 1;
   v_sum := v_sum + v_salariu;
   DBMS_OUTPUT.PUT_LINE(  'Angajatul '  || v_nume || 'are salariul ' || v_salariu);
  
 -- END IF;
  END LOOP;
      
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('Angajati : ' || v_cont);
      DBMS_OUTPUT.PUT_LINE('Suma salarii:' || v_sum);
      DBMS_OUTPUT.PUT_LINE('Media salarii:' || round(v_sum / v_cont,2));
  CLOSE v_jobs;
END;
/

--3
SET SERVEROUTPUT ON
DECLARE
TYPE ref_curs IS REF CURSOR;
CURSOR v_jobs IS SELECT job_title,CURSOR(SELECT last_name,salary,NVL(commission_pct,0) comm
                               FROM employees e WHERE e.job_id = j.job_id)
                               FROM jobs j;
v_cont number(3) := -1;
v_sum number(10) := 0;
v_avg  number(10,2) := 0;
v_procent number(6,2):=0;
v_sum2 number(6):=0;
v_comm employees.commission_pct%TYPE;
v_cursor ref_curs;
 v_jt jobs.job_title%TYPE;
 v_nume employees.last_name%TYPE;
 v_salariu employees.salary%TYPE; 
BEGIN
  OPEN v_jobs;
  LOOP
    FETCH v_jobs INTO v_jt,v_cursor;
  EXIT WHEN v_jobs%NOTFOUND;
  
  --DBMS_OUTPUT.PUT_LINE('--');
  --DBMS_OUTPUT.PUT_LINE(v_jt);
  --DBMS_OUTPUT.PUT_LINE('--');
 
 
  LOOP
    FETCH v_cursor INTO v_nume,v_salariu, v_comm;
  EXIT WHEN v_cursor%NOTFOUND;
   v_cont := v_cont + 1;
   v_sum := v_sum + v_salariu+v_comm * v_salariu;
    --DBMS_OUTPUT.PUT_LINE(  'Angajatul '  || v_nume || 'are salariul  si procentul este: ' || v_salariu || ' ' || v_procent);
  
  END LOOP;
  --DBMS_OUTPUT.PUT_LINE(v_sum);
      LOOP
         FETCH v_cursor INTO v_nume,v_salariu, v_comm;
    EXIT WHEN v_cursor%NOTFOUND;
  v_procent :=(v_salariu+v_comm*v_salariu)/v_sum; 
   DBMS_OUTPUT.PUT_LINE(  'Angajatul '  || v_nume || 'are salariul  si procentul este: ' || v_salariu || ' ' || v_procent);
   END LOOP;
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Angajati : ' || v_cont);
      DBMS_OUTPUT.PUT_LINE('Suma salarii:' || v_sum);
      DBMS_OUTPUT.PUT_LINE('Media salarii:' || round(v_sum / v_cont,2));
  CLOSE v_jobs;
END;
/
