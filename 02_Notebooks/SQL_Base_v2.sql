
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
-- CREATE

CREATE DATABASE IF NOT EXISTS notebook_db;
USE notebook_db;

CREATE TABLE student(
    student_id INT PRIMARY KEY,
    name VARCHAR(20),
    major VARCHAR(20)
);

DESCRIBE student;