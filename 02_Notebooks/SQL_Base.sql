
-- NOTEBOOK

--  SQL DATATYPES:
-- INT -- Integer numbers
-- DECIMAL (M,N) -- Decimal numbers, M is the total quantity of digits for the number and N for total quantity of decimals
-- VARCHAR(M) -- String of text,  M stands for the maximum character
-- BLOB -- Binary Large Object, it's a structure that can storage a large amount of data
-- DATE -- Specific DATE in time
-- TIMESTAMP -- Similar to DATE but records when something happens in time

--  COMMANDS, the basic commands in SQL follow the CRUD summary: Create, Retrieve (or read), Update, Delete
-- Caps normally is used for commands and lowcaps is used for names/objects. General rule.

------------------------------------------------------------------------------------------------
# CREATE v1

CREATE DATABASE IF NOT EXISTS notebook_db;
USE notebook_db;

CREATE TABLE student(
    student_id INT PRIMARY KEY,
    name VARCHAR(20),
    major VARCHAR(20)
);
-- DESCRIBE TO SEE THE COMPOSITION AND DATATYPES OF THE TABLE
DESCRIBE student;
# DROP TO DROP THE TABLE AND ALTER TO ALTERATE THE TABLE. THEN, WE CAN ALTER BY DROPING A COLUMN
DROP TABLE student;
ALTER TABLE student ADD gpa DECIMAL(2, 2);
ALTER TABLE student DROP COLUMN gpa;

#-- INSERT
SELECT * FROM student;
INSERT INTO student VALUES(1, 'Jack', 'Biology');
INSERT INTO student VALUES (2, 'Kate', 'Sociology');
INSERT INTO student(student_id, name) VALUES (3, 'Claire');
INSERT INTO student VALUES (4, 'Jack', 'Biology');
INSERT INTO student VALUES (5, 'Mike', 'Computer Science');

UPDATE student SET name='Claire' WHERE student_id=3;

-------------------------------------------------------------------------------------
# CREATE v2
# we can add specifications to the columns we are creating. For example NOT NULL, UNIQUE
# DROP is for Tables. DELETE is for rows. UPDATE to change all rows with a certain criteria
# Automations on the table like AUTO_INCREMENT

DROP TAblE studentv2;

CREATE TABLE studentV2(
    studentv2_id INT AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    major VARCHAR(20) DEFAULT 'Unkown',
    PRIMARY KEY (studentv2_id)
);

SELECT * FROM studentv2;
DELETE FROM studentv2 WHERE studentv2.studentv2_id=2;

INSERT INTO studentV2(name, major) VALUES ('Jack', 'Biology');
INSERT INTO studentv2(name, major) VALUES('Kate', 'Sociology');
INSERT INTO studentV2(name, major) VALUES ('Claire', 'Chemistry');
INSERT INTO studentv2(name, major) VALUES('Jack', 'Biology');
INSERT INTO studentv2(name, major) VALUES('Mike', 'Computer');

UPDATE studentv2 SET major='Bio' WHERE major='Biology';
UPDATE studentv2 SET major='Computer Science' where studentv2_id=4;
UPDATE studentv2 SET major = 'Biochemistry' where major='Bio' OR major='Chemistry';

DELETE FROM studentv2 WHERE major='Biochemistry' AND name='Claire';

------------------------------------------------------------------------------
# BASIC QUERIES
# We can use SQL to specify which conditions our query will meet.
# SELECT means we wanna get something from it.  * means all columns, if not all we should select the column.
# The column can be written as <table name>.column
# ORDER BY to order, LIMIT to limit the quantity of rows.
SELECT * FROM studentv2;
SELECT name FROM studentv2;
SELECT name, major FROM studentv2
ORDER BY name DESC;
# we can use more columns to order by.
SELECT * FROM studentv2
ORDER BY name DESC, studentv2_id DESC
LIMIT 2;
# WHERE can be used with =, <=, >=, <, >, <> (not equal), AND, OR
SELECT * FROM studentv2 WHERE studentv2_id>2 AND major <> 'Computer';
SELECT name, major FROM studentv2 WHERE major <> 'Chemistry';
# IN for if it is or if it belongs to
SELECT * FROM studentv2 WHERE major IN ('Computer', 'Biochemistry') AND studentv2_id > 1;

