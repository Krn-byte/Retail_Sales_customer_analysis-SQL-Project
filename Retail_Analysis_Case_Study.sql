/* ============================================================
   SALES & CUSTOMER DATA ANALYSIS PROJECT
   DATABASE: MySQL

   OBJECTIVES:
   - Clean and standardize the raw data
   - Handle missing and duplicate records
   - Validate and standardize product prices
   - Analyze product-wise sales performance and rankings
   - Identify sales trends over time
   - Analyze customer loyalty and purchase behavior
   - Segment customers based on purchase quantity
   - Apply CTEs and window functions for analytical queries

   TABLES USED:
   1. PRODUCT_INVENTORY
   2. CUSTOMER_PROFILES
   3. SALES_TRANSACTION
   ============================================================ */


/* ============================================================
   1. STANDARDIZE COLUMN NAMES
   Remove unwanted special characters from column names.
   ============================================================ */

ALTER TABLE PRODUCT_INVENTORY
RENAME COLUMN ï»¿ProductID TO PRODUCTID;

ALTER TABLE CUSTOMER_PROFILES
RENAME COLUMN CUSTOMERTID TO CUSTOMERID;

ALTER TABLE SALES_TRANSACTION
RENAME COLUMN ï»¿TRANSACTIONID TO TRANSACTIONID;


/* ============================================================
   2. STANDARDIZE TRANSACTION DATE
   Convert text dates into the DATE datatype.
   ============================================================ */

SET SQL_SAFE_UPDATES = 0;

UPDATE SALES_TRANSACTION
SET TRANSACTIONDATE = STR_TO_DATE(
    TRANSACTIONDATE,
    '%d/%m/%y'
);

ALTER TABLE SALES_TRANSACTION
MODIFY COLUMN TRANSACTIONDATE DATE;


/* ============================================================
   3. STANDARDIZE CUSTOMER JOIN DATE
   Convert text-based join dates into proper DATE values.
   ============================================================ */

UPDATE CUSTOMER_PROFILES
SET JOINDATE = STR_TO_DATE(
    JOINDATE,
    '%d/%m/%y'
);

ALTER TABLE CUSTOMER_PROFILES
MODIFY COLUMN JOINDATE DATE;


/* ============================================================
   4. HANDLE MISSING LOCATION VALUES
   Replace blank locations with 'UNKNOWN'.
   ============================================================ */

UPDATE CUSTOMER_PROFILES
SET LOCATION = 'UNKNOWN'
WHERE LOCATION = '';


/* ============================================================
   5. REMOVE DUPLICATE TRANSACTIONS
   Create a cleaned dataset containing only unique records.
   ============================================================ */

CREATE TABLE SALES2 AS
SELECT DISTINCT *
FROM SALES_TRANSACTION;

DROP TABLE SALES_TRANSACTION;

ALTER TABLE SALES2
RENAME TO SALES_TRANSACTION;


/* ============================================================
   6. VALIDATE PRODUCT PRICES
   Compare transaction prices with master product prices
   to identify inconsistent records.
   ============================================================ */

SELECT
    S.TRANSACTIONID,
    S.PRODUCTID,
    S.PRICE AS TRANSACTION_PRICE,
    P.PRICE AS MASTER_PRICE
FROM SALES_TRANSACTION S
LEFT JOIN PRODUCT_INVENTORY P
    ON S.PRODUCTID = P.PRODUCTID
WHERE P.PRICE <> S.PRICE;


/* ============================================================
   7. STANDARDIZE SALES PRICES
   Replace inconsistent transaction prices with the
   corresponding master product price.
   ============================================================ */

UPDATE SALES_TRANSACTION S
SET PRICE = (
    SELECT P.PRICE
    FROM PRODUCT_INVENTORY P
    WHERE S.PRODUCTID = P.PRODUCTID
);


/* ============================================================
   8. PRODUCT-WISE SALES ANALYSIS
   Calculate product sales and rank products by revenue
   using a CTE and window function.
   ============================================================ */

WITH PRODUCT_SALES AS (
    SELECT
        P.PRODUCTNAME,
        SUM(S.QUANTITYPURCHASED) AS TOTALQUANTITY,
        ROUND(
            SUM(S.QUANTITYPURCHASED * S.PRICE),
            2
        ) AS TOTALSALES
    FROM SALES_TRANSACTION S
    LEFT JOIN PRODUCT_INVENTORY P
        ON S.PRODUCTID = P.PRODUCTID
    GROUP BY P.PRODUCTNAME
)

