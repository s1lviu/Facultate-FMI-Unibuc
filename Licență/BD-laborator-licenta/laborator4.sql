/*
2. Utilizând func?ia grup COUNT determina?i:
a. num?rul total de angaja?i;
b. num?rul de angaja?i care au manager;
c. num?rul de manageri.
*/

SELECT COUNT(employee_id) as "Numarul angajatiilor" , COUNT(manager_id) as "Angajati cu superiori" ,COUNT(DISTINCT manager_id) as "Numar manageri"
FROM employees;

--3. Afi?a?i diferen?a dintre cel mai mare ?i cel mai mic salariu. Eticheta?i coloana “Diferenta”.
SELECT MAX(salary)-MIN(salary) as "Diferenta"
FROM employees;

--4. Ob?ine?i num?rul de angaja?i din departamentul având codul 50.
SELECT COUNT(employee_id)
FROM employees
WHERE department_id=50;

--5. Câ?i angaja?i din departamentul 80 câ?tig? comision?
SELECT COUNT(employee_id)
FROM employees
WHERE department_id=80 AND commission_pct IS NOT null;


/*6. Determina?i valoarea medie ?i suma salariilor pentru to?i angaja?ii care 
sunt reprezentan?i de vânz?ri (codul jobului este SA_MAN, SA_REP).*/
SELECT AVG(salary),SUM(salary)
FROM employees
WHERE job_id='SA_MAN' OR job_id='SA_REP';

/*
7. a. Selecta?i data angaj?rii primei persoane care a fost angajat? de companie (?inând cont ?i de istoricul angaja?ilor).
b. Selecta?i numele persoanelor care au fost angajate primele în companie.
*/
--a)
SELECT MIN(start_date)
FROM employees e INNER JOIN job_history j
ON (e.employee_id=j.employee_id);

--b)
SELECT last_name as "Nume angajat",MIN(start_date) as "Data angajarii"
FROM employees e INNER JOIN job_history j
ON (e.employee_id=j.employee_id)
GROUP BY last_name
ORDER BY 2 ;


--8. Afi?a?i num?rul de angaja?i pentru fiecare job.
SELECT job_id, COUNT(employee_id) nr_angajati
FROM employees
GROUP BY job_id;

--9. Afi?a?i minimul, maximul, suma ?i media salariilor pentru fiecare departament.
SELECT department_id,MIN(salary),MAX(salary),SUM(salary),ROUND(AVG(salary))
FROM employees
GROUP BY department_id;

--10. Afi?a?i codul departamentului ?i media salariilor pentru fiecare job din cadrul acestuia.
SELECT job_id,department_id ,ROUND(AVG(salary))
FROM employees
GROUP BY department_id,job_id
ORDER BY department_id;

--11. a. Afi?a?i codul departamentelor pentru care salariul minim dep??e?te 5000$.
SELECT department_id, MIN(salary)
FROM employees
GROUP BY department_id
HAVING MIN(salary)>5000;

--b. Modifica?i cererea anterioar? astfel încât s? afi?a?i numele acestor departamente.
SELECT e.department_id,department_name, MIN(salary)
FROM employees e LEFT OUTER JOIN departments d
ON (d.department_id=e.department_id)
GROUP BY e.department_id,department_name
HAVING MIN(salary)>5000;

c. Modifica?i cererea anterioar? astfel încât s? afi?a?i ?i ora?ul în care func?ioneaz? departamentele.

SELECT e.department_id,department_name,city, MIN(salary)
FROM employees e LEFT OUTER JOIN departments d
INNER JOIN locations l ON (l.location_id=d.location_id)
ON (d.department_id=e.department_id)
GROUP BY e.department_id,department_name,city
HAVING MIN(salary)>5000;

/*12. Ob?ine?i codul departamentelor ?i num?rul de angaja?i al acestora pentru departamentele în care lucreaz? cel pu?in 10 angaja?i.*/
SELECT department_id as "Cod department",COUNT(employee_id) as "Numar angajati"
FROM employees
GROUP BY department_id
HAVING COUNT(employee_id) > 9 ;


--13. Câte departamente au cel pu?in 10 angaja?i?
SELECT COUNT(COUNT(employee_id))
FROM employees
GROUP BY department_id
HAVING COUNT(*) > =10;

/*14. Obþineþi codul departamentelor ºi suma salariilor angajaþilor care lucreazã în acestea, în ordine crescãtoare dupã suma salariilor.
Se considerã angajaþii care au comision ºi departamentele care au mai mult de 5 angajaþi.*/
SELECT department_id,SUM(salary)
FROM employees
WHERE commission_pct IS NOT null 
GROUP BY department_id
HAVING COUNT(employee_id) > 4
ORDER BY 2;

--15. Determina?i numele angaja?ilor care au mai avut cel pu?in dou? joburi.
SELECT last_name,e.employee_id
FROM employees e INNER JOIN job_history j
ON (e.employee_id=j.employee_id)
GROUP BY last_name,e.employee_id
HAVING COUNT(e.job_id) > 1;

--16. Afiºaþi job-ul pentru care salariul mediu este minim.
SELECT job_id
FROM employees
GROUP BY job_id
HAVING AVG(salary) = (SELECT MIN(AVG(salary))
FROM employees
GROUP BY job_id);

