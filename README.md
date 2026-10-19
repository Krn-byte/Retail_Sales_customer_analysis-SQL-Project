# Retail Sales & Customer Data Analysis using MySQL

## Project Overview

This project focuses on cleaning, standardizing, validating, and analyzing retail sales and customer data using MySQL. It uses three datasets: `PRODUCT_INVENTORY`, `CUSTOMER_PROFILES`, and `SALES_TRANSACTION`.

The project demonstrates practical SQL skills through data cleaning, sales analysis, product ranking, customer loyalty analysis, and customer segmentation. It uses SQL queries to transform raw data into structured information and derive insights into retail sales and customer purchasing behavior.

## Objectives

- Clean and standardize raw datasets.
- Handle missing values and duplicate records.
- Validate and standardize product prices.
- Analyze product-wise sales performance and rankings.
- Identify sales trends over time.
- Analyze customer loyalty and purchasing behavior.
- Segment customers based on total purchase quantity.
- Apply CTEs, window functions, joins, and aggregate functions for data analysis.

## Tools & Technologies

- **Database:** MySQL
- **Query Language:** SQL
- **Database Tool:** MySQL Workbench
- **Data Sources:** CSV files

## Dataset Overview

The project uses three datasets:

| Dataset | Description |
|---|---|
| `PRODUCT_INVENTORY` | Contains product information, product identifiers, product names, and prices. |
| `CUSTOMER_PROFILES` | Contains customer information, locations, and join dates. |
| `SALES_TRANSACTION` | Contains transaction records, customer and product identifiers, purchase quantities, dates, and prices. |

The CSV files must be imported into MySQL before executing the SQL script.

## Project Workflow

### 1. Data Cleaning and Standardization

- Standardized column names by removing unwanted characters and correcting inconsistent naming.
- Converted transaction dates and customer join dates from text into the MySQL `DATE` datatype.
- Replaced blank customer location values with `UNKNOWN`.
- Removed duplicate transaction records using `SELECT DISTINCT`.

### 2. Product Price Validation

- Compared transaction prices with the corresponding product prices using `LEFT JOIN`.
- Identified records where transaction prices differed from the product master prices.
- Standardized transaction prices using the prices available in `PRODUCT_INVENTORY`.

### 3. Product-Wise Sales Analysis

- Calculated total quantity purchased for each product.
- Calculated total sales revenue using quantity and price.
- Ranked products based on total sales using the `RANK()` window function.
- Used a Common Table Expression (CTE) to organize the analysis.

### 4. Sales Trend Analysis

- Aggregated total quantity sold and total revenue by transaction date.
- Compared daily sales activity.
- Sorted the results to identify dates with higher sales revenue.

### 5. Customer Loyalty Analysis

- Identified each customer's first and last purchase dates.
- Calculated the number of days between the first and last purchases using `DATEDIFF()`.
- Identified customers who made purchases on more than one date.

### 6. Customer Segmentation

Segmented customers based on their total purchase quantity using `CASE WHEN` statements.

| Customer Segment | Total Quantity Purchased |
|---|---|
| HIGH | More than 30 |
| MEDIUM | 10–30 |
| LOW | 1–9 |
| NONE | No recorded purchases |

The analysis uses `LEFT JOIN` to include customers who do not have matching transaction records.

## SQL Concepts Demonstrated

**Data Cleaning and Transformation**
- `UPDATE`
- `ALTER TABLE`
- `RENAME COLUMN`
- `MODIFY COLUMN`
- `SELECT DISTINCT`

**Joins and Aggregation**
- `LEFT JOIN`
- `SUM()`
- `MIN()`
- `MAX()`
- `ROUND()`
- `GROUP BY`

**Advanced SQL**
- Common Table Expressions (CTEs)
- Window functions
- `RANK()`
- Subqueries and derived tables
- `CASE WHEN`

**Date and Filtering Functions**
- `STR_TO_DATE()`
- `DATEDIFF()`
- `WHERE`
- `ORDER BY`

## How to Run the Project

1. Install and open MySQL Workbench.
2. Create a database for the project.
3. Import the three CSV files into MySQL using the following table names:
   - `PRODUCT_INVENTORY`
   - `CUSTOMER_PROFILES`
   - `SALES_TRANSACTION`
4. Verify that the imported column names and data types are compatible with the SQL script.
5. Open `Retail_Analysis_Case_Study.sql`.
6. Execute the SQL statements in sequence.
7. Review the results of the product sales, sales trend, customer loyalty, and customer segmentation queries.

**Important:** Run the script on a working copy of the data. The script modifies table structures and records, updates transaction prices, and drops and recreates `SALES_TRANSACTION` during duplicate removal.

## Notes and Limitations

- The analysis is based on the available datasets and the rules implemented in the SQL script.
- Missing locations are replaced with `UNKNOWN`; this does not establish the customer's actual location.
- Duplicate removal identifies records with identical values across all selected columns.
- Price standardization assumes that the product master price is the appropriate reference for every transaction. If prices change over time, historical pricing should be considered.
- Customer segmentation is based on total quantity purchased, not revenue or profit.
- Sales trends describe observed transaction activity and do not establish the causes of changes in sales.
- Results depend on correct CSV imports, compatible column names, and valid date values.

---
**Author:** Karan Upadhyay  
**Project Type:** Data Analytics | Retail Sales & Customer Data Analysis   
**Primary Tool:** MySQL

