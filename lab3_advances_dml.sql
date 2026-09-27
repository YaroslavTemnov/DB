CREATE DATABASE advanced_lab;
CREATE TABLE employees(
    emp_id SERIAL PRIMARY KEY,
    first_name varchar(20),
    last_name varchar(20),
    department varchar(30),
    salary int,
    hire_date date,
    status varchar(20) default 'active'
);

select * from employees;

CREATE TABLE departments(
    dept_id SERIAL PRIMARY KEY,
    dept_name varchar(30),
    budget int,
    manager_id int
);

select * from departments;

CREATE TABLE projects(
    project_id SERIAL PRIMARY KEY,
    project_name varchar(30),
    dept_id int,
    start_date date,
    end_date date,
    budget int
);

select * from projects;

INSERT INTO employees(emp_id, first_name, last_name, department)
VALUES (1, 'Linus', 'Torvalds', 'IT');

SELECT * FROM employees;

INSERT INTO employees
VALUES (2, 'Grigoriy', 'Dudar', 'IT', DEFAULT, '2020-02-03', DEFAULT);

SELECT * FROM employees;

INSERT INTO departments (dept_name, budget, manager_id)
VALUES ('IT', 1000000, 1),
        ('finance', 800000, 2),
        ('marketing', 1200000, 3);

SELECT * from departments;

INSERT INTO employees(emp_id, first_name, last_name, department, salary, hire_date)
VALUES (3,'Vitaliy', 'Cal', 'marketing', 50000 * 1.1, current_date);

SELECT * FROM employees;

CREATE TABLE temp_employees(LIKE employees);

SELECT * FROM temp_employees;

INSERT INTO temp_employees (SELECT * FROM employees WHERE department = 'IT');

SELECT * FROM temp_employees;

UPDATE employees SET salary = salary * 1.1 WHERE salary > 0;

SELECT * FROM employees;

INSERT INTO employees(emp_id, first_name, last_name, department, salary, hire_date)
VALUES (4,'Elon', 'Musk', 'IT', 100000, '2010-10-6'),
       (5,'Mark', 'Zuckerberg', 'IT', 65000, '2015-12-21');

UPDATE employees SET status = 'Senior' WHERE salary > 60000 AND hire_date < '2020-01-01';

UPDATE employees SET department =
CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary between 50000 and 80000 THEN 'Senior'
    ELSE 'Junior'
END
WHERE salary > 0;

SELECT * FROM employees;

UPDATE employees
SET department = DEFAULT
WHERE status = 'Inactive';

UPDATE employees SET salary = 50000 WHERE salary IS NULL;
INSERT INTO employees
VALUES (6, 'Jeffrey', 'Bezos','finance', 70000, '2020-01-01'),
       (7, 'Steve', 'Jobs', 'marketing', 90000, '2016-05-10');


UPDATE departments d
SET budget = (
    SELECT AVG(e.salary) * 1.2
    FROM employees e
    WHERE d.dept_name = e.department
    );

SELECT * FROM departments;

INSERT INTO employees
VALUES (8, 'Eugene', 'Krabs','Sales', 70000, '2020-01-01');

UPDATE employees
SET salary = salary *1.15,
status = 'Promoted'
WHERE department = 'Sales';

DELETE FROM employees WHERE status = 'Terminated';

DELETE FROM employees
       WHERE salary < 40000
         AND hire_date > '2023-01-01'
         AND department IS NULL;

DELETE FROM departments
       WHERE dept_name NOT IN (SELECT DISTINCT department
                             FROM employees
                             WHERE department IS NOT NULL);

DELETE FROM projects WHERE end_date < '2023-01-01' RETURNING end_date;

INSERT INTO employees
VALUES (9, 'Ilya', 'Son', NULL, NULL, '2023-03-03');

UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;

DELETE FROM employees
WHERE salary IS NULL or department IS NULL;

select * from employees;

INSERT INTO employees
VALUES (10, 'Timur', 'Kim', 'IT', 95000, '2026-09-01')
RETURNING (emp_id, concat(first_name, last_name));

UPDATE employees
SET salary = salary + 5000
WHERE department = 'IT'
RETURNING(employees.emp_id, salary - 5000, salary);

DELETE FROM employees
       WHERE hire_date < '2020-01-01' RETURNING *;

INSERT INTO employees
SELECT 8, 'Timur', 'Kim', 'finance', 28000, '2021-05-01'
WHERE NOT EXISTS(
    SELECT 1
    FROM employees
    WHERE first_name = 'Timur' AND last_name = 'Kim'
);

UPDATE employees SET salary =
    CASE
        WHEN budget > 100000 THEN salary * 1.1
        ELSE salary *1.05
    END
FROM departments
WHERE department = dept_name;

INSERT INTO employees
VALUES ('14', 'Alisher', 'Kamzin','marketing', 30000, '2021-08-07'),
       ('15', 'Dilshat', 'Rashit','marketing', 40000, '2021-08-07'),
       ('16', 'Alibek', 'Maisabek','IT', 75000, '2021-08-07'),
       ('17', 'Gleb', 'Solomykin','Sales', 52000, '2021-08-07'),
       ('18', 'Mukail', 'Nadirov','Management', 20000, '2021-08-07');

UPDATE employees
SET salary = salary * 1.10
WHERE hire_date = '2021-08-07';

CREATE TABLE employee_archive (LIKE employees);

INSERT INTO employee_archive
SELECT * FROM employees
WHERE status = 'Inactive';

DELETE FROM employees
WHERE status = 'Inactive';

UPDATE projects p
SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000
  AND dept_id IN (
      SELECT dept_id
      FROM departments
      WHERE dept_name IN(
      SELECT department
      FROM employees
      GROUP BY department
      HAVING COUNT(*) > 3)
  );

SELECT * FROM projects;