--2. Afisati numele angajatului, numele departamentului pentru toti angajatii care câstiga comision
SELECT last_name ,department_name,commission_pct
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id=d.department_id  
WHERE commission_pct is not null;

--3.Afisati numele job-urile care exista în departamentul 30.
SELECT j.job_title
FROM  employees e JOIN jobs j
ON  e.job_id = j.job_id
WHERE  e.department_id=30;


/*5. Afisati numele, salariul, data angajarii si numele departamentului pentru toti programatorii (numele
jobului este Programmer) care lucreaza în America de Nord sau în America de Sud (numele regiunii este
Americas).*/
SELECT e.last_name,e.salary,e.hire_date,d.department_name
FROM employees e INNER JOIN jobs j ON e.job_id=j.job_id 
INNER JOIN departments d ON e.department_id=d.department_id 
INNER JOIN  locations l ON d.location_id = l.location_id 
INNER JOIN countries c ON  l.country_id = c.country_id
INNER JOIN regions r ON c.region_id = r.region_id
WHERE j.Job_Title Like 'Programmer' AND r.region_name like 'Americas';

/*6. Afi?a?i numele salaria?ilor ?i numele departamentelor în care lucreaz?. Se vor afi?a ?i salaria?ii al c?ror
departament nu este cunoscut (left outher join).*/
SELECT last_name, department_name
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id = d.department_id;

/*7. Afi?a?i numele departamentelor ?i numele salaria?ilor care lucreaz? în acestea. Se vor afi?a ?i
departamentele care nu au salaria?i (right outher join).*/
SELECT department_name,last_name
FROM employees e RIGHT OUTER JOIN departments d 
ON e.department_id= d.department_id;

/*8. Afisati numele departamentelor si numele salariatilor care lucreaza în acestea. 
Se vor afisati salariatii al caror departament nu este cunoscut, respectiv si departamentele care nu au salariati (full outher join).
Observatie: full outer join = left outer join UNION right outer join */
SELECT department_name,last_name
FROM  employees e FULL OUTER JOIN departments d
ON e.department_id=d.department_id;


--9.Afi?a?i numele, job-ul, numele departamentului, salariul ?i grila de salarizare pentru to?i angaja?ii.
SELECT last_name,job_title,department_name,salary,grade_level
FROM employees e INNER JOIN departments d ON e.department_id=d.department_id
INNER JOIN  jobs j ON e.job_id=j.job_id
CROSS JOIN job_grades 
WHERE salary between lowest_sal and highest_sal ;

/*10. Afisati codul angajatului si numele acestuia, împreuna cu numele si codul sefului sau direct.
Etichetati coloanele CodAng, NumeAng, CodMgr, NumeMgr.*/
SELECT a.employee_id "CodAng", a.last_name "NumeAng",
b.employee_id "CodMgr", b.last_name "NumeMgr"
FROM employees a CROSS JOIN employees b
WHERE a.manager_id = b. employee_id;

--11. Modifica?i cererea anterioar? astfel încât s? afi?a?i to?i salaria?ii, inclusiv pe cei care nu au ?ef.

SELECT a.employee_id "CodAng", a.last_name "NumeAng",
b.employee_id "CodMgr", b.last_name "NumeMgr"
FROM employees a LEFT OUTER JOIN employees b
ON a.manager_id = b. employee_id;

/*12. Afi?a?i numele salariatului ?i data angaj?rii împreun? cu numele ?i data angaj?rii ?efului direct
pentru salaria?ii care au fost angaja?i înaintea ?efilor lor.*/
SELECT a.last_name,a.hire_date,b.last_name,b.hire_date
FROM employees a CROSS JOIN employees b
WHERE a.manager_id=b.employee_id 
AND a.hire_date < b.hire_date ;

/*13. Pentru fiecare angajat din departamentele 20 ?i 30 afi?a?i numele,
codul departamentului ?i to?i colegii s?i (salaria?ii care lucreaz? în acela?i departament cu el).*/
SELECT e1.last_name,e1.department_id,e2.last_name,e2.department_id
FROM employees e1 CROSS JOIN employees e2
WHERE e1.department_id=e2.department_id 
AND (e1.employee_id <> e2.employee_id)
AND e1.department_id IN (20,30);

--14. Afi?a?i numele ?i data angaj?rii pentru salaria?ii care au fost angaja?i dup? Fay.
SELECT last_name, hire_date
FROM employees
WHERE hire_date > (SELECT hire_date
FROM employees
WHERE last_name = 'Fay');

