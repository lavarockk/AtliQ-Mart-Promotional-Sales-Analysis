CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost`
  SQL SECURITY DEFINER VIEW `revenue_view` AS with `cte` as 
  (select `sales_view`.`event_id` AS `event_id`,
  `sales_view`.`store_id` AS `store_id`,
  `sales_view`.`campaign_id` AS `campaign_id`,
  `sales_view`.`product_code` AS `product_code`,
  `sales_view`.`base_price` AS `base_price`,
  `sales_view`.`promo_type` AS `promo_type`,
  `sales_view`.`quantity_sold_before_promo` AS `quantity_sold_before_promo`,
  `sales_view`.`quantity_sold_after_promo` AS `quantity_sold_after_promo`,
  `sales_view`.`base_price_after_promo` AS `base_price_after_promo`,
  `sales_view`.`sales_qty_after_promo` AS `sales_qty_after_promo`,
  `sales_view`.`revenue_before_promo` AS `revenue_before_promo`,
  `sales_view`.`revenue_after_promo` AS `revenue_after_promo`,
  `sales_view`.`sales_diff` AS `sales_diff` 
  from `sales_view`)
  select `cte`.`event_id` AS `event_id`,
  `cte`.`store_id` AS `store_id`,
  `cte`.`campaign_id` AS `campaign_id`,
  `cte`.`product_code` AS `product_code`,
  `cte`.`base_price` AS `base_price`,`cte`.
  `promo_type` AS `promo_type`,
  `cte`.`quantity_sold_before_promo` AS `quantity_sold_before_promo`,
  `cte`.`quantity_sold_after_promo` AS `quantity_sold_after_promo`,
  `cte`.`base_price_after_promo` AS `base_price_after_promo`,
  `cte`.`sales_qty_after_promo` AS `sales_qty_after_promo`,
  `cte`.`revenue_before_promo` AS `revenue_before_promo`,
  `cte`.`revenue_after_promo` AS `revenue_after_promo`,
  `cte`.`sales_diff` AS `sales_diff`,
  (`cte`.`revenue_after_promo` - `cte`.`revenue_before_promo`) AS `revenue_diff`
  from `cte`
