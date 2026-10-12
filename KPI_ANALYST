--Dataset Profile

SELECT
  COUNT(*)                      AS total_rows,
  COUNT(DISTINCT retailer)      AS retailers,
  COUNT(DISTINCT region)        AS regions,
  COUNT(DISTINCT state)         AS states,
  COUNT(DISTINCT city)          AS cities,
  COUNT(DISTINCT product)       AS products,
  COUNT(DISTINCT sales_method)  AS sales_methods,
  MIN(invoice_date)             AS first_date,
  MAX(invoice_date)             AS last_date
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`;



-- All KPI INFORMATION 

SELECT
  ROUND(SUM(total_sales), 2)                                          AS revenue,
  ROUND(SUM(operating_profit), 2)                                     AS profit,
  SUM(units_sold)                                                     AS units,
  COUNT(*)                                                            AS transactions,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2) AS margin_pct,
  ROUND(SAFE_DIVIDE(SUM(total_sales), SUM(units_sold)), 2)            AS avg_price_per_unit,
  ROUND(SAFE_DIVIDE(SUM(total_sales), COUNT(*)), 2)                   AS avg_revenue_per_transaction
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`;



--Weighted margin vs simple average of row margins
SELECT
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2)  AS weighted_margin_pct,
  ROUND(AVG(SAFE_DIVIDE(operating_profit, total_sales)) * 100, 2)       AS simple_avg_margin_pct,
  SUM(CASE WHEN total_sales = 0 THEN 1 ELSE 0 END)                      AS rows_with_zero_sales
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`;



--Check null value in profit/ units
SELECT*
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
WHERE units_sold = 0 AND operating_profit <= 0;



--Check total_sales must equal price * units 
 SELECT SUM(CASE WHEN ROUND(total_sales, 2) != ROUND(price_per_unit * units_sold, 2) THEN 1 ELSE 0 END) AS mismatches
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`;



--Plausibility: row-level margin should sit between 10% and 80%.
--     Rows outside this band usually mean a scale or unit problem in the raw data.
SELECT
  SUM(CASE WHEN SAFE_DIVIDE(operating_profit, total_sales) < 0.10 THEN 1 ELSE 0 END) AS margin_below_10pct,
  SUM(CASE WHEN SAFE_DIVIDE(operating_profit, total_sales) > 0.80 THEN 1 ELSE 0 END) AS margin_above_80pct,
  ROUND(MIN(SAFE_DIVIDE(operating_profit, total_sales)) * 100, 1)                    AS min_row_margin_pct,
  ROUND(MAX(SAFE_DIVIDE(operating_profit, total_sales)) * 100, 1)                    AS max_row_margin_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`;



-- Typo check: list every value of a category column with its row count.
--     A value that appears only once or twice next to a near-identical one is a typo.
SELECT product, COUNT(*) AS row_count
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY product
ORDER BY row_count DESC;

