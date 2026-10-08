USE classicmodels;
-- 1. CUSTOMER ANALYSIS
-- 1.1 Customer Locations: Customer distribution across countries
SELECT country, COUNT(customerNumber) AS total_customers
FROM customers
GROUP BY
    country
ORDER BY total_customers DESC;

-- 1.2 Customer Locations: Filter customers in key global commercial hubs (IN operator)
SELECT
    customerNumber,
    customerName,
    city,
    country
FROM customers
WHERE
    city IN (
        'NYC',
        'Paris',
        'Singapore',
        'London'
    )
ORDER BY country, city;

-- 1.3 Credit Limits: Top 10 highest credit limit accounts (LIMIT)
SELECT
    customerNumber,
    customerName,
    creditLimit
FROM customers
ORDER BY creditLimit DESC
LIMIT 10;

-- 1.4 Credit Limits: Filter middle-tier credit brackets
SELECT
    customerNumber,
    customerName,
    creditLimit,
    country
FROM customers
WHERE
    creditLimit BETWEEN 50000 AND 100000
ORDER BY creditLimit DESC;

-- 1.5 Customer Searches: Name pattern search (LIKE operator)
SELECT
    customerNumber,
    customerName,
    contactFirstName,
    contactLastName,
    phone
FROM customers
WHERE
    customerName LIKE '%Design%'
    OR customerName LIKE '%Auto%'
ORDER BY customerName;

-- 1.6 Sales Representatives: Unassigned accounts needing sales reps
SELECT
    customerNumber,
    customerName,
    city,
    country
FROM customers
WHERE
    salesRepEmployeeNumber IS NULL;

-- 1.7 Sales Representatives: Active reps managing 5 or more accounts (HAVING)
SELECT
    salesRepEmployeeNumber,
    COUNT(customerNumber) AS assigned_customers
FROM customers
WHERE
    salesRepEmployeeNumber IS NOT NULL
GROUP BY
    salesRepEmployeeNumber
HAVING
    COUNT(customerNumber) >= 5
ORDER BY assigned_customers DESC;

-- 1.8 Customer Credit Subquery: Accounts with credit above company average
SELECT
    customerNumber,
    customerName,
    creditLimit
FROM customers
WHERE
    creditLimit > (
        SELECT AVG(creditLimit)
        FROM customers
    )
ORDER BY creditLimit DESC;

-- 2. PRODUCT ANALYSIS
-- 2.1 Product Prices: Profit margin and markup calculations
SELECT
    productCode,
    productName,
    productLine,
    buyPrice,
    MSRP,
    ROUND(MSRP - buyPrice, 2) AS profit_margin,
    ROUND(
        ((MSRP - buyPrice) / buyPrice) * 100,
        2
    ) AS markup_percentage
FROM products
ORDER BY profit_margin DESC;

-- 2.2 Product Lines: Aggregated inventory metrics per line
SELECT
    productLine,
    COUNT(productCode) AS total_products,
    ROUND(AVG(buyPrice), 2) AS avg_buy_price,
    ROUND(MAX(MSRP), 2) AS max_msrp
FROM products
GROUP BY
    productLine
ORDER BY total_products DESC;

-- 2.3 Stock Levels: Stock alert for items below 1,000 units
SELECT
    productCode,
    productName,
    productLine,
    quantityInStock
FROM products
WHERE
    quantityInStock < 1000
ORDER BY quantityInStock ASC;

-- 2.4 Product Searches: Pattern filtering for specific vehicle eras/brands
SELECT
    productCode,
    productName,
    productLine,
    productScale
FROM products
WHERE
    productName LIKE '%1969%'
    OR productName LIKE '%Harley%'
ORDER BY productName;

-- 2.5 Product Sorting & Pagination: Products ranked 6th to 10th by MSRP (OFFSET)
SELECT
    productCode,
    productName,
    productLine,
    MSRP
FROM products
ORDER BY MSRP DESC
LIMIT 5
OFFSET
    5;

-- 3. PAYMENT ANALYSIS
-- 3.1 Payment Dates: Filter payments made in 2004
SELECT
    customerNumber,
    checkNumber,
    paymentDate,
    amount
FROM payments
WHERE
    paymentDate BETWEEN '2004-01-01' AND '2004-12-31'
ORDER BY paymentDate ASC;

-- 3.2 Payment Summary: Overall count, sum, average, min, and max
SELECT
    COUNT(checkNumber) AS total_transactions,
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_payment_amount,
    ROUND(MIN(amount), 2) AS min_payment_amount,
    ROUND(MAX(amount), 2) AS max_payment_amount
FROM payments;

-- 3.3 Customer Payment Activity: Aggregated payment count and total by customer
SELECT
    customerNumber,
    COUNT(checkNumber) AS transaction_count,
    ROUND(SUM(amount), 2) AS total_amount_paid,
    ROUND(AVG(amount), 2) AS avg_amount_paid
FROM payments
GROUP BY
    customerNumber
ORDER BY total_amount_paid DESC;

-- 3.4 High-Value Customers: Customers with lifetime spend > $100,000 (HAVING)
SELECT
    customerNumber,
    COUNT(checkNumber) AS payments_count,
    ROUND(SUM(amount), 2) AS cumulative_spent
FROM payments
GROUP BY
    customerNumber
HAVING
    cumulative_spent > 100000
ORDER BY cumulative_spent DESC;

-- 3.5 Outlier Payment Subquery: Transactions exceeding double the average payment
SELECT
    customerNumber,
    checkNumber,
    paymentDate,
    amount
FROM payments
WHERE
    amount > (
        SELECT AVG(amount) * 2
        FROM payments
    )
ORDER BY amount DESC;