----------------------------------------------------------------------------------------
# More Complex Databases.
DROP TABLE studentv2, student;
CREATE TABLE employee(
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(40),
    last_name VARCHAR(40),
    birth_date DATE,
    sex VARCHAR(1),
    salary INT,
    super_id INT,
    branch_id INT
);
CREATE TABLE branch(
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(40),
    mgr_id INT,
    mgr_start_date DATE,
    FOREIGN KEY (mgr_id) REFERENCES employee(emp_id)
        ON DELETE SET NULL
);
# We couldn't set foreign keys in table employee because table Branch was still not created. Therefore, we'll alterate (modify) it now
ALTER TABLE employee ADD FOREIGN KEY(branch_id) REFERENCES branch (branch_id) ON DELETE SET NULL;
ALTER TABLE employee ADD FOREIGN KEY(super_id) REFERENCES employee(emp_id) ON DELETE SET NULL;

SELECT * FROM branch;
# ON DELETE:
# -- SET NULL - if deleted becomes null
# -- CASCADE - if deleted it'll delete all data hierarchically bellow it
# -- RESTRICT / NO ACTION - It's not possible to delete the superior hierarchy before deleting the inferiors
# -- SET DEFAULT - If the superior hierarchy is deleted, the inferior is assigned to a default one

CREATE TABLE client(
    client_id INT PRIMARY KEY,
    client_name VARCHAR(40),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES branch (branch_id)
        ON DELETE SET NULL
);

CREATE TABLE works_with(
    emp_id INT,
    client_id INT,
    total_sales INT,
    PRIMARY KEY (emp_id, client_id),
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES client (client_id) ON DELETE CASCADE
);

CREATE TABLE branch_supplier(
    branch_id INT,
    supplier_name VARCHAR(40),
    supply_type varchar(40),
    PRIMARY KEY (branch_id, supplier_name),
    FOREIGN KEY (branch_id) REFERENCES employee (branch_id) ON DELETE CASCADE
);

-- -----------------------------------------------------------------------------

-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Lables', 'Custom Forms');

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

---------------------------------------------------------
# Basic Queries
# Order, filter certain columns, rename temporarily the columns, DISTINCT selects the unique values stored in a column
SELECT * FROM employee ORDER BY sex, salary DESC;
SELECT employee.first_name AS forename, employee.last_name AS surname FROM employee ORDER BY last_name;
SELECT DISTINCT branch_name FROM branch;

-----------------------------------
# Functions
# Code that we can call. COUNT(), AVG(), SUM()

-- Find the number of employees with COUNT()
SELECT COUNT(emp_id) FROM employee;
-- Find the number of female employees born after 1970
SELECT COUNT(employee.emp_id) AS 'Females born after 1970' FROM employee
WHERE sex='F' AND birth_date >= 1970-01-01;
-- Find the av. salary of male employees
SELECT AVG(salary) FROM employee
WHERE sex='M';
-- Find the total salary of male employees
SELECT SUM(salary) FROM employee
WHERE sex='M';
-- Find the total sale by client
SELECT SUM(total_sales), client_id FROM works_with
GROUP BY client_id
ORDER BY SUM(total_sales) DESC;

#  WILDCARDS: special characters used with LIKE operator to search for patterns within string
#               rather than looking for the exact match.
#               % = ANY NUMBER OF CHARACTERS | _ = ONE CHARACTER
#     -- % symbol looks for zero, one or multiple characters after the A. Which means, the words starting by A
#     LIKE 'A%' = AI, Alice, Alexander
#     LIKE 'h%t' = any word that starts by h and fininshes in t
      -- _ symbol. Represents a missing character. so LIKE 'h_t' could be hot, hat, hit but never heat.
#           heat would be LIKE 'H__T'

-- Find any clients who are in LLC
SELECT * FROM client
WHERE client_name LIKE '%LLC%';
-- Find any employees born in October
SELECT * FROM employee
WHERE birth_date LIKE '%10%';
-- Find any clients who are schools
SELECT * FROM client
WHERE client_name LIKE '%school%';

