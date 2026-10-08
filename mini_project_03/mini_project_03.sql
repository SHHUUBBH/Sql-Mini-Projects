DROP DATABASE IF EXISTS data_cleaning_db;

CREATE DATABASE data_cleaning_db;

USE data_cleaning_db;

SET SQL_SAFE_UPDATES = 0;
-- Allows targeted batch data transformations
-- 1. SETUP RAW UNCLEANED TABLE
CREATE TABLE raw_customer_orders (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone_raw VARCHAR(50),
    product_sku VARCHAR(50),
    order_date DATE,
    shipped_date DATE,
    order_amount DECIMAL(10, 2),
    country VARCHAR(50),
    order_status VARCHAR(50)
);

-- Seed dataset containing all target real-world data flaws
INSERT INTO
    raw_customer_orders (
        customer_name,
        email,
        phone_raw,
        product_sku,
        order_date,
        shipped_date,
        order_amount,
        country,
        order_status
    )
VALUES (
        '  john DOE ',
        'JOHN.DOE@GMAIL.COM ',
        '+1 (555) 234-5678',
        'PROD-ELEC-1001-A',
        '2024-01-10',
        '2024-01-14',
        150.00,
        'USA',
        'Delivered'
    ),
    (
        'Jane smith  ',
        'jane.smith@yahoo.com',
        '555.987.6543',
        'PROD-FURN-2002-B',
        '2024-01-12',
        '2024-01-11',
        89.50,
        'United States',
        'shipped'
    ), -- Shipped before order date
    (
        'alice williams',
        NULL,
        '(555) 123 4567',
        'PROD-CLOTH-3003-C',
        '2024-01-15',
        '2024-01-18',
        -45.00,
        'US',
        'DELIVERED'
    ), -- Negative amount
    (
        'BOB JONES  ',
        'bob.jones@invalid-domain',
        '5551234567',
        'PROD-ELEC-4004-A',
        '2024-01-18',
        NULL,
        320.00,
        'United Kingdom',
        'penDing'
    ),
    (
        'clara Oswald ',
        'CLARA@TARDIS.ORG',
        '+44 20 7946 0958',
        'PROD-OFFC-5005-B',
        '2024-01-20',
        '2024-01-22',
        NULL,
        'UK',
        'Processing'
    ), -- Missing amount
    (
        '  john DOE ',
        'JOHN.DOE@GMAIL.COM ',
        '+1 (555) 234-5678',
        'PROD-ELEC-1001-A',
        '2024-01-10',
        '2024-01-14',
        150.00,
        'USA',
        'Delivered'
    ), -- Exact Duplicate of record 1
    (
        'david miller',
        'david.miller@domain.com',
        NULL,
        'PROD-CLOTH-6006-A',
        '2024-01-22',
        '2024-01-25',
        210.00,
        'CAN',
        'Cancelled'
    ),
    (
        'EMMA WATSON',
        'emma@watson.co.uk',
        '(555)-444-3322',
        'PROD-FURN-7007-C',
        '2024-01-25',
        '2024-01-28',
        540.00,
        'Canada',
        'In Transit'
    );

-- 2. DIAGNOSTIC QUERIES (Identify Data Quality Issues First)
-- 2.1 Identify Missing Values (NULL Handling)
SELECT
    record_id,
    customer_name,
    email,
    phone_raw,
    order_amount
FROM raw_customer_orders
WHERE
    email IS NULL
    OR phone_raw IS NULL
    OR order_amount IS NULL;

-- 2.2 Identify Exact Duplicates
SELECT
    customer_name,
    email,
    product_sku,
    order_date,
    COUNT(*) AS occurrence_count
FROM raw_customer_orders
GROUP BY
    customer_name,
    email,
    product_sku,
    order_date
HAVING
    COUNT(*) > 1;

-- 2.3 Identify Chronological and Numerical Inconsistencies
SELECT
    record_id,
    order_date,
    shipped_date,
    order_amount
FROM raw_customer_orders
WHERE (shipped_date < order_date)
    OR (order_amount < 0);

-- 2.4 Identify Inconsistent Country Names and Order Statuses
SELECT DISTINCT country FROM raw_customer_orders;

SELECT DISTINCT order_status FROM raw_customer_orders;

