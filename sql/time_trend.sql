-- Q1. Monthly series with month-over-month change
WITH monthly AS (
  SELECT
    DATE_TRUNC(invoice_date, MONTH)  AS month,
    COUNT(*)                         AS transactions,
    SUM(total_sales)                 AS revenue,
    SUM(operating_profit)            AS profit
  FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
  GROUP BY month
)
SELECT
  month,
  transactions,
  ROUND(revenue, 0)                                              AS revenue,
  ROUND(profit, 0)                                               AS profit,
  ROUND(SAFE_DIVIDE(profit, revenue) * 100, 2)                   AS margin_pct,
  ROUND(SAFE_DIVIDE(revenue, transactions), 0)                   AS avg_revenue_per_transaction,
  ROUND(SAFE_DIVIDE(revenue - LAG(revenue) OVER (ORDER BY month),
                    LAG(revenue) OVER (ORDER BY month)) * 100, 1) AS revenue_mom_pct
FROM monthly
ORDER BY month;

-- Q2. Year-level comparison using only volume-independent metrics
SELECT
  EXTRACT(YEAR FROM invoice_date)                                       AS year,
  COUNT(*)                                                              AS transactions,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2)  AS margin_pct,
  ROUND(SAFE_DIVIDE(SUM(total_sales), SUM(units_sold)), 2)              AS avg_price_per_unit,
  ROUND(SAFE_DIVIDE(SUM(total_sales), COUNT(*)), 0)                     AS avg_revenue_per_transaction
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY year
ORDER BY year;

-- Q3. Same-month comparison, 2020 next to 2021 (average revenue per transaction)
SELECT
  EXTRACT(MONTH FROM invoice_date) AS month_number,
  ROUND(SAFE_DIVIDE(
    SUM(CASE WHEN EXTRACT(YEAR FROM invoice_date) = 2020 THEN total_sales END),
    SUM(CASE WHEN EXTRACT(YEAR FROM invoice_date) = 2020 THEN 1 END)), 0) AS avg_rev_per_txn_2020,
  ROUND(SAFE_DIVIDE(
    SUM(CASE WHEN EXTRACT(YEAR FROM invoice_date) = 2021 THEN total_sales END),
    SUM(CASE WHEN EXTRACT(YEAR FROM invoice_date) = 2021 THEN 1 END)), 0) AS avg_rev_per_txn_2021
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY month_number
ORDER BY month_number;

-- Q4. Is the 2021 step change spread evenly or concentrated?
--     Transactions per year x channel and per year x retailer.
SELECT
  EXTRACT(YEAR FROM invoice_date) AS year,
  sales_method,
  COUNT(*)                        AS transactions
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY year, sales_method
ORDER BY year, sales_method;

SELECT
  EXTRACT(YEAR FROM invoice_date) AS year,
  retailer,
  COUNT(*)                        AS transactions
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY year, retailer
ORDER BY retailer, year;

-- Q6. Like-for-like check: only retailer x region combinations present in BOTH years
WITH combos AS (
  SELECT retailer, region
  FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
  GROUP BY retailer, region
  HAVING COUNT(DISTINCT EXTRACT(YEAR FROM invoice_date)) = 2
)
SELECT
  EXTRACT(YEAR FROM s.invoice_date)                                         AS year,
  COUNT(*)                                                                  AS transactions,
  ROUND(SUM(s.total_sales), 0)                                              AS revenue,
  ROUND(SAFE_DIVIDE(SUM(s.operating_profit), SUM(s.total_sales)) * 100, 2)  AS margin_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean` AS s
JOIN combos AS c
  ON s.retailer = c.retailer AND s.region = c.region
GROUP BY year
ORDER BY year;
