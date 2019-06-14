-- File: companyDML-a-solution 
-- SQL/DML HOMEWORK (on the COMPANY database)
/*
Every query is worth 2 point. There is no partial credit for a
partially working query - think of this hwk as a large program and each query is a small part of the program.
--
IMPORTANT SPECIFICATIONS
--
(A)
-- Download the script file company.sql and use it to create your COMPANY database.
-- Dowlnoad the file companyDBinstance; it is provided for your convenience when checking the results of your queries.
(B)
Implement the queries below by ***editing this file*** to include
your name and your SQL code in the indicated places.   
--
(C)
IMPORTANT:
-- Don't use views
-- Don't use inline queries in the FROM clause - see our class notes.
--
(D)
After you have written the SQL code in the appropriate places:
** Run this file (from the command line in sqlplus).
** Print the resulting spooled file (companyDML-a.out) and submit the printout in class on the due date.
--
**** Note: you can use Apex to develop the individual queries. However, you ***MUST*** run this file from the command line as just explained above and then submit a printout of the spooled file. Submitting a printout of the webpage resulting from Apex will *NOT* be accepted.
--
*/
-- Please don't remove the SET ECHO command below.
SPOOL companyDML-a.out
SET ECHO ON
-- ---------------------------------------------------------------
-- 
-- Name: <Jake Miller>
--
-- ------------------------------------------------------------
-- NULL AND SUBSTRINGS -------------------------------
--
/*(10A)
Find the ssn and last name of every employee who doesn't have a  supervisor, or his last name contains at least two occurences of the letter 'a'. Sort the results by ssn.
*/
SELECT E.ssn, E.lname
FROM employee E
WHERE E.super_ssn IS NULL OR 
	(E.lname LIKE '%a%' AND 
		E.lname LIKE '%a%')
ORDER BY E.ssn;
--
-- JOINING 3 TABLES ------------------------------
-- 
/*(11A)
For every employee who works more than 30 hours on any project: Find the ssn, lname, project number, project name, and numer of hours. Sort the results by ssn.
*/
SELECT E.ssn, E.lname, W.pno, P.pname, W.hours
FROM employee E, works_on W, project P
WHERE E.ssn = W.essn AND 
	P.pnumber = W.pno AND 
		W.hours > 30
ORDER BY E.ssn;
--
-- JOINING 3 TABLES ---------------------------
--
/*(12A)
Write a query that consists of one block only.
For every employee who works on a project that is not controlled by the department he works for: Find the employee's lname, the department he works for, the project number that he works on, and the number of the department that controls that project. Sort the results by lname.
*/
SELECT e.lname, e.dno, w.pno, p.dnum
FROM employee e, project p, works_on w
WHERE e.dno != p.dnum AND 
	e.ssn = w.essn AND 
		p.pnumber = w.pno
ORDER BY e.lname;
			
--
-- JOINING 4 TABLES -------------------------
--
/*(13A)
For every employee who works for more than 20 hours on any project that is located in the same location as his department: Find the ssn, lname, project number, project location, department number, and department location.Sort the results by lname
*/
SELECT e.ssn, e.lname, w.pno, p.plocation, dl.dnumber, dl.dlocation
FROM employee e, works_on w, project p, dept_locations dl
WHERE e.ssn = w.essn AND
	w.pno = p.pnumber AND
		e.dno = dl.dnumber AND
			w.hours > 20 AND
				p.plocation = dl.dlocation
ORDER BY e.lname;
		
-- SELF JOIN -------------------------------------------
-- 
/*(14A)
Write a query that consists of one block only.
For every employee whose salary is less than 70% of his immediate supervisor's salary: Find his ssn, lname, salary; and his supervisor's ssn, lname, and salary. Sort the results by ssn.  
*/
SELECT e1.ssn, e1.lname, e1.salary, e2.ssn, e2.lname, e2.salary
FROM employee e1, employee e2
WHERE e1.super_ssn = e2.ssn AND
	e1.salary < (e2.salary * .7)
ORDER BY e1.ssn;
--
-- USING MORE THAN ONE RANGE VARIABLE ON ONE TABLE -------------------
--
/*(15A)
For projects located in Houston: Find pairs of last names such that the two employees in the pair work on the same project. Remove duplicates. Sort the result by the lname in the left column in the result. 
*/
SELECT distinct e1.lname, e2.lname
FROM employee e1, employee e2, works_on w1, project p, works_on w2
WHERE e1.ssn = w1.essn AND
	e2.ssn = w2.essn AND
	e1.ssn < e2.ssn AND
	w1.pno = w2.pno AND
	w1.pno = p.pnumber AND
	p.plocation = 'Houston'
ORDER BY e1.lname;
		
--
------------------------------------
--
/*(16A) Hint: A NULL in the hours column should be considered as zero hours.
Find the ssn, lname, and the total number of hours worked on projects for every employee whose total is less than 40 hours. Sort the result by lname
*/ 
SELECT e.ssn, e.lname, SUM(w.hours)
FROM employee e, works_on w
WHERE w.essn = e.ssn
GROUP BY e.ssn, e.lname
HAVING SUM(w.hours) < 40.0 OR
	SUM(w.hours) IS NULL
ORDER BY e.lname;
--
------------------------------------
-- 
/*(17A)
For every project that has more than 2 employees working on it: Find the project number, project name, number of employees working on it, and the total number of hours worked by all employees on that project. Sort the results by project number.
*/ 
SELECT p.pnumber, p.pname, COUNT(*), SUM(w.hours)
FROM project p, works_on w
WHERE w.pno = p.pnumber
GROUP BY p.pnumber, p.pname
HAVING COUNT(*)>2
ORDER BY p.pnumber;
-- 
-- CORRELATED SUBQUERY --------------------------------
--
/*(18A)
For every employee who has the highest salary in his department: Find the dno, ssn, lname, and salary . Sort the results by department number.
*/
SELECT e.dno, e.ssn, e.lname, e.salary
FROM employee e
WHERE e.salary = (SELECT MAX(e2.salary)
	FROM employee e2
	WHERE e.dno = e2.dno)
ORDER BY e.dno;
--
-- NON-CORRELATED SUBQUERY -------------------------------
--
/*(19A)
For every employee who does not work on any project that is located in Houston: Find the ssn and lname. Sort the results by lname
*/
SELECT e.ssn, e.lname
FROM employee e, works_on w
WHERE w.essn = e.ssn AND
	w.pno NOT IN (SELECT p.pnumber
		FROM project p
		Where p.plocation = 'Houston')
	GROUP BY e.ssn, e.lname
ORDER BY e.lname;
--
-- DIVISION ---------------------------------------------
--
/*(20A) Hint: This is a DIVISION query
For every employee who works on every project that is located in Stafford: Find the ssn and lname. Sort the results by lname
*/
SELECT e.ssn, e.lname
FROM employee e
WHERE NOT EXISTS((SELECT p.pnumber
	FROM project p
	WHERE p.plocation = 'Stafford')
	MINUS
	(SELECT p.pnumber
	FROM works_on w, project p
	where w.essn = e.ssn AND
		w.pno = p.pnumber AND
			p.plocation = 'Stafford'))
ORDER BY e.lname;
--
SET ECHO OFF
SPOOL OFF


