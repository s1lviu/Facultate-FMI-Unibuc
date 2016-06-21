/* 33.33. Lista?i numele departamentelor care func?ioneaz? în loca?ia având codul 1700 ?i al c?ror manager este
cunoscut. */
SELECT DEPARTMENT_NAME as "Nume departament"
FROM DEPARTMENTS
WHERE LOCATION_ID = 1700 and MANAGER_ID is not null

/*34. Afi?a?i codurile departamentelor în care lucreaz? salaria?i. ???*/
SELECT DISTINCT DEPARTMENT_ID "Cod Departament"
FROM EMPLOYEES

/*35.35. Afi?a?i numele ?i prenumele salaria?ilor angaja?i în luna iunie 1987."
(am modificat cu 2007 in cod anul deoarece eu nu am pe versiunea mea angajati din
1987.)*/
SELECT LAST_NAME || FIRST_NAME as "NUME si PRENUME"
FROM EMPLOYEES
WHERE HIRE_DATE  BETWEEN '01-JUN-2007' AND '30-JUN-2007'

/*36.36. Lista?i codurile angaja?ilor care au avut ?i alte joburi
fa?? de cel prezent. Ordona?i rezultatul descresc?tor dup? codul angajatului.*/
SELECT EMPLOYEE_ID
FROM JOB_HISTORY
WHERE JOB_ID is not null
ORDER BY EMPLOYEE_ID DESC

/*37. Afi?a?i numele ?i data angaj?rii pentru cei care lucreaz? în 
departamentul 80 ?i au fost angaja?i în luna  martie a anului 1997.
(2007 acelasi motiv ca la 35)*/
SELECT FIRST_NAME || LAST_NAME as "Nume",HIRE_DATE as "Data angajarii"
FROM EMPLOYEES
WHERE DEPARTMENT_ID=80 and HIRE_DATE  BETWEEN '01-MAR-2007' AND '31-MAR-2007'

/*38.38. Afi?a?i numele joburilor care permit un salariu mai mare de 8000$."*/
SELECT JOB_TITLE
FROM JOBS 
WHERE MAX_SALARY>8000
/*39.39. Care este grila de salarizare a unui salariu de 10000$?"*/

/*40. Lista?i numele tuturor angaja?ilor al c?ror nume con?ine 2 litere 'L'.*/
SELECT FIRST_NAME 
FROM EMPLOYEES
WHERE FIRST_NAME LIKE '%L%L%'

/*41. Afi?a?i informa?ii complete despre subordona?ii direc?i ai angajatului având codul 123.*/
SELECT *
FROM EMPLOYEES
WHERE MANAGER_ID=123

/*42. Afi?a?i numele, salariul, comisionul ?i venitul lunar total pentru to?i 
angaja?ii care câ?tig? comision, dar un comision care nu dep??e?te 25% din
salariu.*/
SELECT LAST_NAME,SALARY,COMMISSION_PCT,(SALARY+(SALARY*COMMISSION_PCT)) as "Venit Lunar"
FROM EMPLOYEES
WHERE COMMISSION_PCT is not NULL and COMMISSION_PCT<0.25