--15.Rezolvati exercitiul anterior folosind JOIN-URI.
SELECT e1.last_name,e1.hire_date
FROM employees e1 CROSS JOIN employees e2 
WHERE e1.hire_date > e2.hire_date
AND UPPER(e2.last_name)='FAY';

--16. Scrie?i o cerere pentru a afi?a numele ?i salariul pentru to?i colegii (din acela?i departament) lui Fay. Se va exclude Fay.
SELECT e1.last_name,e1.salary
FROM employees e1 CROSS JOIN employees e2
WHERE e1.department_id=e2.department_id
AND UPPER(e2.last_name)='FAY' 
AND e1.employee_id<>e2.employee_id;

--17. Afi?a?i numele ?i salariul angaja?ilor condu?i direct de Steven King.
SELECT e1.last_name,e1.salary
FROM employees e1 CROSS JOIN employees e2
WHERE e1.manager_id = e2.employee_id
AND UPPER(e2.last_name)='KING'
AND UPPER(e2.first_name)='STEVEN';


--18. Afisati numele si job-ul tuturor angajatilor din departamentul 'Sales'.
SELECT last_name, job_id
FROM employees
WHERE department_id = (SELECT department_id
FROM departments
WHERE department_name ='Sales');

--19. Rezolva?i exerci?iul anterior utilizând join-uri.
SELECT last_name,job_id
FROM employees e INNER JOIN departments d
ON (e.department_id=d.department_id)
WHERE d.department_name='Sales';

--20. Afisati numele angajatilor, numarul departamentului si job-ul tuturor salariatilor al caror departament este localizat in Seattle.
SELECT last_name, job_id, department_id
FROM employees
WHERE department_id IN
(SELECT department_id
FROM departments
WHERE location_id = (SELECT location_id
FROM locations
WHERE city = 'Seattle'));

--21.Rezolva?i exerci?iul anterior utilizând join-uri.
SELECT last_name,e.department_id,job_id
FROM employees e INNER JOIN departments d
ON e.department_id=d.department_id
INNER JOIN locations l
ON d.location_id=l.location_id
WHERE city='Seattle';

/*22. Afla?i dac? exist? angaja?i care nu lucreaz? în departamentul Sales, 
dar au acelea?i câ?tiguri (salariu ?i comision) ca ?i un angajat din departamentul Sales.*/
SELECT last_name, salary, commission_pct, department_id
FROM employees
WHERE (salary, nvl(commission_pct,0)) IN
(SELECT salary, nvl(commission_pct,0)
FROM employees E, departments D
WHERE e.department_id = d.department_id
AND department_name = 'Sales')
AND department_id <> (SELECT department_id
FROM departments
WHERE department_name = 'Sales');

/*23. Scrie?i o cerere pentru a afi?a angaja?ii care câ?tig? mai mult decât oricare func?ionar.
Sorta?i rezultatele dup? salariu, în ordine descresc?toare.*/
SELECT last_name, salary, job_id
FROM employees
WHERE salary > (SELECT MAX(salary)
FROM employees
WHERE job_id LIKE '%CLERK')
ORDER BY salary DESC;

--24. Afi?a?i salaria?ii care au acela?i manager ca ?i angajatul având codul 140.
SELECT e1.last_name
FROM employees e1 CROSS JOIN employees e2
WHERE e1.manager_id=e2.manager_id 
AND e2.employee_id=140
AND e1.employee_id<>e2.employee_id;

--25.Afi?a?i numele departamentelor care func?ioneaz? în America.
SELECT department_name
FROM departments d INNER JOIN locations l
ON(d.location_id=l.location_id)
INNER JOIN countries c
ON(l.country_id=c.country_id)
INNER JOIN regions r
ON(c.region_id=r.region_id)
WHERE r.region_name='Americas';

--26. Afisati numele angajatului, numele sefului sau direct, respectiv numele sefului caruia i se subordoneaza seful sau direct.
SELECT e1.last_name,e2.last_name,e3.last_name,e2.manager_id
FROM employees e1 CROSS JOIN employees e2
CROSS JOIN employees e3
WHERE e1.manager_id=e2.employee_id
AND e2.manager_id=e3.employee_id;

--27. Afi?a?i codul, numele ?i salariul tuturor angaja?ilor care câ?tig? mai mult decât salariul mediu.
SELECT employee_id,last_name,salary
FROM employees
WHERE salary>(SELECT AVG(salary) from employees);

