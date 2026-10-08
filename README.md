# SQL Analytics & Engineering Portfolio

A comprehensive suite of five SQL projects demonstrating relational database design, data manipulation, cleaning, multi-table joins, and advanced analytical window functions using MySQL.

---

## Repository Structure

```text
├── 01_foundations/
│   ├── mini_project_01.sql
│   └── screenshots/
├── 02_classicmodels_eda/
│   ├── mini_project_02.sql
│   └── screenshots/
├── 03_data_cleaning/
│   ├── mini_project_03.sql
│   └── screenshots/
├── 04_relational_joins/
│   ├── mini_project_04.sql
│   └── screenshots/
├── 05_window_functions/
│   ├── mini_project_05.sql
│   └── screenshots/
└── README.md
```

---

## Project Modules Overview

| Project | Domain / Focus | Key Concepts & Functions | Target Schema |
| :--- | :--- | :--- | :--- |
| **01. SQL Foundations** | Schema Design & DDL/DML | `CREATE`, `ALTER`, `CONSTRAINT`, `CASE`, `UPDATE`, `DELETE` | `company_operations` |
| **02. Exploratory Analysis** | Business Reporting & Filtering | `GROUP BY`, `HAVING`, `LIKE`, `IN`, `LIMIT`, Subqueries | `classicmodels` |
| **03. Data Cleaning** | Anomaly Auditing & Transformation | `REGEXP_REPLACE`, `TRIM`, `SUBSTRING_INDEX`, Deduplication | `data_cleaning_db` |
| **04. Relational Analysis** | Entity Connections & Hierarchies | `INNER JOIN`, `LEFT JOIN`, `SELF JOIN`, `CROSS JOIN` | `classicmodels` |
| **05. Advanced Analytics** | Time-Series & Ranking Analytics | `ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`, Running Totals | `classicmodels` |

---

## Detailed Project Breakdowns

### 1. SQL Foundations & Database Operations
* **Objective:** Architect a normalized corporate database from scratch and implement robust business integrity constraints.
* **Key Implementations:**
  * Defined primary, foreign key (`ON DELETE SET NULL`), unique, and mathematical check constraints.
  * Applied non-destructive schema migrations using `ALTER TABLE` to add, rename, and modify column constraints.
  * Formulated multi-tier `CASE` conditional logic to dynamically categorize staff into compensation tiers, tenure brackets, and evaluation tiers.

### 2. ClassicModels Query Challenge
* **Objective:** Conduct exploratory data analysis across global commercial operations to extract operational performance metrics.
* **Key Implementations:**
  * Filtered localized regional hubs and isolated top credit limits using `IN`, `BETWEEN`, `ORDER BY`, and `LIMIT / OFFSET` pagination.
  * Calculated product line profitability margins (`MSRP - buyPrice`) and identified low-inventory thresholds.
  * Aggregated historical revenue patterns and flagged outlier transactions exceeding twice the enterprise average via scalar subqueries.

### 3. Data Cleaning & Transformation
* **Objective:** Audit, standardize, and transform messy, real-world transactional data containing syntactic and logical anomalies.
* **Key Implementations:**
  * Standardized mixed-case text and eliminated trailing/leading whitespace via `TRIM()`, `UPPER()`, and `LOWER()`.
  * Normalized inconsistent telephone numbers into unified numeric strings using `REGEXP_REPLACE()`.
  * Imputed missing transaction figures using dataset aggregations and corrected chronological discrepancies (`shipped_date < order_date`) using `DATE_ADD()`.
  * Removed duplicate transaction submissions using subquery partition matching on record identifiers.
  * Decomposed composite SKU strings into distinct dimensions (`category`, `item_id`, `grade`) with nested `SUBSTRING_INDEX()`.

### 4. Relational Analysis with JOINs
* **Objective:** Unify distributed relational entities to analyze organizational structures, sales distributions, and unlinked records.
* **Key Implementations:**
  * Coupled transaction line items across three relational boundaries (`orders`, `orderdetails`, `products`) to calculate gross volume.
  * Evaluated internal management hierarchies through a `SELF JOIN` mapping reporting relationships from field staff to executive leadership.
  * Audited pipeline drop-offs using diagnostic `LEFT JOIN ... WHERE NULL` queries to isolate unsold stock, unallocated accounts, and dormant customers with zero order history.

### 5. Advanced SQL — Window Functions
* **Objective:** Execute advanced time-series, moving calculations, and competitive rankings without collapsing underlying transaction granularity.
* **Key Implementations:**
  * Compared evaluation behaviors of `ROW_NUMBER()`, `RANK()`, and `DENSE_RANK()` over product lines partitioned by MSRP.
  * Extracted the top 3 highest-valued items within each product family using Common Table Expressions (CTEs).
  * Calculated chronological cumulative cash inflow trajectories via partitioned running totals.
  * Assessed monthly business performance with `LAG()` to determine Month-over-Month (MoM) growth rates and established a 3-month rolling moving average to smooth seasonal cash flow spikes.

---

## Technical Stack & Environment

* **Database Engine:** MySQL Server 8.0+
* **IDE & Tooling:** Visual Studio Code with Database Client Extension (or MySQL Workbench)
* **Language:** SQL (ANSI Compliant / MySQL Dialect)
* **Version Control:** Git & GitHub

---

## Setup & Execution Guide

### 1. Clone the Repository
```bash
git clone https://github.com<your-username>/<your-repo-name>.git
cd <your-repo-name>
```

### 2. Database Initialization
1. Open VS Code and establish an active connection to your local MySQL instance (`localhost:3306`).
2. For modules utilizing the enterprise retail dataset (Projects 02, 04, and 05), initialize the sample schema by running:
   ```sql
   SOURCE path/to/mysqlsampledatabase.sql;
   ```
3. Verify the installation by running `SHOW TABLES;` to ensure tables like `orders`, `products`, and `customers` populate successfully.

### 3. Running the Scripts
* Open the `.sql` script corresponding to the module you want to evaluate.
* Run the file sequentially or block-by-block using `Ctrl + Enter` (or `Cmd + Enter` on macOS) in your SQL editor.
* Query outputs will populate directly in your integrated IDE tabular result viewer.