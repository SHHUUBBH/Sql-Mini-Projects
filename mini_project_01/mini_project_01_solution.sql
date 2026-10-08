-- MINI PROJECT 01: SQL Foundations & Database Operations
-- 1. DATABASE CREATION

DROP DATABASE IF EXISTS company_operations;
CREATE DATABASE company_operations;
USE company_operations;

-- 2. TABLE CREATION
-- Parent table: departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL
);

-- Child table: employees
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    hire_date DATE NOT NULL,
    job_title VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL CHECK (salary > 0),
    department_id INT,
    status VARCHAR(20) DEFAULT 'Active',
    CONSTRAINT fk_dept FOREIGN KEY (department_id) REFERENCES departments (department_id) ON DELETE SET NULL
);

-- 3. INSERT RECORDS
-- Insert departments
INSERT INTO
    departments (department_name, location)
VALUES ('Engineering', 'New York'),
    ('Marketing', 'San Francisco'),
    ('Sales', 'Chicago'),
    ('Human Resources', 'Austin'),
    ('Finance', 'New York');

-- Insert employees
INSERT INTO
    employees (
        first_name,
        last_name,
        email,
        hire_date,
        job_title,
        salary,
        department_id,
        status
    )
VALUES (
        'Alexander',
        'Pierce',
        'a.pierce@company.com',
        '2020-03-15',
        'Lead Engineer',
        125000.00,
        1,
        'Active'
    ),
    (
        'Brianna',
        'Chen',
        'b.chen@company.com',
        '2021-06-01',
        'Software Engineer',
        95000.00,
        1,
        'Active'
    ),
    (
        'Carlos',
        'Mendoza',
        'c.mendoza@company.com',
        '2019-11-20',
        'Marketing Lead',
        88000.00,
        2,
        'Active'
    ),
    (
        'Danielle',
        'Brooks',
        'd.brooks@company.com',
        '2022-01-10',
        'Sales Manager',
        105000.00,
        3,
        'Active'
    ),
    (
        'Ethan',
        'Taylor',
        'e.taylor@company.com',
        '2023-04-18',
        'Sales Rep',
        52000.00,
        3,
        'Active'
    ),
    (
        'Fiona',
        'Gallagher',
        'f.gallagher@company.com',
        '2018-08-25',
        'HR Specialist',
        62000.00,
        4,
        'Active'
    ),
    (
        'George',
        'Clark',
        'g.clark@company.com',
        '2022-09-05',
        'Financial Analyst',
        78000.00,
        5,
        'Active'
    ),
    (
        'Hannah',
        'Abbott',
        'h.abbott@company.com',
        '2023-11-12',
        'Intern',
        32000.00,
        1,
        'Inactive'
    ),
    (
        'Ian',
        'Wright',
        'i.wright@company.com',
        '2024-02-01',
        'Junior Analyst',
        48000.00,
        5,
        'Active'
    );

-- Verify inserted data
SELECT * FROM departments;

SELECT * FROM employees;

-- 4. MODIFY TABLE STRUCTURES (ALTER TABLE)
-- Add contact phone number and performance score columns
ALTER TABLE employees
ADD COLUMN phone_number VARCHAR(20) AFTER email,
ADD COLUMN performance_rating DECIMAL(3, 1) DEFAULT 3.0;

-- 5. RENAME OR ALTER COLUMNS
-- Rename phone_number to contact_number
ALTER TABLE employees RENAME COLUMN phone_number TO contact_number;

-- Modify performance_rating column data type constraint
ALTER TABLE employees
MODIFY COLUMN performance_rating DECIMAL(2, 1) NOT NULL DEFAULT 3.0;

-- Verify altered schema
DESCRIBE employees;

-- 6. UPDATE EXISTING RECORDS
-- Populate contact info and performance ratings
UPDATE employees
SET
    contact_number = '+1-555-0199',
    performance_rating = 4.8
WHERE
    employee_id = 1;

UPDATE employees
SET
    contact_number = '+1-555-0144',
    performance_rating = 4.2
WHERE
    employee_id = 2;

-- Grant a 7% salary increase to all engineers with salary < 100,000
UPDATE employees
SET
    salary = ROUND(salary * 1.07, 2)
WHERE
    department_id = 1
    AND salary < 100000;

-- Verify updates
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    performance_rating,
    contact_number
FROM employees;

-- 7. DELETE RECORDS
-- Remove inactive probationary/intern records
DELETE FROM employees WHERE status = 'Inactive' AND salary < 35000;

-- Verify deletion
SELECT employee_id, first_name, last_name, status FROM employees;


-- 8. CONDITIONAL LOGIC (Filtering & Logical Operators)
-- Filter employees hired after 2021 earning over $60,000 in specific departments
SELECT
    employee_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    job_title,
    salary,
    hire_date
FROM employees
WHERE (department_id IN (1, 3, 5))
    AND (
        salary BETWEEN 50000 AND 120000
    )
    AND (hire_date >= '2021-01-01')
ORDER BY salary DESC;

-- 9. CREATE CATEGORIES USING CASE
-- Categorize employees by salary band and seniority bracket
SELECT
    employee_id,
    CONCAT(first_name, ' ', last_name) AS employee_name,
    job_title,
    salary,
    CASE
        WHEN salary >= 100000 THEN 'Executive / Tier 1'
        WHEN salary >= 70000 THEN 'Senior / Tier 2'
        WHEN salary >= 50000 THEN 'Mid-Level / Tier 3'
        ELSE 'Junior / Entry'
    END AS salary_bracket,
    CASE
        WHEN hire_date < '2020-01-01' THEN 'Veteran (> 4 yrs)'
        WHEN hire_date BETWEEN '2020-01-01' AND '2022-12-31'  THEN 'Established (2-4 yrs)'
        ELSE 'Recent Hire (< 2 yrs)'
    END AS tenure_category,
    CASE
        WHEN performance_rating >= 4.5 THEN 'Exceptional'
        WHEN performance_rating >= 3.5 THEN 'Proficient'
        ELSE 'Needs Improvement'
    END AS review_classification
FROM employees
ORDER BY salary DESC;