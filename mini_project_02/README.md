# Mini Project 02: ClassicModels Query Challenge

## Dataset Used
- **Database:** `classicmodels` (Standard relational sample database)
- **Primary Tables:** `customers`, `products`, `payments`

## Questions Solved
1. **Customer Analysis:** Distribution of customers across countries, localized filtering with `IN`, identifying highest credit lines, searching business keywords with `LIKE`, auditing unassigned sales reps, and identifying customers with above-average credit limits via subqueries.
2. **Product Analysis:** Profit margin calculation (`MSRP - buyPrice`), aggregation by `productLine`, low-stock warning queries (`quantityInStock < 1000`), pattern matching with wildcards, and result pagination using `LIMIT` and `OFFSET`.
3. **Payment Analysis:** Historical date-filtered payments (2004), aggregate transaction metrics (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`), customer lifetime expenditure ranking, high-value filtering with `HAVING`, and anomaly detection using subqueries.

## SQL Concepts Demonstrated
- Filtering & Pattern Matching: `WHERE`, `IN`, `BETWEEN`, `LIKE`
- Aggregation & Grouping: `COUNT()`, `SUM()`, `AVG()`, `MIN()`, `MAX()`, `GROUP BY`, `HAVING`
- Sorting & Pagination: `ORDER BY`, `LIMIT`, `OFFSET`
- Nested Logic: Scalar Subqueries (`SELECT AVG(...)`)

## Key Findings
- The USA represents the largest customer market volume.
- The `Classic Cars` and `Vintage Cars` lines generate the highest profit margins per unit.
- A select group of VIP accounts contribute the majority of revenue, each surpassing $100,000 in cumulative payments.