---------------------------
# UNIONS
# An Union adds (or merges) to the columns another columns from a different data.
# -- 1. equal number of columns in both subqueries.
# -- 2. equal Data type
SELECT first_name as 'Company names' FROM employee
UNION
SELECT branch_name FROM branch;

SELECT client_name, client.branch_id FROM client
UNION
SELECT branch_supplier.supplier_name, branch_supplier.branch_id FROM branch_supplier;

----------------------------------------
# JOINS
# Combinates rows from different tables with a reference column.
# INNER JOIN is the DEFAULT JOIN
# LEFT JOIN joins ALL rows from the left table (FROM table) and only the shared from the right table
# RIGHT JOIN join shared rows from the left and ALL form the right

INSERT INTO branch VALUES (4, 'Bufalo', NULL, NULL);
-- Find all branches and the names of their managers
SELECT branch.branch_name, employee.first_name
FROM employee
JOIN branch ON employee.emp_id = branch.mgr_id;

# This worked because when creating the tables, we had a primary key emp_id from employee, and we did:
# INNER JOIN is the DEFAULT JOIN
# CREATE TABLE branch(
#     branch_id INT,
#     branch_name VARCHAR(40),
#     mgr_id INT,
#     mgr_start_date DATE,
#     PRIMARY KEY (branch_id),
#     FOREIGN KEY (mgr_id) REFERENCES employee(emp_id) ON DELETE SET NULL
# );

---------------------
# Nested Queries
# it get a query within a query, in this case using an IN
SELECT employee.first_name, employee.last_name FROM employee
WHERE emp_id IN (SELECT works_with.emp_id FROM works_with
WHERE total_sales > 30000);
UPDATE branch SET mgr_id = 102 WHERE branch_id = 4;
SELECT * from branch;
SELECT client.client_name FROM client
WHERE client.branch_id = (
    SELECT employee.branch_id
    FROM employee
    WHERE employee.emp_id = 102
    );
# When we are using = instead of IN it's because we are looking for a
# specific value. If it could happen the case that this would be leading to
# multiple values, we can LIMIT to 1, so in this case if Michael Scott
# is manager of 2 branches, weshould LIMIT(1) in case of aiming for 1 result
----------------------
# ON DELETE

-----------------------
# Triggers
# Code that trigers when something happens
# Open mysql command line
DELIMITER $$ -- Changes the delimiter type (from ; to $$)
CREATE TRIGGER mu_trigger BEFORE/AFTER INSERT/UPDATE/DELETE -- Before inserting a new employee it'll trigger
# ON employee. Can be used with after of before the action of update/insert/delete
FOR EACH ROW BEGIN INSERT INTO trigger_test VALUES ('added new employee')
END $$
DELIMITER $$

# A more complex example, using if, elseif and else
DELIMITER $$
CREATE
Trigger my_trigger BEFORE/AFTER INSERT/UPDATE/DELETE
ON employee
FOR EACH ROW BEGIN
    IF New.sex = 'M' THEN
        INSERT INTO trigger_test VALUES('added male employee');
    ELSEIF NEW.sex = 'F' THEN
        INSERT INTO trigger_test VALUES('added female');
    ELSE
        INSERT INTO trigger_test VALUES ('added other employee')
    END IF;
END $$
DELIMITER ;

DROP TRIGGER my_trigger -- on command mysql

-- DATA AGGREGATION
-- Aggregates Data by functions (using funcstions AVG, SUM, COUNT) or by filtering through another column.
SELECT DISTINCT
-- ORDER
SELECT col1,
       col2 as agg_col2
FROM TABLE
GROUP BY DECISION
ORDER BY DECISION for primary col1, decision for seocndary col

-- DATA TRANSFORMATION
-- Generates new columns using or combining existing ones.
SELECT *, -- thsi includes ad_spend_usd
       ad_spend_usd * 0.92 AS ad_spend_eur -- HEre's the new column. We are calling the old one and modifying it.
FROM campaign_spend;

SELECT *, -- thsi includes exisitng column
       100 * paid_orders / NULLIF(paid_sessions, 0) AS pcvr, -- HEre's the new column. We are calling the old one and modifying it.
       ad_spend / NULLIF(paid_orders, 0)            AS cpo -- NULLIF pais_order are equal to 0. Otherwise we get an error.
        SAFE_DIVIDE(ad_spend, paid_orders)            AS cpo -- BIG QUERY Specific for divisions and null values
