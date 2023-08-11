USE employees;

SELECT 
    *
FROM
    employees;

/*How many annual contracts with a value higher than or equal to $100,000 have been registered in 
the salaries table? */
SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    salary >= '100000';

# How many managers do we have in the “employees” database?
SELECT 
    COUNT(DISTINCT emp_no)
FROM
    dept_manager;

# Which employees have average salary higher than $120,000 per annum.
SELECT 
    emp_no, AVG(salary)
FROM
    salaries
GROUP BY emp_no
HAVING AVG(salary) > '120000'
ORDER BY AVG(salary) ASC;

# Which employee numbers of all individuals have signed more than 1 contract after the 1st of January 2000.
SELECT 
    emp_no, COUNT(emp_no) AS number_of_contracts
FROM
    dept_emp
WHERE
    from_Date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(emp_no) > 1
ORDER BY emp_no ASC;

# Inserting a new record in the employees table
INSERT INTO employees
VALUES
(
    999903,
    '1977-09-14',
    'Johnathan',
    'Creek',
    'M',
    '1999-01-01'
);
/* Insert information about employee number 999903 in the titles table. Stating that he/she is 
a “Senior Engineer”, who has started working in this position on October 1st, 1997. */
INSERT INTO titles (emp_no,title,from_date) VALUES (999903, 'Senior Engineer', '1997-10-01');

/* Inserting information about the individual with employee number 999903 into the “dept_emp” table. 
 He/She is working for department number 5, and has started work on  October 1st, 1997; her/his 
 contract is for an indefinite period of time.  */
SELECT * FROM employees.dept_emp limit 10 ; 
INSERT INTO dept_emp VALUES (999903, 'd005', '1997-10-01','9999-01-01');
SELECT * FROM employees.dept_emp ORDER BY emp_no DESC limit 10; 

# Creating a duplicate table
CREATE TABLE departments_dup
(
	dept_no CHAR(4) NOT NULL,
    dept_name VARCHAR(40) NOT  NULL
);
INSERT INTO departments_dup (dept_no, dept_name) SELECT * FROM departments;

# How many departments are there in the “employees” database?
SELECT COUNT(DISTINCT dept_no) from dept_emp;

# What is the total amount of money spent on salaries for all contracts starting after the 1st of January 1997?
SELECT 
    *
FROM
    employees.salaries;
SELECT 
    SUM(salary) AS total_salary
FROM
    salaries
WHERE
    from_date > '1997-01-01';

# Which is the lowest employee number in the database?
SELECT MIN(emp_no) FROM employees.employees;

# Which is the highest employee number in the database?
SELECT MAX(emp_no) FROM employees.employees;

# What is the average annual salary paid to employees who started after the 1st of January 1997?
/* Rounding the average amount of money spent on salaries to a precision of cents.  */
SELECT 
    ROUND(AVG(salary), 2) as avg_salary
FROM
    salaries
WHERE
    from_Date > '1997-01-01';

# Modifying the table specifications
ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name VARCHAR(40) NULL;
# inserting records
INSERT INTO departments_dup (dept_no) VALUES ('d010'), ('d011');
SELECT * from departments_dup ORDER BY dept_no ASC;
# adding a new column
ALTER TABLE departments_dup
ADD COLUMN dept_manager VARCHAR(255) NULL AFTER dept_name;

/* using COALESCE in the ‘dept_manager’ column such that if ‘dept_manager’ does not have a 
 value, using ‘dept_name’ as an alternative and if ‘dept_name’ is missing the using 'N/A' instead*/
SELECT 
    dept_no,
    dept_name,
    COALESCE(dept_manager, dept_name, 'N/A') AS dept_manager
FROM
    departments_dup
ORDER BY dept_no DESC;
SELECT * FROM departments_dup;

/* add a third column to the departments duplicate table */
ALTER TABLE departments_dup
ADD COLUMN dept_info VARCHAR(255) NULL AFTER dept_name;

/* using COALESCE in the ‘dept_info’ column such that if ‘dept_no’ does not have a 
 value, using ‘dept_name’ as an alternative  */
SELECT 
    dept_no,
    dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no ASC;