--17. Afiºaþi cel mai mare dintre salariile medii pe departamente.
SELECT ROUND(MAX(AVG(salary)),2) as "Salariu maxim"
FROM employees
GROUP BY department_id;

--18. a. Afiºaþi codul, numele departamentului ºi suma salariilor pe departamente.
SELECT d.department_id, department_name,a.suma
FROM departments d, (SELECT department_id ,SUM(salary) suma
FROM employees
GROUP BY department_id) a
WHERE d.department_id =a.department_id;

b. Daþi o altã metodã de rezolvare a acestei probleme.

SELECT d.department_id,department_name,SUM(salary) as  "Suma salarii"
FROM employees  e INNER JOIN departments d 
ON(e.department_id=d.department_id)
GROUP BY d.department_id,department_name;

/*19. a. Scrieþi o cerere pentru a afiºa numele departamentului, numãrul de
angajaþi ºi salariul mediu pentru angajaþii din acel departament. 
Coloanele vor fi etichetate Departament, Nr. angajati, Salariu Mediu.*/
SELECT department_name "Departament ",
(SELECT COUNT(employee_id)
FROM employees
WHERE department_id = d.department_id ) "Nr. angajati",
(SELECT AVG(salary)
FROM employees
WHERE department_id = d.department_id) "Salariu mediu"
FROM departments d;

--b. Da?i o alt? metod? de rezolvare pentru problema anterioar?.
SELECT department_name as "Department",COUNT(employee_id) as "Nr. angajati",
     ROUND(AVG(salary)) as "Salariu Mediu"
FROM employees e RIGHT OUTER JOIN departments d
ON(e.department_id=d.department_id)
GROUP BY department_name
ORDER BY 2 desc;

/*20. a. Scrieþi o cerere pentru a afiºa job-ul, salariul total pentru job-ul respectiv
pe departamentele 10, 20 ºi 30, respectiv salariul total pentru job-ul respectiv pe toate cele
3 departamente. Etichetaþi coloanele corespunzãtor. Datele vor fi afiºate în urmãtoarea formã:
Job Dep10 Dep20 Dep30 Total
---------------------------------------------------
J1 10 5 25 40
J2 15 10 25
*/
SELECT DISTINCT job_id,
(SELECT SUM(salary)
FROM employees
WHERE job_id=e.job_id AND department_id =10
GROUP BY job_id) dep10,
(SELECT SUM(salary)
FROM employees
WHERE job_id=e.job_id AND department_id =20
GROUP BY job_id) dep20,
(SELECT SUM(salary)
FROM employees
WHERE job_id=e.job_id AND department_id =30
GROUP BY job_id) dep30,
(SELECT SUM(salary)
FROM employees
WHERE job_id=e.job_id AND department_id IN (10, 20,30)
GROUP BY job_id) total
FROM employees e;
/*
b. Clauzele GROUP BY din subcererile anterioare sunt necesare?
nu
c. Este necesar? o clauz? GROUP BY în cererea principal??
nu
d. Clauza SELECT a cererii principale trebuie s? utilizeze op?iunea DISTINCT?
da
e. Da?i o alt? metod? de rezolvare utilizând func?ia DECODE.
Indica?ie: SUM(DECODE(department_id,10,salary))
*/

SELECT DISTINCT job_id,
SUM(DECODE(department_id,10,salary)) as DEP10,
SUM(DECODE(department_id,20,salary)) as DEP20,
SUM(DECODE(department_id,30,salary)) as DEP30,
 NULLIF(NVL(SUM(DECODE(department_id,30,salary)),0)
 +NVL(SUM(DECODE(department_id,20,salary)),0)
 +NVL(SUM(DECODE(department_id,10,salary)),0),0) as Total
FROM employees
GROUP BY job_id;

/*21. S? se creeze o cerere prin care s? se afi?eze num?rul total de angaja?i ?i,
din acest total, num?rul celor care au fost angaja?i în 1997, 1998, 1999 ?i 2000. 
Datele vor fi afi?ate în forma urm?toare:
1997 1998 1999 2000 Total
---------------------------------------------------
10 5 25 10 50
Indica?ie: SUM(DECODE(TO_CHAR(hire_date,'yyyy'),1997,1,0))
*/
SELECT 
   (SELECT COUNT(employee_id) 
    FROM employees
    WHERE TO_CHAR(hire_date,'yyyy') = '1997')as "1997",
    (SELECT COUNT(employee_id) 
    FROM employees
    WHERE TO_CHAR(hire_date,'yyyy')='1998') as "1998",
    (SELECT COUNT(employee_id) 
    FROM employees
    WHERE TO_CHAR(hire_date,'yyyy')='1999') as "1999",
    (SELECT COUNT(employee_id) 
    FROM employees
    WHERE TO_CHAR(hire_date,'yyyy')='2000') as "2000",
   (SELECT COUNT(employee_id)  from employees WHERE TO_CHAR(hire_date,'yyyy')='1997' or  TO_CHAR(hire_date,'yyyy')='1998' or TO_CHAR(hire_date,'yyyy')='1999' or TO_CHAR(hire_date,'yyyy')='2000' ) as "Total"
   FROM dual;
   
   
   