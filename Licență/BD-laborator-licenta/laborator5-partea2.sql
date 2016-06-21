SELECT employee_id, last_name
FROM employees e
WHERE EXISTS (SELECT 1
FROM employees
where employee_id = 200
AND e.salary >salary);

--2
select employee_id,last_name
from employees e
where e.salary>(select salary
                from employees
                where employee_id=200);
                
--sau
select employee_id,last_name
from employees e,(select salary s2
                from employees
                where employee_id=200) e2
where e.salary>e2.s2;

--ex3
SELECT department_id, department_name
FROM departments d
WHERE EXISTS (
SELECT 'x'
from employees 
WHERE department_id = d.department_id
);

--ex4
select department_id,department_name
from departments d
where d.department_id in (select department_id
from employees);

--ex5
SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS (
SELECT 'x'
from employees 
WHERE department_id = d.department_id
);

--ex6
--a)
select location_id,city
from locations
WHERE location_id NOT IN (SELECT location_id FROM departments);

--b)
select location_id,city
from locations
minus
select location_id,city
from departments INNER JOIN locations USING (location_id);

--c)
select location_id,city
from locations l
WHERE NOT EXISTS (SELECT location_id from departments d where d.location_id=l.location_id );

--d)
select  location_id,city
from locations l left outer join departments d using(location_id)
where department_id is  null;

--ex7
/*7. Determina.i numele angaja.ilor care au lucrat cel pu.in la acelea.i proiecte ca .i angajatul avand codul
202 (au lucrat la toate proiectele la care a lucrat angajatul 202 .i eventual la alte proiecte).
Observa.ie: A ?º B . A \ B = O*/


--ex12
SELECT LEVEL, employee_id, last_name, manager_id
FROM employees
CONNECT BY PRIOR manager_id = employee_id;

--ex14
SELECT LEVEL, employee_id, last_name, manager_id
FROM employees
START WITH employee_id =103
CONNECT BY manager_id = PRIOR employee_id;

--ex15
SELECT LEVEL, employee_id, last_name, manager_id
FROM employees
START WITH salary=(SELECT MIN(salary) FROM employees)
CONNECT BY PRIOR manager_id =  employee_id;

--ex16
/*16. Afi?a?i ierarhia subaltern-?ef, considerând ca r?d?cin? angajatul al c?rui cod este 206. 
S? se afi?eze codul, numele ?i salariul angajatului înso?it de codul managerului s?u, pentru angaja?ii al c?ror salariu este mai mare decât 15000.
Verifica?i ?i comenta?i rezultatul ob?inut în cazul în care:
a) condi?ia salary > 15000 apare în clauza WHERE;
b) condi?ia salary > 15000 apare în clauza CONNECT BY.
Verifica?i ?i comenta?i rezultatul ob?inut în cazul în care condi?ia impus? ar fi fost salary < 15000.
*/
--a)In acest caz afisarea incepe de la angajatul cu codul 206,dar numai de la nivelul care respecta conditia where
SELECT LEVEL, employee_id, last_name,salary, manager_id
FROM employees
WHERE salary>15000 
START WITH employee_id =206
CONNECT BY PRIOR  manager_id = employee_id;
--b)In acest caz se afiseaza doar angajatul cu codul 206
SELECT LEVEL, employee_id, last_name,salary, manager_id
FROM employees
START WITH employee_id =206
CONNECT BY  salary>15000 and PRIOR  manager_id = employee_id ;
--In cazul in care conditia ar fi salary<15000 se afiseaza angajatul cu codul 206 si seful sau=> pentru conditiile din connect by sunt afisate
--rezultate doar daca rezultatele se leaga intre ele de la radacina.


--ex17 

/*17. Afi?a?i codul, numele, data angaj?rii, salariul ?i managerul pentru:
a) subalternii direc?i ai lui De Haan;
b) ?eful direct al lui De Haan;
c) ierarhia ?ef-subaltern care începe de la De Haan;
d) angaja?ii condu?i de subalternii lui De Haan;
e) ierarhia subaltern-?ef pentru Hunold;
f) superiorul ?efului direct al lui Hunold.
*/

