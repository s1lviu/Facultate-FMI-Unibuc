/*2.Afi?a?i numele ?i data angaj?rii salariatului având codul 200. Eticheta?i coloanele conform semnifica?iilor acestora(Nume, Data angaj?rii),
f?r? ca aliasurile s? fie trunchiate la dimensiunea coloanei ?i respectându-se forma de scriere a acestora (aliasurile încep cu majuscul?).
Indica?ie: RPAD(TO_CHAR(hire_date),20,' ') */
SELECT RPAD(TO_CHAR(first_name),20,' ') as "Nume",RPAD(TO_CHAR(hire_date),20,' ') as "Data angajarii"
FROM EMPLOYEES
WHERE EMPLOYEE_ID=200;

/*3. Afi?a?i pentru fiecare angajat din departamentul 20 un ?ir de caractere de forma "Func?ia salariatului {prenume}{nume} este {cod functie}"
(prenumele cu ini?iala majuscul?, numele cu majuscule, codul func?iei cu minuscule).*/
SELECT LPAD(TO_CHAR(INITCAP(first_name)),lengTh(first_name)+21,'Functia salariatului ')
|| LPAD(TO_CHAR(UPPER(LAST_NAME)),LENGTH(LAST_NAME)+1,' ')
|| LPAD(TO_CHAR(LOWER(JOB_ID)),LENGTH(JOB_ID)+6,' este ')
FROM EMPLOYEES
WHERE DEPARTMENT_ID=20;

/*4. Afi?a?i pentru angajatul cu numele 'HIGGINS' codul, numele ?i codul departamentului.Cum se scrie condi?ia din WHERE astfel încât s?
existe siguran?a ca angajatul 'HIGGINS' va fi g?sit oricum ar fi fost introdus numele acestuia? C?utarea trebuie s? nu fie case-sensitive
,iar eventualele blank-uri care preced sau urmeaz? numelui trebuie ignorate.
Indica?ie: UPPER(TRIM(last_name))*/
SELECT EMPLOYEE_ID,LAST_NAME,DEPARTMENT_ID
FROM EMPLOYEES
WHERE UPPER(TRIM(last_name)) like 'HIGGINS';


/*5. Afisati pentru toti angajaþii al cãror nume se terminã în litera 'n', codul, numele, lungimea numelui si poziþia din nume în care 
apare prima data litera 'a'. Asociaþi aliasuri coloanelor afisate.
Indicaþie: LENGTH(last_name)
INSTR(UPPER(last_name),'A')
SUBSTR(last_name,-1)='n'*/
SELECT EMPLOYEE_ID as "Cod nume",LAST_NAME as "Nume",LENGTH(LAST_NAME) as "Lungimea numelui",INSTR(UPPER(last_name),'A') as "Prima pozitie"
FROM EMPLOYEES
WHERE LAST_NAME LIKE '%n';

--7. Afisati detalii despre salariatii care au lucrat un numãr întreg de sãptãmâni pânã la data curentã.
SELECT FIRST_NAME,LAST_NAME,HIRE_DATE
FROM EMPLOYEES
WHERE MOD(ROUND(SYSDATE-hire_date), 7)=0;

--9. Afi?a?i data (luna, ziua, ora, minutul si secunda) de peste 10 zile.
SELECT TO_CHAR(sysdate+10,'MM DD HH12:MI:SS')
FROM DUAL;

--10. Afisati numãrul de zile rãmase pânã la sfârtitul anului.
SELECT TRUNC(TO_DATE('31-DEC-2015')-SYSDATE) as "Numar zile"
FROM DUAL;

--11.a. Afi?a?i data de peste 12 ore.
SELECT SYSDATE+ 12/24
FROM DUAL;

--b. Afi?a?i data de peste 5 minute.
SELECT SYSDATE + 5/60/24
FROM DUAL;

/*13. S? se afi?eze numele angajatului, data angaj?rii ?i data negocierii salariului, care a avut loc în prima zi de Luni, dup? 6 luni de 
serviciu. Eticheta?i aceast? coloan? “Negociere”.
Indica?ie: NEXT_DAY(ADD_MONTHS(hire_date, 6), 'Monday')*/
SELECT LAST_NAME,HIRE_DATE,NEXT_DAY(ADD_MONTHS(hire_date,6),2) as "Negociere"
FROM EMPLOYEES;

/*14. Pentru fiecare angajat s? se afi?eze numele ?i num?rul de luni de la data angaj?rii. Eticheta?i coloana “Luni lucrate”. S? se ordoneze
rezultatul dup? num?rul de luni lucrate. Se va rotunji num?rul de luni la cel mai apropiat num?r întreg.
Indica?ie: ROUND(MONTHS_BETWEEN(SYSDATE, hire_date))*/
SELECT LAST_NAME,ROUND(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)) as "Luni lucrate"
FROM EMPLOYEES
ORDER BY "Luni lucrate" ;

/*16. Afi?a?i numele ?i prenumele pentru to?i angaja?ii care s-au angajat în luna mai.*/
SELECT LAST_NAME || ' ' || FIRST_NAME as "Nume si Prenume"
FROM EMPLOYEES
WHERE TO_CHAR(HIRE_DATE,'Mon')='May'; 