/* Modifying the code above and applying the IFNULL() function to the values from  the first and second column, 
 so that ‘N/A’ is displayed whenever a department number has no value, and ‘Department name not provided’
 is shown if there is no value for ‘dept_name’.  */
SELECT 
    IFNULL(dept_no,'N/A') as dept_no,
    IFNULL(dept_name,'Department name not provided') as dept_name,
    COALESCE(dept_no, dept_name) AS dept_info
FROM
    departments_dup
ORDER BY dept_no ASC;

# SQL JOINS
/* Removing the ‘dept_manager’ column from the ‘departments_dup’ table.  */
ALTER TABLE departments_dup
DROP COLUMN dept_manager;

# Modifying the ‘dept_no’ and ‘dept_name’ columns to NULL.
ALTER TABLE departments_dup
CHANGE COLUMN dept_no dept_no char(4) NULL;
ALTER TABLE departments_dup
CHANGE COLUMN dept_name dept_name char(40) NULL;

# Inserting a new record whose department name is “Public Relations”.
insert into departments_dup(dept_name) VALUES ("Public Relations");

# Deleting the records related to department number two.
DELETE FROM departments_dup WHERE dept_no='d002';

/* Inserting two new records in the “departments_dup” table with values in the “dept_no” column as
 “d010” and “d011”.*/
 INSERT INTO departments_dup(dept_no) VALUES ('d010'), ('d011');

# Creating and filling in the ‘dept_manager_dup’ table, using the following code
DROP TABLE IF EXISTS dept_manager_dup;
CREATE TABLE dept_manager_dup (
  emp_no int(11) NOT NULL,
  dept_no char(4) NULL,
  from_date date NOT NULL,
  to_date date NULL
  );
INSERT INTO dept_manager_dup
select * from dept_manager;

INSERT INTO dept_manager_dup (emp_no, from_date)
VALUES (999904, '2017-01-01'),(999905, '2017-01-01'),(999906, '2017-01-01'),(999907, '2017-01-01');

DELETE FROM dept_manager_dup
WHERE dept_no = 'd001';

/* Extracting a list containing information about all managers’ employee number, first and last name, 
 department number, and hire date.  */
SELECT 
    m.emp_no, m.dept_no, e.first_name, e.last_name, e.hire_date
FROM
    dept_manager m
        JOIN
    employees e ON m.emp_no = e.emp_no
ORDER BY emp_no;

#Important – Prevent Error Code: 1055!
set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');

/* Selecting the first and last name, the hire date, and the job title of all employees whose first name 
 is “Margareta” and have the last name “Markovitch”.  */
SELECT 
    e.emp_no, 
    e.first_name, 
    e.last_name, 
    e.hire_date, 
    t.title
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    e.first_name = 'Margareta'
        AND e.last_name = 'Markovitch';

# SQL CROSS JOIN
/* Extracting a list with the first 10 employees with all the departments they can be assigned to */
SELECT 
    e.*,
    d.*
FROM
    employees e
        CROSS JOIN
    departments d
WHERE
    e.emp_no < 10011
ORDER BY e.emp_no , d.dept_name;

# Extracting a list of all managers’ first and last name, hire date, job title, start date, and department name.
SELECT 
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    t.from_Date,
    d.dept_name
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
        JOIN
    dept_manager dm ON dm.emp_no = t.emp_no
        JOIN
    departments d ON d.dept_no = dm.dept_no
WHERE
    t.title = 'Manager';

# How many male and how many female managers do we have in the ‘employees’ database?
SELECT 
    e.gender, 
    COUNT(e.gender) AS quantity
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no
GROUP BY e.gender;

# SQL SUBQUERIES
/* SQL Subqueries with IN nested inside WHERE
 Extracting the information about all department managers who were hired between the
  1st of January 1990 and the 1st of January 1995.  */
SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees e
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');

/* Extracting a list the entire information for all employees whose job title is “Assistant Engineer” */
SELECT 
    *
FROM
    employees e
WHERE
    emp_no IN ( SELECT 
            emp_no
        FROM
            titles t
        WHERE
            title = 'Assistant Engineer')