--28. Afisati pentru fiecare salariat angajat în luna martie numele s?u, data angaj?rii ?i numele jobului.
SELECT last_name,hire_date,job_title
FROM employees e INNER JOIN jobs j
ON  e.job_id=j.job_id
WHERE TO_CHAR(HIRE_DATE,'Mon')='Mar';

/*29. Afisati pentru fiecare salariat al c?rui câ?tig total lunar este mai mare decât 12000 numele s?u, 
câ?tigul total lunar ?i numele departamentului în care lucreaz?.*/
SELECT last_name,salary+(nvl(commission_pct,0)*salary) as "Castig lunar",department_name
FROM employees e INNER JOIN departments d
ON(e.department_id=d.department_id)
WHERE  salary+(nvl(commission_pct,0)*salary)>12000;

/*30. Afisati pentru fiecare angajat codul sau si numele joburilor sale anterioare,
precum si intervalul de timp în care a lucrat pe jobul respectiv.*/
SELECT e.employee_id,j.job_title,TO_CHAR(jh.end_date-jh.start_date) as "Interval de timp"
FROM employees e INNER JOIN job_history jh
ON(e.employee_id=jh.employee_id)
INNER JOIN jobs j
ON(jh.job_id=j.job_id);

--31. Modificati cererea de la punctul 30 astfel incat sa se afiseze si numele angajatului, respectiv codul jobului sau curent.
SELECT e.last_name,e.job_id as "Job curent",e.employee_id,j.job_title,TO_CHAR(jh.end_date-jh.start_date) as "Interval de timp"
FROM employees e INNER JOIN job_history jh
ON(e.employee_id=jh.employee_id)
INNER JOIN jobs j
ON(jh.job_id=j.job_id);

--32. Modificati cererea de la punctul 31 astfel incat sa se afiseze si numele jobului sau curent.
SELECT e.last_name,e.job_id as "Job curent",j.job_title,e.employee_id,j.job_title,TO_CHAR(jh.end_date-jh.start_date) as "Interval de timp"
FROM employees e INNER JOIN job_history jh
ON(e.employee_id=jh.employee_id)
INNER JOIN jobs j
ON(e.job_id=j.job_id);

/*33. Modificati cererea de la punctul 32 astfel incat sa se afiseze informatiile cerute doar 
pentru angajatii care au lucrat in trecut pe acelasi job pe care lucreaza in prezent.*/
SELECT e.last_name,e.job_id as "Job curent",j.job_title,e.employee_id,j.job_title,TO_CHAR(jh.end_date-jh.start_date) as "Interval de timp"
FROM employees e INNER JOIN job_history jh
ON(e.employee_id=jh.employee_id)
INNER JOIN jobs j
ON(e.job_id=j.job_id)
WHERE e.job_id=jh.job_id;

/*34. Modificati cererea de la punctul 33 astfel incat sa se afiseze in plus numele departamentului in care a lucrat angajatul 
in trecut, respectiv numele departamentului in care lucreaza in prezent.*/
SELECT d1.department_name,d2.department_name,e.last_name,e.job_id as "Job curent",j.job_title,e.employee_id,j.job_title,TO_CHAR(jh.end_date-jh.start_date) as "Interval de timp"
FROM employees e INNER JOIN job_history jh
ON(e.employee_id=jh.employee_id)
INNER JOIN jobs j
ON(e.job_id=j.job_id)
INNER JOIN departments d1
ON(e.department_id=d1.department_id)
INNER JOIN departments d2
ON(jh.department_id=d2.department_id)
WHERE e.job_id=jh.job_id;

/*35. Modificati cererea de la punctul 34 incat sa se afiseze informatiile cerute doar pentru angajatii care au lucrat in trecut pe 
acelasi job pe care lucreaza in prezent, dar in departamente diferite.*/
SELECT d1.department_name,d2.department_name,e.last_name,e.job_id as "Job curent",j.job_title,e.employee_id,j.job_title,TO_CHAR(jh.end_date-jh.start_date) as "Interval de timp"
FROM employees e INNER JOIN job_history jh
ON(e.employee_id=jh.employee_id)
INNER JOIN jobs j
ON(e.job_id=j.job_id)
INNER JOIN departments d1
ON(e.department_id=d1.department_id)
INNER JOIN departments d2
ON(jh.department_id=d2.department_id)
WHERE e.job_id=jh.job_id
AND d1.department_name<>d2.department_name;






