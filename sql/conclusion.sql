-- CONCLUSION INSIGHT

-- Q1. Region x product margin (heat-map style table), with volume
SELECT
  region,
  product,
  COUNT(*)                                                              AS transactions,
  ROUND(SUM(total_sales), 0)                                            AS revenue,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2)  AS margin_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY region, product
HAVING COUNT(*) >= 30
ORDER BY margin_pct DESC;

-- Q2. States with the highest and lowest margin (min 100 transactions)
WITH by_state AS (
  SELECT
    state,
    COUNT(*)                                                             AS transactions,
    SUM(total_sales)                                                     AS revenue,
    SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100           AS margin_pct
  FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
  GROUP BY state
  HAVING COUNT(*) >= 100
)
SELECT state, transactions, ROUND(revenue, 0) AS revenue, ROUND(margin_pct, 2) AS margin_pct
FROM by_state
ORDER BY margin_pct DESC;

-- Q3. Price vs margin: does a higher price per unit go with a higher margin?
SELECT
  product,
  ROUND(SAFE_DIVIDE(SUM(total_sales), SUM(units_sold)), 2)               AS avg_price_per_unit,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2)   AS margin_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY product
ORDER BY avg_price_per_unit DESC;