;

/* Assigning employee number 110022 as a manager to all employees from 10001 to 10020
 and
 employee number 11039 as a amanager to all employees from 10021 to 10040.  */
SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;

/* Creating a table called “emp_manager”  */
DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);

/* Filling emp_manager with data about employees, the number of the department they are working in, 
and their managers. */
INSERT INTO emp_manager
SELECT 
    u.*
FROM
    (SELECT 
        a.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS a 
    UNION 
    SELECT 
        b.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS b 
    UNION 
    SELECT 
        c.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no) AS c 
    UNION 
    SELECT 
        d.*
    FROM
        (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no) AS d) as u;
select * from emp_manager;

# Extracting records only of those employees who are managers as well from the emp_manager table
SELECT * FROM employees.emp_manager;
SELECT 
    e1.*
FROM
    emp_manager e1
        JOIN
    emp_manager e2 ON e1.emp_no = e2.manager_no
WHERE
    e2.emp_no IN (SELECT 
            manager_no
        FROM
            emp_manager)
;

# SQL VIEWS
/* Visializing only the period encompassing the last contract of each employee */
CREATE OR REPLACE VIEW v_dept_emp_latest_date AS
    SELECT 
        emp_no,
        dept_no,
        MAX(from_date) AS from_date,
        MAX(to_date) AS to_date
    FROM
        dept_emp
    GROUP BY emp_no;
SELECT * FROM employees.v_dept_emp_latest_date;

/* Create a view that will extract the average salary of all managers registered in the database.
 Round this value to the nearest cent. */
CREATE OR REPLACE VIEW v_avg_salary_managers AS
    SELECT 
        ROUND(AVG(s.salary), 2) AS avg_salary
    FROM
        salaries s
            JOIN
        dept_manager dm ON s.emp_no = dm.emp_no;

# SQL STORED ROUTINES
# Creating a procedure that will provide the average salary of all employees. 
delimiter $$
CREATE PROCEDURE select_average_salary()
BEGIN
	SELECT 
		AVG(salary) AS avg_salary 
	FROM salaries;
END$$
delimiter ;
# Calling the procedure
CALL employees.select_average_salary();

# Stored procedure with two inputs and one output parameter
/* Creating a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual,
 and returns their employee number.  */
DROP PROCEDURE IF EXISTS emp_info;
delimiter $$
CREATE PROCEDURE emp_info(IN p_first varchar(255), IN p_last varchar(255), OUT p_emp_no int)
BEGIN
	SELECT 
		e.emp_no
    INTO p_emp_no
    FROM
		employees e
	WHERE
		e.first_name = p_first AND e.last_name = p_last;
END$$
delimiter ;

# Session variables
/* Creating a variable - ‘v_emp_no’, where we store the output of the procedure we created above.*/
SET @v_emp_no = 0;
/* Calling the same procedure, and using the values ‘Aruna’ and ‘Journel’ as a first and last name respectively.*/
CALL emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no; # Selecting the obtained output.

# MySQL: User-defined function
/* Creating a function called ‘emp_info’ that takes for parameters the first and last name of an employee,
 and returns the salary from the newest contract of that employee.
 Note: Here I declare and use two variables – v_max_from_date that will be of the DATE type, 
 and v_salary, that will be of the DECIMAL (10,2) type. */
DROP FUNCTION IF EXISTS f_emp_info;
delimiter $$
CREATE FUNCTION f_emp_info(p_first varchar(255), p_last varchar(255)) returns DECIMAL (10,2)
DETERMINISTIC
BEGIN
DECLARE v_max_from_date date;
DECLARE v_salary DECIMAL (10,2);

	SELECT 
    MAX(from_date)
INTO v_max_from_date FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first
        AND e.last_name = p_last;

	SELECT 
    s.salary
INTO v_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first
        AND e.last_name = p_last
        AND s.from_date = v_max_from_date;
RETURN v_salary;
END$$
delimiter ;
SELECT f_emp_info('Aruna', 'Journel'); #Selecting this function

# MySQL Triggers
/* Creating a trigger that checks if the hire date of an employee is higher than the current date.
  If true, seting this date to be the current date. Formating the output in (YY-MM-DD).  */
