-- #3 WHICH PRODUCT HAVE BIG REVENUE BUT THIN MARGIN
WITH by_product AS (
  SELECT
    product,
    SUM(total_sales)       AS revenue,
    SUM(operating_profit)  AS profit,
    SUM(units_sold)        AS units
  FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
  GROUP BY product
)
SELECT
  product,
  ROUND(revenue, 0)                                       AS revenue,
  ROUND(profit, 0)                                        AS profit,
  ROUND(SAFE_DIVIDE(profit, revenue) * 100, 2)            AS margin_pct,
  ROUND(SAFE_DIVIDE(revenue, units), 2)                   AS avg_price_per_unit,
  RANK() OVER (ORDER BY revenue DESC)                     AS revenue_rank,
  RANK() OVER (ORDER BY profit DESC)                      AS profit_rank,
  RANK() OVER (ORDER BY SAFE_DIVIDE(profit, revenue) DESC) AS margin_rank
FROM by_product
ORDER BY revenue_rank;

-- Q2. Retailer ranks
WITH by_retailer AS (
  SELECT
    retailer,
    SUM(total_sales)       AS revenue,
    SUM(operating_profit)  AS profit,
    SUM(units_sold)        AS units
  FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
  GROUP BY retailer
)
SELECT
  retailer,
  ROUND(revenue, 0)                                       AS revenue,
  ROUND(profit, 0)                                        AS profit,
  ROUND(SAFE_DIVIDE(profit, revenue) * 100, 2)            AS margin_pct,
  ROUND(SAFE_DIVIDE(revenue, units), 2)                   AS avg_price_per_unit,
  RANK() OVER (ORDER BY revenue DESC)                     AS revenue_rank,
  RANK() OVER (ORDER BY profit DESC)                      AS profit_rank,
  RANK() OVER (ORDER BY SAFE_DIVIDE(profit, revenue) DESC) AS margin_rank
FROM by_retailer
ORDER BY revenue_rank;

-- Product x retailer combinations: best and worst margins with enough volume
--     HAVING keeps only combinations with at least 30 transactions,
--     so a handful of lucky or unlucky rows does not drive the ranking.
SELECT
  product,
  retailer,
  COUNT(*)                                                         AS transactions,
  ROUND(SUM(total_sales), 0)                                       AS revenue,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2) AS margin_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY product, retailer
HAVING COUNT(*) >= 30
ORDER BY margin_pct ASC
LIMIT 10;