SELECT
    PRODUCTNAME,
    TOTALQUANTITY,
    TOTALSALES,
    RANK() OVER (ORDER BY TOTALSALES DESC) AS SALESRANK
FROM PRODUCT_SALES
ORDER BY TOTALSALES DESC;


/* ============================================================
   9. SALES TREND ANALYSIS
   Calculate daily quantity sold and revenue to identify
   sales patterns over time.
   ============================================================ */

SELECT
    TRANSACTIONDATE,
    SUM(QUANTITYPURCHASED) AS TOTALQUANTITY,
    ROUND(
        SUM(QUANTITYPURCHASED * PRICE),
        2
    ) AS TOTAL_SALES
FROM SALES_TRANSACTION
GROUP BY TRANSACTIONDATE
ORDER BY TOTAL_SALES DESC;


/* ============================================================
   10. CUSTOMER LOYALTY ANALYSIS
   Identify first purchase, last purchase and the number
   of days between purchases using a CTE.
   ============================================================ */

WITH CUSTOMER_PURCHASES AS (
    SELECT
        CUSTOMERID,
        MIN(TRANSACTIONDATE) AS FIRSTPURCHASE,
        MAX(TRANSACTIONDATE) AS LASTPURCHASE
    FROM SALES_TRANSACTION
    GROUP BY CUSTOMERID
)

SELECT
    CUSTOMERID,
    FIRSTPURCHASE,
    LASTPURCHASE,
    DATEDIFF(LASTPURCHASE, FIRSTPURCHASE) AS DAYSBETWEENPURCHASES
FROM CUSTOMER_PURCHASES
WHERE DATEDIFF(LASTPURCHASE, FIRSTPURCHASE) > 0
ORDER BY DAYSBETWEENPURCHASES ASC;


/* ============================================================
   11. CUSTOMER SEGMENTATION
   Segment customers based on total quantity purchased:
   HIGH   : More than 30
   MEDIUM : 10–30
   LOW    : 1–9
   NONE   : No purchases
   ============================================================ */

CREATE TABLE CUSTOMER_SEGMENT AS

SELECT
    CUSTOMERID,

    CASE
        WHEN TOTALQUANTITY > 30 THEN 'HIGH'
        WHEN TOTALQUANTITY BETWEEN 10 AND 30 THEN 'MEDIUM'
        WHEN TOTALQUANTITY BETWEEN 1 AND 9 THEN 'LOW'
        ELSE 'NONE'
    END AS CUSTOMERSEGMENT

FROM
(
    SELECT
        C.CUSTOMERID,
        SUM(S.QUANTITYPURCHASED) AS TOTALQUANTITY
    FROM CUSTOMER_PROFILES C
    LEFT JOIN SALES_TRANSACTION S
        ON C.CUSTOMERID = S.CUSTOMERID
    GROUP BY C.CUSTOMERID
) AS R;

/* ============================================================
   END OF ANALYSIS
   ============================================================ */


/* ============================================================
   SKILLS DEMONSTRATED
   ============================================================

   DATA CLEANING
   - Column standardization
   - Missing value handling
   - Duplicate removal
   - Data quality validation

   DATA TRANSFORMATION
   - STR_TO_DATE()
   - ALTER TABLE / MODIFY COLUMN
   - UPDATE statements

   SQL JOINS
   - LEFT JOIN
   - Multi-table analysis

   AGGREGATION
   - SUM(), MIN(), MAX(), ROUND()
   - GROUP BY
   - Aggregate-based analysis

   ADVANCED SQL
   - CTEs (WITH)
   - Window functions
   - RANK()
   - Subqueries / derived tables

   DATA ANALYSIS
   - Product sales analysis
   - Revenue analysis
   - Product ranking
   - Sales trend analysis
   - Customer loyalty analysis

   CUSTOMER ANALYTICS
   - DATEDIFF()
   - CASE WHEN segmentation
   - Purchase behavior analysis

   SQL TECHNIQUES
   - DISTINCT
   - ORDER BY
   - Conditional logic
   - Table creation using SELECT
   ============================================================ */