DELIMITER $$
CREATE TRIGGER trig_hire_date  
BEFORE INSERT ON employees
FOR EACH ROW  
BEGIN  
	IF NEW.hire_date > date_format(sysdate(), '%Y-%m-%d') THEN     
		SET NEW.hire_date = date_format(sysdate(), '%Y-%m-%d');     
	END IF;  
END $$  
DELIMITER ;  

INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  
SELECT 
    *
FROM
    employees
WHERE emp_no = 999904
ORDER BY emp_no DESC;

/* Extracting a result set containing the employee number,
 first name, and last name of all employees with a number higher than 109990.
 Creating a fourth column in the query, indicating whether this employee is also a manager 
 or a regular employee, according to the data provided in the dept_manager table */
    SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON dm.emp_no = e.emp_no
WHERE
    e.emp_no > 109990
    ORDER BY e.emp_no;

/* Extracting a dataset containing the following information about the managers:
 employee number, first name, and last name. Adding two columns at the end
 – one showing the difference between the maximum and minimum salary of that employee, and 
 another one saying whether this salary raise was higher than $30,000 or NOT. */
SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    IF(MAX(s.salary) - MIN(s.salary) > 30000,
        'Salary was raised by more then $30,000',
        'Salary was NOT raised by more then $30,000') AS salary_increase
FROM
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;

/* Extracting the employee number, first name, and last name of the first 100 employees, and 
 adding a fourth column, called “current_employee” saying “Is still employed”
 if the employee is still working in the company, or “Not an employee anymore” if they aren’t. */
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'Not an employee anymore'
    END AS current_employee
FROM
    employees e
        JOIN
    dept_emp de ON de.emp_no = e.emp_no
GROUP BY de.emp_no
LIMIT 100;

# SQL WINDOW FUNCTION
/* Writing a query that assigns a row number to all managers we have information for in the
 "employees" database starting from the value of 1 (regardless of their department).
  The numbering disregards the department the managers have worked in.
  Assigning the value of 1 to the manager with the lowest employee number  */
SELECT 
    e.*,
    ROW_NUMBER () OVER (ORDER BY e.emp_no ASC) AS row_num
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no;
    
/* Extracting a result set containing the salary values each manager has signed a contract for.
 The output has been ordered by the values in the first of the row number columns, 
 and then by the salary values for each partition in ascending order.  */
SELECT
	dm.emp_no,
    salary,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary ASC) AS row_num1,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2   
FROM
	dept_manager dm
    JOIN 
    salaries s ON dm.emp_no = s.emp_no;

# What is the lowest salary value each employee has ever signed a contract for.
/* The output is obtained using a subquery containing a window function, as well as a window 
 specification introduced with the help of the WINDOW keyword. */
SELECT 
		a.emp_no,
       MIN(salary) AS min_salary FROM (
										SELECT
											emp_no, 
                                            salary, 
                                            ROW_NUMBER() OVER w AS row_num
										FROM
											salaries 
										WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
                                        ) a
GROUP BY emp_no;

/* What is the number of salary contracts that each manager has ever signed while working in the company. */
SELECT 
    dm.emp_no, 
    (COUNT(salary)) AS no_of_salary_contracts
FROM
    salaries s
        JOIN
    dept_manager dm ON s.emp_no = dm.emp_no
GROUP BY dm.emp_no
ORDER BY dm.emp_no;

/* Writing a query that ranks the salary values in descending order of all contracts signed by employees 
 numbered between 10500 and 10600 inclusive. Equal salary values for one and the same employee bear 
 the same rank allowing for gaps in the ranks obtained for their subsequent rows. */
SELECT
	e.emp_no,
	s.salary,
	rank () over (partition by e.emp_no order by s.salary desc) as rank_num
FROM
	employees e
JOIN
	salaries s ON e.emp_no = s.emp_no
WHERE
	e.emp_no >= 10500 AND e.emp_no <= 10600
;