FROM campaign_performance
ORDER BY campaign_day;

-- -- Common Table Expression (CTE) or WITH expression. As SQL runs a SELECT statement all at the same time, if we have expressions
-- -- that are used in multiple places, we can use CTEs to avoid repeating the same code.

WITH campaign_performance_extended AS (
    SELECT *,
           revenue - ad_spend - (paid_orders * avg_fulfillment_cost) AS ad_contribution
    FROM campaign_performance
) -- this CTE is called campaign_performance_extended and generates a column called ad_contribution. This column can be used further.
SELECT *,
       SAFE_DIVIDE(100 * ad_contribution, revenue) AS contribution_rate
FROM campaign_performance_extended;
# WITH Clause for Multi-Step Calculations
#
# SQL cannot reference a column alias in the same SELECT where it's defined
# Use the WITH clause to break complex transformations into named steps
# Each step can reference columns created in previous steps
WITH step_1 AS (
    SELECT *,
           (col_a * col_b) - col_c AS intermediate
    FROM table_name
)
SELECT *,
       SAFE_DIVIDE(100 * intermediate, col_a * col_b) AS ratio
FROM step_1;

# Or double nested
WITH step_1 AS (
    SELECT *,
           (col_a * col_b) - col_c AS output_1
    FROM table_name
), step_2 AS (
    SELECT *,
           col_transformation AS output_2
    FROM step_1
)
SELECT *,
       SAFE_DIVIDE(100 * output_2, existing_col) AS output_3
FROM step_2;

# Scalar Subqueries for Aggregate Values
#
# Aggregate functions like SUM() collapse rows, so they can't be used directly in row-level calculations
# A scalar subquery calculates the aggregate separately and returns a single value that each row can use
SELECT *,
       col_a - (SELECT AGG_FUNC(col_a) FROM table_name) AS result
FROM table_name;

# FILTERING
# Select Data you need instead of all.
# SQL creates behind the scenes a bolean column with false and True, selects the True, and presents only them without the bolean column
# BEFORE FILTERING, always try to see the unique or DISTINCT values that exist, because if not we may be induced into biased filterings.
    WHERE column =, >, >=, <=, <, != value or parametre
#     or
    WHERE col LIKE %example% or using '_'
    WHERE col IS (NOT) NULL;
    WHERE col condition1 AND / OR condition2
    WHERE sector IN ('Technology', 'Automotive', 'Energy', 'Financials'); -- Instead of typing OR thousands of times
    WHERE is_founder_ceo = TRUE
    AND (sector = 'Technology'
    OR sector = 'Automotive'); -- Parenthesis are used to group conditions. You need to wrap some conditions in order to get some results.
    -- because AND is calculated by SQL before OR, therefore it may mislead.
    SELECT company,
       rank_2025,
       rank_2024,
       sector,
       profit,
       rank_2025 <= 10       AS is_top10,
       profit > 0            AS is_profitable,
       rank_2025 < rank_2024 AS is_rank_improved
FROM fortune_50; -- We are making new bolean columns, only with True and False, but if we want to filter it, we'll get an error
-- because the columns dont exist when filtering. SQL calculate FROM, then WHEN, then SELECT. So, to use this columns as filters also, we need to use CTE.

    WITH fortune_50_2 AS (SELECT company,
       rank_2025,
       sector,
       state,
       employees,
  sector IN ('Technology', 'Retail') AS is_tech_retail,
  state IN ('WA', 'CA') AS is_WA_CA,
  employees > 10000 AS employees_10k,
  rank_2025<=25 AS rank_25
FROM fortune_50)
  SELECT * FROM fortune_50_2
  WHERE is_tech_retail AND is_WA_CA AND rank_25 AND employees_10k;

# Rounding is actually one example of a much broader family: transformation functions — ready-made operations that perform common data transformations.
#
# The ecosystem is rich:
#
# Text: functions to clean, split, or reformat strings
# Dates: functions to extract day/month/year, calculate differences, or shift dates
# Math: rounding, absolute value, logarithms, and more

# CONDITIONAL QUERIES
# CASE to open
# WHEN ... THEN ... for each condition
# ELSE for the default
# END to close