/*17. Afi?a?i data urm?toarei zile de Vineri de peste 3 luni. Eticheta?i coloana. Rezultatul trebuie 
s? fie formatat 'NumeZi, NumeLuna NumarZiLuna, an'.*/
SELECT TO_CHAR(NEXT_DAY(ADD_MONTHS(SYSDATE,3),6),'Day,Mon DD,YYYY') as "Data"
FROM DUAL;

--19. Afi?a?i numele angaja?ilor ?i comisionul. Dac? un angajat nu câ?tig? comision, afi?a?i “Fara comision”. Eticheta?i coloana “Comision”.
SELECT LAST_NAME as "Numele angajatului",NVL(TO_CHAR(COMMISSION_PCT,0.9),'Fara comision') as "Comision"
FROM EMPLOYEES; --aici nu pot sa afisez si 0 din fata comisionului (0.5,0.3 etc. imi afiseaza .5, .3)

--20. Afi?a?i numele, salariul ?i comisionul tuturor angaja?ilor al c?ror venit lunar dep??e?te 10000$.
SELECT LAST_NAME as "Numele angajatului",SALARY as "Salariu",COMMISSION_PCT as "Comision"
FROM EMPLOYEES
WHERE NVL2(COMMISSION_PCT,SALARY+SALARY*COMMISSION_PCT,SALARY)>10000 ;

/*23. Afi?a?i numele salariatului ?i codul departamentului în care acesta lucreaz?. Dac? exist? salaria?i care nu au un cod de 
departament asociat, atunci pe coloana id_department afi?a?i:
- textul “fara departament”;
- valoarea zero.*/
SELECT LAST_NAME as "NUME",DECODE(DEPARTMENT_ID,NULL,'fara departament',
                                  DEPARTMENT_ID) as "COD DEPARTAMENT"
FROM EMPLOYEES;
 
/*24. Afisati valoarea medie a comisionului lunar pentru:
- salariaþii care câstigã comision;
- toti salariatii.*/
SELECT ROUND(SUM(COMMISSION_PCT)/COUNT(COMMISSION_PCT),4) as "salarati cu comision",ROUND(SUM(COMMISSION_PCT)/COUNT(*),4) as "Comision toti salariatii"
FROM EMPLOYEES;

/*25.25. a) Afi?a?i numele angaja?ilor care nu au manager.
b) Afi?a?i numele angaja?ilor ?i codul managerilor lor. Pentru angaja?ii care nu au manager s? apar? textul “nu are sef”.*/
--a)
SELECT LAST_NAME as "Nume"
FROM EMPLOYEES 
WHERE MANAGER_ID is null;
--b)
SELECT LAST_NAME as "Nume",DECODE(MANAGER_ID,NULL,'nu are sef',
                                  MANAGER_ID) as "Cod manager"
FROM EMPLOYEES;

/*26. Afi?a?i numele salariatului ?i:
a) venitul anual dac? are comision;
b) salariul dac? nu are comision.
Se va utiliza func?ia NVL2.
*/
SELECT LAST_NAME as "Nume",NVL2(Commission_PCT,12*(salary+salary*commission_pct) ,salary ) as "Salariu"
FROM EMPLOYEES;

/*27. Pentru toþi angajaþii, afisati valoarea null dacã lungimea numelui
este egalã cu cea a prenumelui, iar în caz contrar doar lungimea numelui. Se va utiliza funcþia NULLIF.*/
SELECT NULLIF(LENGTH(LAST_NAME),LENGTH(FIRST_NAME)) as "Lungimea numelui"
FROM EMPLOYEES;

/*28. Modifica?i cererea anterioar? astfel încât s? afi?a?i în locul valorii null textul “Valori egale”.*/
SELECT CASE WHEN length(last_name)=length(first_name) THEN 'Valori egale' ELSE TO_CHAR(length(last_name)) END as "Lungimea numelui"
FROM EMPLOYEES;
/*29.9. Afisati numele salariatului, salariul si salariul revizuit astfel:
- dacã lucreazã de mai mult de 200 de luni atunci salariul va fi mãrit cu 20%;
- dacã lucreazã de mai mult de 150 de luni, dar mai puþin de 200 de luni, atunci salariul va fi mãrit cu 15%;
- dacã lucreazã de mai mult de 100 de luni, dar mai puþin de 150 de luni, atunci salariul va fi mãrit cu 10%;
- altfel, salariul va fi mãrit cu 5%.*/
SELECT LAST_NAME "Nume",SALARY "Salariu",CASE WHEN MONTHS_BETWEEN(SYSDATE,HIRE_DATE)>200 THEN SALARY+SALARY*0.2
                                       WHEN  MONTHS_BETWEEN(SYSDATE,HIRE_DATE)>150 THEN SALARY+SALARY*0.15
                                        WHEN  MONTHS_BETWEEN(SYSDATE,HIRE_DATE)>100 THEN SALARY+SALARY*0.1
                                         ELSE SALARY+SALARY*0.5 END as "Salariu revizuit"
FROM EMPLOYEES;













