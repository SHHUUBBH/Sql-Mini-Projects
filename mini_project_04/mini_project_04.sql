USE classicmodels;

-- 1. CUSTOMER & PAYMENT ANALYSIS
-- 1.1 Customer payment activity details (INNER JOIN)

SELECT c.customerNumber, c.customerName, c.country, p.checkNumber, p.paymentDate, p.amount
FROM customers c
    INNER JOIN payments p ON c.customerNumber = p.customerNumber
ORDER BY p.paymentDate DESC;

-- 1.2 Total revenue and payment count per customer (Aggregation with JOIN)
SELECT
    c.customerNumber,
    c.customerName,
    c.country,
    COUNT(p.checkNumber) AS total_payments,
    ROUND(COALESCE(SUM(p.amount), 0), 2) AS total_revenue_contributed
FROM customers c
    LEFT JOIN payments p ON c.customerNumber = p.customerNumber
GROUP BY
    c.customerNumber,
    c.customerName,
    c.country
ORDER BY total_revenue_contributed DESC;

-- 2. EMPLOYEE & OFFICE ANALYSIS
-- 2.1 Connect employees with their physical office locations (INNER JOIN)
SELECT
    e.employeeNumber,
    CONCAT(e.firstName, ' ', e.lastName) AS employee_name,
    e.jobTitle,
    o.officeCode,
    o.city AS office_city,
    o.state AS office_state,
    o.country AS office_country
FROM employees e
    INNER JOIN offices o ON e.officeCode = o.officeCode
ORDER BY o.country, e.lastName;

-- 2.2 Office headcount and capacity distribution (Office Analysis)
SELECT o.officeCode, o.city, o.country, COUNT(e.employeeNumber) AS employee_headcount
FROM offices o
    LEFT JOIN employees e ON o.officeCode = e.officeCode
GROUP BY
    o.officeCode,
    o.city,
    o.country
ORDER BY employee_headcount DESC;

-- 3. ORDER & PRODUCT ANALYSIS (MULTIPLE-TABLE JOINS)
-- 3.1 Line item detail combining orders, order details, and product specs
SELECT
    o.orderNumber,
    o.orderDate,
    o.status,
    p.productCode,
    p.productName,
    p.productLine,
    od.quantityOrdered,
    od.priceEach,
    ROUND(
        od.quantityOrdered * od.priceEach,
        2
    ) AS line_item_total
FROM
    orders o
    INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
    INNER JOIN products p ON od.productCode = p.productCode
ORDER BY o.orderNumber, od.orderLineNumber;

-- 3.2 Product sales performance and units sold (Aggregation with multiple JOINs)
SELECT
    p.productLine,
    p.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS total_units_sold,
    ROUND(
        SUM(
            od.quantityOrdered * od.priceEach
        ),
        2
    ) AS gross_sales_volume
FROM products p
    INNER JOIN orderdetails od ON p.productCode = od.productCode
GROUP BY
    p.productLine,
    p.productCode,
    p.productName
ORDER BY gross_sales_volume DESC;

-- 4. SALES REPRESENTATIVE ANALYSIS
-- 4.1 Connect customers with their assigned sales reps (LEFT JOIN to include unassigned)
SELECT
    c.customerNumber,
    c.customerName,
    c.country AS customer_country,
    COCAT_REP.employeeNumber AS rep_id,
    COCAT_REP.sales_rep_name,
    COCAT_REP.jobTitle,
    COCAT_REP.office_city
FROM customers c
    LEFT JOIN (
        SELECT
            e.employeeNumber, CONCAT(e.firstName, ' ', e.lastName) AS sales_rep_name, e.jobTitle, o.city AS office_city
        FROM employees e
            INNER JOIN offices o ON e.officeCode = o.officeCode
    ) AS COCAT_REP ON c.salesRepEmployeeNumber = COCAT_REP.employeeNumber
ORDER BY COCAT_REP.sales_rep_name IS NULL DESC, c.customerName ASC;

-- 5. EMPLOYEE HIERARCHY (SELF JOIN)
-- 5.1 Analyze employee-manager reporting chain (Self Join)
SELECT
    e.employeeNumber AS employee_id,
    CONCAT(e.firstName, ' ', e.lastName) AS employee_name,
    e.jobTitle AS employee_role,
    m.employeeNumber AS manager_id,
    COALESCE(
        CONCAT(m.firstName, ' ', m.lastName),
        'Top Executive (No Manager)'
    ) AS reports_to_manager,
    COALESCE(m.jobTitle, 'Executive Board') AS manager_role
FROM employees e
    LEFT JOIN employees m ON e.reportsTo = m.employeeNumber
ORDER BY m.employeeNumber, e.lastName;

-- 6. MISSING RELATIONSHIPS & ORPHAN RECORDS (DIAGNOSTIC JOINS)
-- 6.1 Customers who have never placed an order (Customers without orders)
SELECT c.customerNumber, c.customerName, c.contactFirstName, c.contactLastName, c.phone, c.country
FROM customers c
    LEFT JOIN orders o ON c.customerNumber = o.customerNumber
WHERE
    o.orderNumber IS NULL
ORDER BY c.customerName;

-- 6.2 Catalog products that have never been purchased (Unsold Inventory)
SELECT p.productCode, p.productName, p.productLine, p.quantityInStock, p.buyPrice
FROM products p
    LEFT JOIN orderdetails od ON p.productCode = od.productCode
WHERE
    od.productCode IS NULL;

-- 6.3 Sales representatives with no customer accounts assigned
SELECT e.employeeNumber, CONCAT(e.firstName, ' ', e.lastName) AS sales_rep_name, e.email, e.jobTitle
FROM employees e
    LEFT JOIN customers c ON e.employeeNumber = c.salesRepEmployeeNumber
WHERE
    e.jobTitle LIKE '%Sales Rep%'
    AND c.customerNumber IS NULL;

-- 7. CROSS JOIN (Exploratory Product Line & Office Presence Matrix)
-- 7.1 Cross Join displaying theoretical product line coverage per regional office
SELECT
    o.city AS office_city,
    o.country AS office_country,
    pl.productLine
FROM offices o
    CROSS JOIN productlines pl
ORDER BY o.city, pl.productLine;