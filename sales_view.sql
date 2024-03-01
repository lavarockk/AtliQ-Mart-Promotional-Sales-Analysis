CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` 
  SQL SECURITY DEFINER VIEW `sales_view` AS with `cte` as 
  (select `fact_events`.`event_id` AS `event_id`,
  `fact_events`.`store_id` AS `store_id`,
  `fact_events`.`campaign_id` AS `campaign_id`,
  `fact_events`.`product_code` AS `product_code`,
  `fact_events`.`base_price` AS `base_price`,
  `fact_events`.`promo_type` AS `promo_type`,
  `fact_events`.`quantity_sold_before_promo` AS `quantity_sold_before_promo`,
  `fact_events`.`quantity_sold_after_promo` AS `quantity_sold_after_promo`,
  (case 
  when (`fact_events`.`promo_type` = '50% OFF') then (`fact_events`.`base_price` * 0.5)
  when (`fact_events`.`promo_type` = '25% OFF') then (`fact_events`.`base_price` * 0.75) 
  when (`fact_events`.`promo_type` = '33% OFF') then (`fact_events`.`base_price` * 0.67)
  when (`fact_events`.`promo_type` = 'BOGOF') then (`fact_events`.`base_price` * 0.5) 
  when (`fact_events`.`promo_type` = '500 Cashback') then (`fact_events`.`base_price` - 500)
  end) AS `base_price_after_promo`,
  (case 
  when (`fact_events`.`promo_type` = 'BOGOF') then (`fact_events`.`quantity_sold_after_promo` * 2)
  else `fact_events`.`quantity_sold_after_promo` 
  end) AS `sales_qty_after_promo`,
  (`fact_events`.`base_price` * `fact_events`.`quantity_sold_before_promo`) AS `revenue_before_promo`
  from `fact_events`)
  select `cte`.`event_id` AS `event_id`,`
  cte`.`store_id` AS `store_id`,
  `cte`.`campaign_id` AS `campaign_id`,
  `cte`.`product_code` AS `product_code`,
  `cte`.`base_price` AS `base_price`,
  `cte`.`promo_type` AS `promo_type`,
  `cte`.`quantity_sold_before_promo` AS `quantity_sold_before_promo`,
  `cte`.`quantity_sold_after_promo` AS `quantity_sold_after_promo`,
  `cte`.`base_price_after_promo` AS `base_price_after_promo`,
  `cte`.`sales_qty_after_promo` AS `sales_qty_after_promo`,
  `cte`.`revenue_before_promo` AS `revenue_before_promo`,
  (`cte`.`base_price_after_promo` * `cte`.`sales_qty_after_promo`) AS `revenue_after_promo`,
  (`cte`.`sales_qty_after_promo` - `cte`.`quantity_sold_before_promo`) AS `sales_diff`
  from `cte`