-- 3. DATA CLEANING & STANDARDIZATION (In-Place Transformations)
-- 3.1 Customer Name Cleaning (Trim whitespace & normalize casing)
UPDATE raw_customer_orders
SET
    customer_name = CONCAT(
        UPPER(LEFT(TRIM(customer_name), 1)),
        LOWER(
            SUBSTRING(TRIM(customer_name), 2)
        )
    );

-- 3.2 Email Cleaning (Trim, lowercase, and flag invalid syntax)
UPDATE raw_customer_orders
SET
    email = LOWER(TRIM(email))
WHERE
    email IS NOT NULL;

UPDATE raw_customer_orders
SET
    email = 'contact_pending@verification.com'
WHERE
    email IS NULL
    OR email NOT LIKE '%_@__%.__%';

-- 3.3 Phone Number Cleaning (Standardize to 10 pure numeric digits)
UPDATE raw_customer_orders
SET
    phone_raw = REGEXP_REPLACE(phone_raw, '[^0-9]', '')
WHERE
    phone_raw IS NOT NULL;

UPDATE raw_customer_orders
SET
    phone_raw = 'UNKNOWN'
WHERE
    phone_raw IS NULL;

-- 3.4 Logical Inconsistency Corrections
-- Fix negative order amounts to valid positive figures
UPDATE raw_customer_orders
SET
    order_amount = ABS(order_amount)
WHERE
    order_amount < 0;

-- Fill missing order amount with table average
UPDATE raw_customer_orders
SET
    order_amount = (
        SELECT ROUND(AVG(o.order_amount), 2)
        FROM (
                SELECT order_amount
                FROM raw_customer_orders
                WHERE
                    order_amount IS NOT NULL
            ) AS o
    )
WHERE
    order_amount IS NULL;

-- Correct reverse shipping dates (swap shipped_date to order_date + 2 days if illogical)
UPDATE raw_customer_orders
SET
    shipped_date = DATE_ADD(order_date, INTERVAL 2 DAY)
WHERE
    shipped_date < order_date;

-- 3.5 Country Standardization
UPDATE raw_customer_orders
SET
    country = CASE
        WHEN UPPER(country) IN ('US', 'UNITED STATES', 'USA') THEN 'United States'
        WHEN UPPER(country) IN ('UK', 'UNITED KINGDOM') THEN 'United Kingdom'
        WHEN UPPER(country) IN ('CAN', 'CANADA') THEN 'Canada'
        ELSE country
    END;

-- 3.6 Order Status Standardization
UPDATE raw_customer_orders
SET
    order_status = CASE
        WHEN LOWER(order_status) = 'delivered' THEN 'Delivered'
        WHEN LOWER(order_status) = 'shipped' THEN 'Shipped'
        WHEN LOWER(order_status) = 'pending' THEN 'Pending'
        WHEN LOWER(order_status) = 'processing' THEN 'Processing'
        WHEN LOWER(order_status) = 'cancelled' THEN 'Cancelled'
        WHEN LOWER(order_status) = 'in transit' THEN 'In Transit'
        ELSE 'Other'
    END;

-- 4. DUPLICATE REMOVAL

-- Retain only the lowest record_id for duplicate customer purchases
DELETE FROM raw_customer_orders
WHERE
    record_id NOT IN(
        SELECT MIN(record_id)
        FROM (
                SELECT *
                FROM raw_customer_orders
            ) AS temp
        GROUP BY
            customer_name,
            email,
            product_sku,
            order_date
    );

-- 5. PRODUCT TRANSFORMATION & ORDER ANALYSIS (Feature Extraction)
-- Extract Product Category, Product ID, and Grade Tier from product_sku: 'PROD-ELEC-1001-A'
SELECT
    record_id,
    customer_name,
    product_sku,
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(product_sku, '-', 2),
        '-',
        -1
    ) AS product_category,
    SUBSTRING_INDEX(
        SUBSTRING_INDEX(product_sku, '-', 3),
        '-',
        -1
    ) AS product_id,
    SUBSTRING_INDEX(product_sku, '-', -1) AS quality_grade,
    order_amount,
    order_status,
    CASE
        WHEN order_status = 'Delivered' THEN 'Completed'
        WHEN order_status IN ('Shipped', 'In Transit') THEN 'Fulfillment In-Flight'
        WHEN order_status IN ('Pending', 'Processing') THEN 'Awaiting Action'
        ELSE 'Closed/Exception'
    END AS operational_pipeline_stage
FROM raw_customer_orders
ORDER BY record_id ASC;

-- Final clean state verification
SELECT * FROM raw_customer_orders;