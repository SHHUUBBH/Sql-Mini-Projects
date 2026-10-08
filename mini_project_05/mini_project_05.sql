USE classicmodels;

-- 1. PRODUCT RANKING WITHIN PRODUCT LINES
-- Demonstrates ROW_NUMBER(), RANK(), and DENSE_RANK() side-by-side
-- to illustrate how duplicate price values and ties are evaluated.
SELECT
    productLine,
    productName,
    MSRP,
    ROW_NUMBER() OVER (
        PARTITION BY
            productLine
        ORDER BY MSRP DESC
    ) AS row_num,
    RANK() OVER (
        PARTITION BY
            productLine
        ORDER BY MSRP DESC
    ) AS price_rank,
    DENSE_RANK() OVER (
        PARTITION BY
            productLine
        ORDER BY MSRP DESC
    ) AS dense_price_rank
FROM products
ORDER BY productLine, dense_price_rank;

-- 2. TOP PRODUCTS IDENTIFICATION (CTE + DENSE_RANK)
-- Extracts only the top 3 highest-priced products per product line.
WITH
    RankedCatalog AS (
        SELECT
            productLine,
            productCode,
            productName,
            MSRP,
            buyPrice,
            DENSE_RANK() OVER (
                PARTITION BY
                    productLine
                ORDER BY MSRP DESC
            ) AS rank_position
        FROM products
    )
SELECT
    productLine,
    rank_position,
    productName,
    productCode,
    MSRP,
    buyPrice
FROM RankedCatalog
WHERE
    rank_position <= 3
ORDER BY productLine, rank_position;

-- 3. RUNNING TOTALS (CUMULATIVE REVENUE ANALYSIS)
-- 3.1 Cumulative payment totals per customer chronologically
SELECT
    customerNumber,
    checkNumber,
    paymentDate,
    amount,
    ROUND(
        SUM(amount) OVER (
            PARTITION BY
                customerNumber
            ORDER BY paymentDate, checkNumber
        ),
        2
    ) AS customer_running_total
FROM payments
ORDER BY customerNumber, paymentDate;

-- 3.2 Global running total of business cash inflow by payment date
SELECT
    paymentDate,
    checkNumber,
    amount,
    ROUND(
        SUM(amount) OVER (
            ORDER BY
                paymentDate,
                checkNumber ROWS BETWEEN UNBOUNDED PRECEDING
                AND CURRENT ROW
        ),
        2
    ) AS global_cumulative_cashflow
FROM payments
ORDER BY paymentDate;

-- 4. MONTH-OVER-MONTH (MoM) & GROWTH ANALYSIS (CTE + LAG)
-- Aggregates revenue monthly, looks up previous month revenue via LAG(),
-- and computes dollar change and percentage growth rates.
WITH
    MonthlyRevenue AS (
        SELECT
            DATE_FORMAT(paymentDate, '%Y-%m') AS payment_period,
            YEAR(paymentDate) AS rev_year,
            MONTH(paymentDate) AS rev_month,
            ROUND(SUM(amount), 2) AS total_monthly_revenue
        FROM payments
        GROUP BY
            DATE_FORMAT(paymentDate, '%Y-%m'),
            YEAR(paymentDate),
            MONTH(paymentDate)
    ),
    RevenueComparison AS (
        SELECT
            payment_period,
            rev_year,
            rev_month,
            total_monthly_revenue,
            LAG(total_monthly_revenue, 1) OVER (
                ORDER BY payment_period
            ) AS prior_month_revenue
        FROM MonthlyRevenue
    )
SELECT
    payment_period,
    total_monthly_revenue,
    prior_month_revenue,
    ROUND(
        total_monthly_revenue - prior_month_revenue,
        2
    ) AS mom_dollar_change,
    ROUND(
        (
            (
                total_monthly_revenue - prior_month_revenue
            ) / prior_month_revenue
        ) * 100,
        2
    ) AS mom_growth_percentage
FROM RevenueComparison
ORDER BY payment_period;

-- 5. MOVING AVERAGE (3-MONTH ROLLING REVENUE)
-- Smooths monthly revenue volatility with a 3-month rolling average
-- using ROWS BETWEEN 2 PRECEDING AND CURRENT ROW.
WITH
    MonthlyTotals AS (
        SELECT
            DATE_FORMAT(paymentDate, '%Y-%m') AS payment_period,
            ROUND(SUM(amount), 2) AS current_revenue
        FROM payments
        GROUP BY
            DATE_FORMAT(paymentDate, '%Y-%m')
    )
SELECT
    payment_period,
    current_revenue,
    ROUND(
        AVG(current_revenue) OVER (
            ORDER BY
                payment_period ROWS BETWEEN 2 PRECEDING
                AND CURRENT ROW
        ),
        2
    ) AS three_month_moving_avg
FROM MonthlyTotals
ORDER BY payment_period;