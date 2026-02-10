/*  CUSTOMER LIFETIME VALUE ANALYTICS
   Dataset: IBM Telco Customer Churn  */

/* DATABASE CREATION  */

CREATE DATABASE IF NOT EXISTS clv_project;
USE clv_project;


/* RAW DATA TABLE */

CREATE TABLE customers_raw (
    customer_id VARCHAR(50),
    gender VARCHAR(10),
    senior_citizen INT,
    partner VARCHAR(5),
    dependents VARCHAR(5),
    tenure INT,
    phone_service VARCHAR(10),
    multiple_lines VARCHAR(20),
    internet_service VARCHAR(20),
    online_security VARCHAR(20),
    online_backup VARCHAR(20),
    device_protection VARCHAR(20),
    tech_support VARCHAR(20),
    streaming_tv VARCHAR(20),
    streaming_movies VARCHAR(20),
    contract VARCHAR(20),
    paperless_billing VARCHAR(5),
    payment_method VARCHAR(50),
    monthly_charges DECIMAL(10,2),

    -- kept as text due to dirty blanks
    total_charges VARCHAR(20),

    churn VARCHAR(5)
);


/* DATA QUALITY CHECKS */

SELECT COUNT(*) FROM customers_raw;

SELECT *
FROM customers_raw
LIMIT 10;

-- Missing IDs
SELECT COUNT(*)
FROM customers_raw
WHERE customer_id IS NULL
   OR customer_id = '';

-- Duplicate IDs
SELECT customer_id, COUNT(*)
FROM customers_raw
GROUP BY customer_id
HAVING COUNT(*) > 1;


/* TABLE CLEANING */

CREATE TABLE customers_clean AS
SELECT
    customer_id,
    gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,

    -- Clean cast
    CAST(NULLIF(TRIM(total_charges), '') AS DECIMAL(10,2))
        AS total_charges,

    CASE
        WHEN churn = 'Yes' THEN 1
        ELSE 0
    END AS churn_flag

FROM customers_raw;


/* Check cleaning impact */
SELECT COUNT(*)
FROM customers_clean
WHERE total_charges IS NULL;


/* CLV FEATURE ENGINEERING */

CREATE TABLE customer_clv AS
SELECT
    customer_id,
    gender,
    contract,
    payment_method,
    tenure AS lifetime_months,
    monthly_charges AS arpu,

    -- Simplified deterministic CLV proxy
    (monthly_charges * tenure) AS clv_value,

    churn_flag
FROM customers_clean;


/* SEGMENTATION */

CREATE TABLE customer_clv_segmented AS
SELECT
    *,
    CASE
        WHEN quartile = 4 THEN 'Platinum'
        WHEN quartile = 3 THEN 'Gold'
        WHEN quartile = 2 THEN 'Silver'
        ELSE 'Bronze'
    END AS clv_segment
FROM (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY clv_value) AS quartile
    FROM customer_clv
) t;


/* ANALYTICS QUERIES */

-- Segment distribution
SELECT
    clv_segment,
    COUNT(*) AS customers
FROM customer_clv_segmented
GROUP BY clv_segment;


-- Segment value ranges
SELECT
    clv_segment,
    MIN(clv_value) AS min_clv,
    MAX(clv_value) AS max_clv,
    AVG(clv_value) AS avg_clv
FROM customer_clv_segmented
GROUP BY clv_segment
ORDER BY avg_clv DESC;


-- Churn behavior by segment
SELECT
    clv_segment,
    COUNT(*) AS total_customers,
    SUM(churn_flag) AS churned_customers,
    ROUND(SUM(churn_flag) / COUNT(*) * 100, 2) AS churn_rate_pct,
    ROUND(SUM(clv_value), 2) AS total_clv_value
FROM customer_clv_segmented
GROUP BY clv_segment
ORDER BY total_clv_value DESC;

