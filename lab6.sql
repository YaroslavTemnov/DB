--Part 1
--preparation

-- Create table: employees
CREATE TABLE employees (
 emp_id INT PRIMARY KEY,
 emp_name VARCHAR(50),
 dept_id INT,
 salary DECIMAL(10, 2)
);
-- Create table: departments
CREATE TABLE departments (
 dept_id INT PRIMARY KEY,
 dept_name VARCHAR(50),
 location VARCHAR(50)
);
-- Create table: projects
CREATE TABLE projects (
 project_id INT PRIMARY KEY,
 project_name VARCHAR(50),
 dept_id INT,
 budget DECIMAL(10, 2)
);

-- Insert data into employees
INSERT INTO employees (emp_id, emp_name, dept_id, salary)
VALUES
(1, 'John Smith', 101, 50000),
(2, 'Jane Doe', 102, 60000),
(3, 'Mike Johnson', 101, 55000),
(4, 'Sarah Williams', 103, 65000),
(5, 'Tom Brown', NULL, 45000);
-- Insert data into departments
INSERT INTO departments (dept_id, dept_name, location) VALUES
(101, 'IT', 'Building A'),
(102, 'HR', 'Building B'),
(103, 'Finance', 'Building C'),
(104, 'Marketing', 'Building D');
-- Insert data into projects
INSERT INTO projects (project_id, project_name, dept_id,
budget) VALUES
(1, 'Website Redesign', 101, 100000),
(2, 'Employee Training', 102, 50000),
(3, 'Budget Analysis', 103, 75000),
(4, 'Cloud Migration', 101, 150000),
(5, 'AI Research', NULL, 200000);

-- Part 2
-- Exercise 2.1
-- There are 5 rows in the employees table and 4 rows in the department table.
-- So the result of cross join will be 5 * 4 = 20 rows

SELECT e.emp_name, d.dept_name
FROM employees e CROSS JOIN departments d;

-- Exercise 2.2

SELECT e.emp_name, d.dept_name
FROM employees e, departments d;


SELECT e.emp_name, d.dept_name
FROM employees e JOIN departments d ON TRUE;

--Exercise 2.3
SELECT emp_name, project_name
FROM employees CROSS JOIN projects;

-- The result is 25 rows which is 5 rows from table employees * 5 from table projects

-- Part 3
-- Exercise 3.1
-- There are 4 rows in employee where are dept_id is not null, so the result will be 4 rows
-- Tom Brown's dept_id is null so it will be not returning in resulting table of inner join

-- Your query here
SELECT e.emp_name, d.dept_name, d.location
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

-- Exercise 3.2
-- There is no difference in output between this and previous queries

SELECT emp_name, dept_name, location
FROM employees
INNER JOIN departments USING (dept_id);

-- Exercise 3.3
-- The result of the query here is the same as in previous two
SELECT emp_name, dept_name, location
FROM employees
NATURAL INNER JOIN departments;

-- Exercise 3.4
SELECT e.emp_name, d.dept_name, p.project_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
INNER JOIN projects p ON d.dept_id = p.dept_id;

-- Part 4
-- Exercise 4.1
-- Tom Brown is in resulting table because left join return all rows from left table even without matches with right table
SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
dept_dept, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- Exercise 4.2

SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
dept_dept, d.dept_name
FROM employees e
LEFT JOIN departments d USING(dept_id);

-- Exercise 4.3

SELECT e.emp_name, e.dept_id
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

-- Exercise 4.4
SELECT d.dept_name, COUNT(e.emp_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY employee_count DESC;

-- Part 5
-- Exercise 5.1
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- Exercise 5.2

SELECT dept_name, emp_name
FROM departments
LEFT JOIN employees USING (dept_id);

-- Exercise 5.3
SELECT d.dept_name, d.location
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL

-- Part 6
-- Exercise 6.1

-- marketing have NULL on the left side. Tom Brown have NULL on the right side.

SELECT e.emp_name, e.dept_id AS emp_dept, d.dept_id AS
dept_dept, d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id;

-- Exercise 6.2
SELECT d.dept_name, p.project_name, p.budget
FROM departments d
FULL JOIN projects p ON d.dept_id = p.dept_id;

-- Exercise 6.3
SELECT
 e.emp_name,
 d.dept_name
FROM employees e
FULL JOIN departments d ON e.dept_id = d.dept_id
WHERE e.emp_id IS NULL OR d.dept_id IS NULL;

-- Part 7
-- Exercise 7.1
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id AND
d.location = 'Building A';

-- Exercise 7.2

-- The difference is in number of rows in result. It is because ON applies all from left table and then matches departments in Building A
-- And WHERE just filters all rows and applies only those which in Building A after the ON

SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';

-- Exercise 7.3

-- There is no difference between these two queries because INNER JOIN return only those rows from two tables, which matches according to conditions.
-- The conditions were same dept_id and both in building A, so there is no difference with query with WHERE

SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id AND
d.location = 'Building A';

SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';

-- Part 8
-- Exercise 8.1
SELECT d.dept_name, e.emp_name, e.salary, p.project_name, p.budget
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
LEFT JOIN projects p ON d.dept_id = p.dept_id
ORDER BY d.dept_name, e.emp_name;

-- Exercise 8.2
ALTER TABLE employees ADD COLUMN manager_id INT;

UPDATE employees SET manager_id = 3 WHERE emp_id = 1;
UPDATE employees SET manager_id = 3 WHERE emp_id = 2;
UPDATE employees SET manager_id = NULL WHERE emp_id = 3;
UPDATE employees SET manager_id = 3 WHERE emp_id = 4;
UPDATE employees SET manager_id = 3 WHERE emp_id = 5;

SELECT e.emp_name AS employee, m.emp_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Exercise 8.3
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM departments d
INNER JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name
HAVING AVG(e.salary) > 50000;

-- Answers on questions:
-- 1. INNER JOIN return only those rows, which matches on some condition. LEFT JOIN return all rows from left table and only those rows from right table which matches with left table on specific condition
-- 2. For example: you have an online shop of phone. Phones have different colors on choose. And you need to look at all possible variants of phones and their colors. It is useful because usually phones with different colors have different price
-- 3. ON return all table in specific table and then adds rows from other table on some condition. WHERE filters all rows after ON. In INNER JOIN there is no difference what to filter after ON because it will return only specific rows which matches in two table. In OUTER JOINS it will filter rows by specific condition
-- 4. 5 * 10 = 50. 50 rows
-- 5. NATURAL JOIN compare columns from 2 tables and if some columns have same name it uses them to JOIN
-- 6. It possible that there is no columns with the same name, so it will return random cross join, also it is possible that some random columns have same names, so it will return wrong table
-- 7. SELECT * FROM B RIGHT JOIN A ON B.id = A.id
-- 8. When you need to compare two tables