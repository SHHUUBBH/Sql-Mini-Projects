# Mini Project 05: Advanced SQL — Window Functions

## Project Overview
This project applies SQL window functions and Common Table Expressions (CTEs) on the `classicmodels` database to execute time-series cash flow tracking, partitioned ranking, month-over-month performance analysis, and rolling moving averages without collapsing underlying dataset granularity.

## Core Concepts & Theoretical Explanations

### 1. `PARTITION BY`
The `PARTITION BY` clause divides the result set into distinct partitions or logical subsets. Window functions calculate output independently for each partition and reset the computation when crossing partition boundaries, preserving individual row identities.

### 2. Window `ORDER BY`
Defines the sequence in which rows are evaluated within each partition. This ordering is critical for sequential operations such as cumulative aggregates, rolling ranges, and ranking metrics.

### 3. Ranking Functions
- **`ROW_NUMBER()`**: Assigns a unique, consecutive integer to every row within a partition, strictly incrementing without ties.
- **`RANK()`**: Assigns identical ranks to tied rows and skips downstream ranks corresponding to the number of duplicate ties (e.g., 1, 2, 2, 4).
- **`DENSE_RANK()`**: Assigns identical ranks to tied values without skipping subsequent integers (e.g., 1, 2, 2, 3).

### 4. `LAG()`
An offset window function that retrieves data from a preceding row at a specified offset within the partition. It enables period-over-period comparisons, such as contrasting current monthly revenue directly against the preceding month.

### 5. Running Totals
Calculated using `SUM(col) OVER (ORDER BY ...)`. In contrast to a standard `GROUP BY` aggregate that condenses rows, running totals provide cumulative sums that accumulate row by row down the timeline.

### 6. Moving Averages
A smoothing technique defined via window framing (`ROWS BETWEEN 2 PRECEDING AND CURRENT ROW`). It computes an unweighted average spanning a trailing window to highlight underlying macro trends by filtering out short-term fluctuations.

## Key Analytical Observations
1. **Seasonal Climax in Q4:** Month-over-month payment analysis shows significant spikes in November each year, followed by sharp volume drops in January, pointing to heavy year-end holiday ordering cycles.
2. **Catalog Tier Consistency:** Using `DENSE_RANK()`, the `Classic Cars` line features the highest price dispersion, containing both the top catalog item (1952 Alpine Renault 1300 at $214.30) and competitive mid-tier entries.
3. **Cash Flow Trajectory:** The global running total reveals consistent year-over-year revenue expansion, with moving averages smoothing out temporary order lulls in the spring months.

## File Structure
```text
├── mini_project_05.sql       # Documented executable SQL queries
├── README.md                 # Concept explanations and observations
└── screenshots/              # VS Code execution results
    ├── 01_product_ranking.png
    ├── 02_running_totals.png
    └── 03_mom_growth_and_moving_avg.png