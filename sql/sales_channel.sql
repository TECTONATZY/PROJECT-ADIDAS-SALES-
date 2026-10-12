-- Q1. Channel overview
SELECT
  sales_method,
  COUNT(*)                                                              AS transactions,
  ROUND(SUM(total_sales), 0)                                            AS revenue,
  ROUND(SUM(operating_profit), 0)                                       AS profit,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2)  AS margin_pct,
  SUM(units_sold)                                                       AS units,
  ROUND(SAFE_DIVIDE(SUM(total_sales), COUNT(*)), 0)                     AS avg_revenue_per_transaction,
  ROUND(SAFE_DIVIDE(SUM(total_sales), SUM(units_sold)), 2)              AS avg_price_per_unit,
  ROUND(SAFE_DIVIDE(SUM(total_sales), SUM(SUM(total_sales)) OVER ()) * 100, 2) AS revenue_share_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY sales_method
ORDER BY revenue DESC;

-- Q2. Channel x region: margin and rank of each channel inside every region
SELECT
  region,
  sales_method,
  ROUND(SUM(total_sales), 0)                                             AS revenue,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2)   AS margin_pct,
  RANK() OVER (
    PARTITION BY region
    ORDER BY SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) DESC
  )                                                                      AS margin_rank_in_region
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY region, sales_method
ORDER BY region, margin_rank_in_region;

-- Q3. Channel x product margin
SELECT
  product,
  sales_method,
  ROUND(SUM(total_sales), 0)                                             AS revenue,
  ROUND(SAFE_DIVIDE(SUM(operating_profit), SUM(total_sales)) * 100, 2)   AS margin_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY product, sales_method
ORDER BY product, margin_pct DESC;

-- Q4. Retailer dependence on each channel (share of the retailer's own revenue)
SELECT
  retailer,
  sales_method,
  ROUND(SUM(total_sales), 0) AS revenue,
  ROUND(SAFE_DIVIDE(SUM(total_sales), SUM(SUM(total_sales)) OVER (PARTITION BY retailer)) * 100, 2) AS share_of_retailer_pct
FROM `portofolio-project-510803.Adidas_Clean.Adidas_Clean`
GROUP BY retailer, sales_method
ORDER BY retailer, share_of_retailer_pct DESC;

