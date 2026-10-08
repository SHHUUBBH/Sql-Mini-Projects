# Mini Project 03: Data Cleaning & Transformation

## Project Overview
This project addresses real-world data quality anomalies by implementing SQL-driven auditing, cleaning, normalization, and feature extraction on dirty transaction records.

## Data Quality Issues Identified
1. **Missing Data:** Null values across customer emails, telephone fields, and total monetary amounts.
2. **Whitespace & Casing Inconsistencies:** Leading/trailing padding spaces and mixed case strings in names and emails (`  john DOE `, `CLARA@TARDIS.ORG`).
3. **Special Character Clutter in Phone Numbers:** Non-standardized telephone formats containing dashes, parentheses, dots, and national prefixes (`+1 (555) 234-5678`, `555.987.6543`).
4. **Duplicate Records:** Duplicate order rows caused by repeated user submissions.
5. **Logical & Business Rule Violations:** Negative transaction amounts (`-$45.00`) and orders where the delivery/shipping date preceded the placement date (`shipped_date < order_date`).
6. **Categorical Discrepancies:** Multiple variations for identical country destinations (`US`, `USA`, `United States`) and casing variations in order statuses (`penDing`, `DELIVERED`).

## How Issues Were Handled
- **String Sanitization:** Employed `TRIM()`, `LOWER()`, `UPPER()`, and string slicing functions (`LEFT`, `SUBSTRING`) for clean text output.
- **Regular Expressions:** Used `REGEXP_REPLACE` to strip non-numeric telephone formatting down to pure ten-digit integers and regex pattern checking to validate email domains.
- **Data Imputation & Business Logic:** Applied `ABS()` to resolve sign errors, calculated dynamic column averages for missing transaction amounts, and re-sequenced contradictory shipment dates using `DATE_ADD()`.
- **Deduplication:** Filtered and eliminated redundant records using subquery grouping (`MIN(record_id)` partition).
- **String Parsing & Feature Extraction:** Deconstructed compound SKU patterns (`PROD-CAT-ID-GRADE`) into atomic business dimensions (`product_category`, `product_id`, `quality_grade`) using nested `SUBSTRING_INDEX()`.

## SQL Concepts Applied
- String Manipulation: `TRIM()`, `CONCAT()`, `UPPER()`, `LOWER()`, `SUBSTRING()`, `SUBSTRING_INDEX()`, `REGEXP_REPLACE()`
- Missing Value Handling: `IS NULL`, `COALESCE()`, scalar aggregate subqueries
- Relational Deduplication: `GROUP BY`, `HAVING`, nested derived tables
- Date Math & Logic: `DATE_ADD()`, `INTERVAL`, `ABS()`
- Conditional Flow: Multi-condition `CASE ... WHEN ... THEN ... ELSE ... END`