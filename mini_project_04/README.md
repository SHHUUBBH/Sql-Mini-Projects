# Mini Project 04: Relational Analysis with JOINs

## Overview
This project applies relational algebra across multi-table corporate schemas (`classicmodels`) to extract commercial insights, audit reporting hierarchies, analyze regional office capacity, and diagnose broken relational dependencies.

## Analytical Observations
1. **Dormant Customer Accounts:** Out of the global customer accounts, 24 customers have never executed an order. These accounts represent unconverted leads or dormant accounts requiring sales follow-up.
2. **Unsold Inventory:** The product `1985 Toyota Supra` has zero historical sales recorded in `orderdetails` despite being listed in the catalog with 7,733 units in stock, representing dead capital.
3. **Executive Hierarchy:** The company operates under a strict hierarchy reporting to the President (Diane Murphy). Two VP roles report directly to the President, while field sales representatives are managed through regional Sales Managers.
4. **Unassigned Accounts:** Multiple international customer records lack an assigned `salesRepEmployeeNumber`, resulting in unmanaged accounts without dedicated account owners.
5. **Regional Concentration:** The Paris office holds the highest headcount concentration of active sales representatives, driving significant European revenue volume.

## Skills & Concepts Implemented
- **INNER JOIN:** Extracted matching intersection records between customers and payments, and joined line items across orders and products.
- **LEFT JOIN:** Preserved all left-table entities to discover missing relationships (customers without orders, unsold inventory, and unmanaged accounts).
- **SELF JOIN:** Mapped parent-child organizational structures by joining `employees` back to itself via `reportsTo = employeeNumber`.
- **CROSS JOIN:** Computed cartesian combinations between regional offices and product lines to evaluate coverage matrices.
- **Aggregation with Multiple JOINs:** Computed multi-table metrics combining order volume and gross catalog sales.

## Deliverables
- `mini_project_04.sql`: Documented SQL script containing all analysis modules.
- `screenshots/`: Result grid captures verifying output accuracy.