-- WHAT REGION MOST BUY THE PRODUCT ?
SELECT
  region,
  ROUND(SUM(total_sales), 0)                                              AS revenue,
  ROUND(SUM(operating_profit), 0)                                         AS profit,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2)    AS margin_pct,
  SUM(units_sold)                                                         AS units,
  ROUND(SAFE_DIVIDE(SUM(total_sales), SUM(SUM(total_sales)) OVER ()) * 100, 2) AS revenue_share_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY region
ORDER BY revenue DESC;

-- WHICH RETAILER MOST HIGH IN SALES ?
SELECT
  retailer,
  ROUND(SUM(total_sales), 0)                                              AS revenue,
  ROUND(SUM(operating_profit), 0)                                         AS profit,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2)    AS margin_pct,
  SUM(units_sold)                                                         AS units,
  ROUND(SAFE_DIVIDE(SUM(total_sales), SUM(SUM(total_sales)) OVER ()) * 100, 2) AS revenue_share_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY retailer
ORDER BY revenue DESC;

-- WHICH PRODUCT MOST SALES IN ADIDAS ?
SELECT
  product,
  ROUND(SUM(total_sales), 0)                                              AS revenue,
  ROUND(SUM(operating_profit), 0)                                         AS profit,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2)    AS margin_pct,
  SUM(units_sold)                                                         AS units,
  ROUND(SAFE_DIVIDE(SUM(total_sales), SUM(SUM(total_sales)) OVER ()) * 100, 2) AS revenue_share_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY product
ORDER BY revenue DESC;

--  Top 10 states
SELECT
  state,
  ROUND(SUM(total_sales), 0)                                              AS revenue,
  ROUND(SUM(operating_profit), 0)                                         AS profit,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2)    AS margin_pct,
  ROUND(SAFE_DIVIDE(SUM(total_sales), SUM(SUM(total_sales)) OVER ()) * 100, 2) AS revenue_share_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY state
ORDER BY revenue DESC
LIMIT 10;

-- Q5. Concentration: share of revenue from the top 3 retailers
WITH by_retailer AS (
  SELECT retailer, SUM(total_sales) AS revenue
  FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
  GROUP BY retailer
),
ranked AS (
  SELECT retailer, revenue, RANK() OVER (ORDER BY revenue DESC) AS rnk
  FROM by_retailer
)
SELECT
  ROUND(SAFE_DIVIDE(SUM(CASE WHEN rnk <= 3 THEN revenue END), SUM(revenue)) * 100, 2) AS top3_revenue_share_pct
FROM ranked;

-- Reconciliation: groups must add back to the Q2 total of file 02
SELECT
  ROUND(SUM(revenue), 2) AS revenue_across_regions
FROM (
  SELECT region, SUM(total_sales) AS revenue
  FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
  GROUP BY region
);