/* Writing a query that ranks the salary values in descending order of the following contracts from the
 "employees" database:
- contracts that have been signed by employees numbered between 10500 and 10600 inclusive.
- contracts that have been signed at least 4 full-years after the date when the given employee was hired
 in the company for the first time.
 Equal salary values of a certain employee bear the same rank but not allowing for gaps in the 
 ranks obtained for their subsequent rows. */
SELECT
    e.emp_no,
    DENSE_RANK() OVER w as employee_salary_ranking,
    s.salary,
    e.hire_date,
    s.from_date,
    (YEAR(s.from_date) - YEAR(e.hire_date)) AS years_from_start
FROM
	employees e
JOIN
    salaries s ON s.emp_no = e.emp_no
    AND YEAR(s.from_date) - YEAR(e.hire_date) >= 5
WHERE 
	e.emp_no BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);

/* Extracting the following information from the "employees" database to salary values higher than $80,000:
 - the salary values (in ascending order) of the contracts signed by all employees numbered between
 10500 and 10600 inclusive
 - a column showing the previous salary from the given ordered list
 - a column showing the subsequent salary from the given ordered list
 - a column displaying the difference between the current salary of a certain employee and their previous 
 salary
 - a column displaying the difference between the next salary of a certain employee and their current salary
 The output is partitioned by employee number.  */
SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LEAD(salary) OVER w AS next_salary,
    salary - LAG(salary) OVER w AS diff_salary_current_previous,
	LEAD(salary) OVER w - salary AS diff_salary_next_current
FROM
	salaries
WHERE 
	salary > 80000 AND emp_no BETWEEN 10500 AND 10600
WINDOW w AS (PARTITION BY emp_no ORDER BY salary);

# The MySQL LAG() and LEAD() value window functions
/* Creating a query whose result set contains data arranged by the salary values associated 
 to each employee number (in ascending order). The output contains the following six columns:
- the employee number
- the salary value of an employee's contract (i.e. which we’ll consider as the employee's current salary)
- the employee's previous salary
- the employee's contract salary value preceding their previous salary
- the employee's next salary
- the employee's contract salary value subsequent to their next salary
 The output is restricted to the first 1000 records obtained obtain. */
SELECT
	emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
	LAG(salary, 2) OVER w AS 1_before_previous_salary,
	LEAD(salary) OVER w AS next_salary,
    LEAD(salary, 2) OVER w AS 1_after_next_salary
FROM
	salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
LIMIT 1000;

# Aggregate Functions in the Context of Window Functions
/* Extracting a result set containing the employee numbers, contract salary 
values, start, and end dates of the first ever contracts that each employee signed for the company. */
SELECT
    s1.emp_no, s.salary, s.from_date, s.to_date
FROM
    salaries s
        JOIN
    (SELECT
        emp_no, MIN(from_date) AS from_date
    FROM
        salaries
    GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE
    s.from_date = s1.from_date;

# SQL Common Table Expressions
/* How many male employees have never signed a contract with a salary value higher than or equal 
to the all-time company salary average? */
WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries
)
SELECT
	COUNT(CASE 
			WHEN s.salary < c.avg_salary THEN s.salary 
            ELSE NULL 
			END) AS no_salaries_below_avg_w_count,
	COUNT(s.salary) AS no_of_salary_contracts
FROM 
	salaries s 
JOIN employees e ON s.emp_no = e.emp_no 
	AND e.gender = 'M' 
JOIN cte c;

/* How many male employees have their highest salaries values below the all-time average.
 Result is obtained using two common table expressions and a SUM() function*/
WITH cte1 AS (
	SELECT 
		AVG(salary) AS avg_salary 
    FROM salaries
),
cte2 AS (
	SELECT 
		s.emp_no, 
        MAX(s.salary) AS max_salary
	FROM 
		salaries s
	JOIN employees e ON e.emp_no = s.emp_no 
		AND e.gender = 'M'
	GROUP BY s.emp_no
)
SELECT
	SUM(CASE 
			WHEN c2.max_salary < c1.avg_salary THEN 1 
            ELSE 0 
		END) AS highest_salaries_below_avg
FROM 
	employees e
JOIN 
	cte2 c2 ON c2.emp_no = e.emp_no
JOIN cte1 c1;