# THE ORDER SQL PROCESSES COMMANDS:
As you can see here, the actual order is:

FROM — load the table
WHERE — filter rows
GROUP BY — form groups and compute aggregates
HAVING - filter groups and not rows like WHERE would do. Executes after the main operators SELECT and GROUP BY
SELECT — compute output columns
ORDER BY
LIMIT — sort and trim

# On writing queries in execution order: Technically, SQL requires you to write clauses in the conventional order
# (SELECT first, then FROM, WHERE, etc.). The language was designed this way intentionally — SELECT up front reads
# naturally as "give me these columns from this table where...". So while the execution order differs from the
# writing order, you can't rewrite queries to match execution order — the parser won't accept it.
#
# On WITH (CTEs): You're exactly right. WITH runs before everything else — it defines named result sets that the main
# query can then reference. And yes, each CTE itself follows the same execution order internally
# — FROM → WHERE → GROUP BY → SELECT, etc. Then the outer query runs against those CTE results from FROM onwards.

# RECURSIVE SQL
# A CTE, Common Table Expression, specifies a temporary named result set. It is defined within the execution of a single statement.
WITH CTE_Table (modified names of the queried columns) as ( - query - )
SELECT query FROM CTE_Table

# RECURSION, is the use of a procedure,subroutine, function or algorithm that calls itself one or more times until a specified
# condition is met.
# Something important about it is that we need a termination condition, to avoid it to het infinit.
# Solves problems ina recursive way, easy to read and follow, recursion could be limited by the termination condition
# Slow execution time
WITH calculate_factorial AS (          -- [A] The Name
    SELECT                             -- [B] The Anchor Member (The Foundation)
        1 AS step,                     -- Every recursive query must have a starting point.This part runs only once at the very beginning.In your factorial example, you are saying: "Start at step 1, and the value of $1!$ is 1."
        1 AS factorial

    UNION ALL                          -- [C] The Glue

    SELECT                             -- [D] The Recursive Member (The Engine)
        step + 1,
        factorial * (step + 1)
    FROM calculate_factorial           -- [E] Self-Reference
    WHERE step < 6                     -- [F] The Termination Condition
)

# Or, once again, Anchor or initiation statement + adding expression + recursive statement
-- Define the CTE
WITH counting_numbers AS (
	SELECT
  		-- Initialize number
  		1 AS number
  	UNION ALL
  	SELECT
  		-- Increment number by 1
  		number + 1 AS number
  	FROM counting_numbers
	-- Set the termination condition
  	WHERE number < 50)

SELECT number
FROM counting_numbers;

# Or making potencies of sequencial numbers until 10
WITH calculate_potencies (step, result) AS (
#     we do the anchor or initiation step
    1,
    1
    UNION ALL
    step + 1,
    result + POWER(step+1, step+1)
    FROM calculate_potencies
    WHERE step < 10
)
SELECT steps, result FROM calculate_potencies

# Window Functions
# Performs an operation across a set of rows that are somehow related to the current row.
# Similar to Group BY aggregate functions, but all rows in the output.
# Fetching values from preceeding or following rows.
# Assigning ordinal ranks to rows based on their values' positions in a sorted list
# running totals, moving averages.
# The Skeleton is
FUNCTION_NAME() OVER() -- OVER() indicated it is a window function
Functions = ROW_NUMBER(), LAG()
OVER() = ORDER BY, PARTITION BY, ROWS/RANGE PRECEDING/FOLLOWING/ UNBOUNDED -- can go inside the OVER() function
PARTITION BY applies the function to each subset determined by partitioning the data.
ORDER BY is used in over() to tell the order in which the ufnction will be applied. E.g: row_number() will start counting in the first row affected by order by.

Fetching: Relative -> LAG(column name, n) LEAD(column name, n) returns column's value at the row n before for lag and after for lead from the current row
          Absolute -> FIRST_VALUE(column name) LAST_VALUE(column name) returns the first or last value of the column in the group
Ranking: ROW_NUMBER(), DENSE_RANK(), RANK()
Running totals: SUM(), AVG(), COUNT(), MIN(), MAX()
Moving averages: AVG() OVER(PARTITION BY column_name ORDER BY column_name ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)                                                                                                      '