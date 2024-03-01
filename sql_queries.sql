#SQL  AD-HOC BUSINESS REQUESTS 

#1. Provide a list of products with a base price greater than 500 that are featured in the promo type of ‘BOGOF’(Buy One Get One Free). 

SELECT DISTINCT(p.product_name), f.base_price, f.promo_type 
FROM dim_products p
JOIN   fact_events f
USING (product_code)
WHERE f.promo_type = "BOGOF" AND f.base_price > 500
ORDER BY f.base_price DESC;

#2. Generate a report that provides an overview of the number of stores in each city.

SELECT city, count(store_id) as store_count
FROM dim_stores
GROUP BY city
ORDER BY store_count DESC;

#3. Generate a report that displays each campaign along with the total revenue generated before and after the campaign.

select d.campaign_name, CONCAT(ROUND((SUM(rv.revenue_before_promo)/1000000),2),"M") as revenue_before_promo,
CONCAT(ROUND((SUM(rv.revenue_after_promo)/1000000),2),"M") as revenue_after_promo
FROM revenue_view rv
JOIN dim_campaigns d
USING (campaign_id)
GROUP BY d.campaign_name;

#4. . Produce a report that calculates the Incremental Sold Quantity(ISU%) for each category during the Diwali campaign. 
# Additionally, provide rankings for the categories based on their ISU%. 

SELECT p.category, 
ROUND((SUM(rv.sales_diff)/SUM(quantity_sold_before_promo)*100),2) as ISU_percentage,
RANK() OVER(ORDER BY SUM(rv.sales_diff)/SUM(quantity_sold_before_promo) DESC) as ISU_rank
FROM revenue_view rv
JOIN dim_products p
USING (product_code)
WHERE rv.campaign_id = "CAMP_DIW_01"
GROUP BY p.category;


#5. Create a report featuring the top 5 products, ranked by Incremental Revenue Percentage(IR%), across all campaigns.

SELECT p.product_name,  p.category,
ROUND((SUM(rv.revenue_diff)/SUM(revenue_before_promo)*100),2) as IR_percentage
FROM revenue_view rv
JOIN dim_products p
USING (product_code)
GROUP BY p.product_name, p.category
ORDER BY IR_percentage DESC
LIMIT 5;

#Recommended insights
#Store Performance Analysis

#1. Which are the top 10 stores in terms of Incremental revenue(IR) generated from the promotions?

SELECT s.store_id, s.city, CONCAT(ROUND((SUM(rv.revenue_diff)/1000000),2),"M") as IR
FROM revenue_view rv
JOIN dim_stores s
USING (store_id)
GROUP BY rv.store_id
ORDER BY IR DESC
LIMIT 10;

#2. Which are the bottom 10 stores in terms of Incremental Sold Units(ISU) during the promotional period?

SELECT s.store_id, s.city, SUM(rv.sales_diff) as ISU
FROM revenue_view rv
JOIN dim_stores s
USING (store_id)
GROUP BY rv.store_id
ORDER BY ISU
LIMIT 10;

#3.
SELECT s.city,  s.store_id,
CONCAT(ROUND((SUM(rv.revenue_diff)/1000000),2),"M") as IR,
ROUND((SUM(rv.revenue_diff)/SUM(revenue_before_promo)*100),2) as IR_percentage,
SUM(rv.sales_diff) as ISU, 
ROUND((SUM(rv.sales_diff)/SUM(quantity_sold_before_promo)*100),2) as ISU_percentage,
count(event_id) as events,
avg(base_price), avg(base_price_after_promo), max(rv.promo_type)
FROM revenue_view rv
JOIN dim_stores s
USING (store_id)
GROUP BY s.city, rv.store_id
ORDER BY IR_Percentage DESC
LIMIT 10;

#Promotional Analysis
#1. What are the top 2 promotion types that resulted in the highest Incremental Revenue(IR)?

SELECT promo_type, 
CONCAT(ROUND((SUM(revenue_diff)/1000000),2),"M") as IR
FROM revenue_view 
GROUP BY promo_type
ORDER BY IR DESC
LIMIT 2;

#2. What are the bottom 2 promotion types in terms of their impact on Incremental Sold Units(ISU)?

SELECT promo_type, 
SUM(sales_diff) as ISU
FROM revenue_view 
GROUP BY promo_type
ORDER BY ISU
LIMIT 2;

#3. Is there any significant difference in the performance of discount–based promotions versus BOGOF(But One Get One Free) or cashback promotions?

SELECT promo_type, 
SUM(sales_diff) as ISU, 
ROUND((SUM(sales_diff)/SUM(quantity_sold_before_promo)*100),2) as ISU_percentage,
CONCAT(ROUND((SUM(revenue_diff)/1000000),2),"M") as IR,
ROUND((SUM(revenue_diff)/SUM(revenue_before_promo)*100),2) as IR_percentage
FROM revenue_view 
GROUP BY promo_type
ORDER BY ISU DESC;

#4. Which promotions strike the best balance between Incremental Sold Units and maintaining healthy margins?

SELECT promo_type, 
SUM(sales_diff) as ISU, 
ROUND((SUM(sales_diff)/SUM(quantity_sold_before_promo)*100),2) as ISU_percentage,
CONCAT(ROUND((SUM(revenue_diff)/1000000),2),"M") as IR,
ROUND((SUM(revenue_diff)/SUM(revenue_before_promo)*100),2) as IR_percentage
FROM revenue_view 
GROUP BY promo_type
ORDER BY ISU DESC;

#product and category analysis
#1.Which product categories saw the most significant lift in sales from promotions?

SELECT p.category, 
SUM(rv.sales_diff) as ISU
FROM revenue_view rv
JOIN dim_products p
USING (product_code)
GROUP BY p.category
ORDER BY ISU DESC;


#2. Are there specific products that respond exceptionally well or poorly to promotions?

SELECT p.product_name, 
ROUND((SUM(rv.sales_diff)/SUM(rv.quantity_sold_before_promo)*100),2) as ISU_percentage,
ROUND((SUM(rv.revenue_diff)/SUM(rv.revenue_before_promo)*100),2) as IR_percentage
FROM revenue_view rv
JOIN dim_products p
USING (product_code)
GROUP BY p.product_name
ORDER BY IR_percentage DESC
LIMIT 5;

SELECT p.product_name, 
ROUND((SUM(rv.sales_diff)/SUM(rv.quantity_sold_before_promo)*100),2) as ISU_percentage,
ROUND((SUM(rv.revenue_diff)/SUM(rv.revenue_before_promo)*100),2) as IR_percentage
FROM revenue_view rv
JOIN dim_products p
USING (product_code)
GROUP BY p.product_name
ORDER BY IR_percentage
LIMIT 5;