--a)
SELECT LEVEL,employee_id, last_name,hire_date,salary,manager_id
FROM employees
WHERE LEVEL=2
START WITH last_name LIKE  'De Haan'
CONNECT BY manager_id =  PRIOR  employee_id;

--b)
SELECT LEVEL,employee_id, last_name,hire_date,salary,manager_id
FROM employees
WHERE LEVEL=2
START WITH last_name LIKE  'De Haan'
CONNECT BY  PRIOR manager_id =   employee_id;

--c)
SELECT LEVEL,employee_id, last_name,hire_date,salary,manager_id
FROM employees
START WITH last_name LIKE  'De Haan'
CONNECT BY manager_id =  PRIOR  employee_id;

--d)
SELECT LEVEL,employee_id, last_name,hire_date,salary,manager_id
FROM employees
WHERE LEVEL=3
START WITH last_name LIKE  'De Haan'
CONNECT BY manager_id =  PRIOR  employee_id;

--e)
SELECT LEVEL,employee_id, last_name,hire_date,salary,manager_id
FROM employees
START WITH last_name LIKE  'Hunold'
CONNECT BY PRIOR manager_id = employee_id;

--f)
SELECT LEVEL,employee_id, last_name,hire_date,salary,manager_id
FROM employees
WHERE LEVEL=3
START WITH last_name LIKE  'Hunold'
CONNECT BY PRIOR manager_id = employee_id;


--ex18.Câþi sefi pe linie ierarhicã are angajatul 107?
SELECT COUNT(*)-1
FROM employees
START WITH employee_id=107
CONNECT BY PRIOR manager_id = employee_id;

--ex19.Obtineni ierarhia subaltern-sef pentru toti managerii de departamente.
SELECT level, e.employee_id,e.last_name,e.manager_id,s.last_name
FROM employees e inner join employees s on s.employee_id=e.manager_id
WHERE e.manager_id is not null
CONNECT BY PRIOR e.manager_id=e.employee_id;

WHERE employee_id in (SELECT manager_id from departments where manager_id is not null)
select * 
from employees 
where employee_id=100;

SELECT manager_id from departments;
--ex20. Pentru fiecare angajat determina?i nivelul s?u ierarhic în companie.
SELECT employee_id,MAX(LEVEL),manager_id
FROM employees
CONNECT BY PRIOR manager_id = employee_id
GROUP BY employee_id,manager_id
ORDER BY MAX(level) desc;

--ex21.Ob?ine?i nivelul ierarhic în companie al ?efilor de departamente.
SELECT employee_id,MAX(LEVEL),manager_id
FROM employees
WHERE employee_id IN (SELECT manager_id FROM departments)
CONNECT BY PRIOR manager_id = employee_id
GROUP BY employee_id,manager_id
ORDER BY MAX(level) desc;


--24. a) Modifica?i cererea anterioar? astfel încât din rezultat s? fie exclus 
--angajatul De Haan, dar nu ?i subordona?ii s?i.
--Observa?ie: Pentru aceasta se include condi?ia într-o clauz? WHERE.

SET LINESIZE 100
SET PAGESIZE 100
COLUMN nume FORMAT a25;
SELECT LPAD(' ', 3*LEVEL-3)||last_name nume, LEVEL,
employee_id, manager_id, department_id
FROM employees
WHERE last_name not like 'De Haan'
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id= manager_id;

/*b) Modifica?i cererea anterioar? astfel încât din rezultat s? fie exclus angajatul De Haan împreun? cu subordona?ii s?i.
Observa?ie: Pentru aceasta se include condi?ia în clauza CONNECT BY.*/

SET LINESIZE 100
SET PAGESIZE 100
COLUMN nume FORMAT a25;
SELECT LPAD(' ', 3*LEVEL-3)||last_name nume, LEVEL,
employee_id, manager_id, department_id
FROM employees
START WITH manager_id IS NULL
CONNECT BY  last_name not like 'De Haan' and PRIOR employee_id= manager_id;

--ex26
--Nu este necesara clauza group by