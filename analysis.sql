SELECT * FROM user_events LIMIT 10;

-- Sales Funnel Analysis
-- define sales funnel stages in the first quarter of 2026

WITH funnel_stages AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
        COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
        COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
    FROM user_events
    WHERE event_date >= '2026-01-01' AND event_date < '2026-04-01'
)
SELECT * FROM funnel_stages;

-- conversion rates through the funnel
WITH funnel_stages AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS stage_1_views,
        COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS stage_2_cart,
        COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS stage_3_checkout,
        COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS stage_4_payment,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS stage_5_purchase
    FROM user_events
    WHERE event_date >= '2026-01-01' AND event_date < '2026-04-01'
)
SELECT 
    ROUND(stage_2_cart * 100 / stage_1_views) AS view_to_cart_rate,
    ROUND(stage_3_checkout * 100 / stage_2_cart) AS cart_to_checkout_rate,
    ROUND(stage_4_payment * 100 / stage_3_checkout) AS checkout_to_payment_rate,
    ROUND(stage_5_purchase * 100 / stage_4_payment) AS paymeny_to_purchase_rate

FROM funnel_stages;


-- funnel by source (where people come from and purchase conversion rate)
WITH source_funnel AS (
    SELECT
    traffic_source,
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS cart,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchase

    FROM user_events
    WHERE event_date >= '2026-01-01' AND event_date < '2026-04-01'
    GROUP BY traffic_source
)
SELECT 
    traffic_source, 
    views, 
    cart,
    purchase,
    ROUND(cart * 100 / views) AS cart_conversion_rate,
    ROUND(purchase * 100 / views) AS purchase_conversion_rate
FROM source_funnel
ORDER BY purchase DESC;


-- time to conversion analysis
WITH user_journey AS (
    SELECT
    user_id,
    MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time,
    MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
    MIN(CASE WHEN event_type = 'purchase' THEN event_date  END) AS purchase_time

    FROM user_events
    WHERE event_date >= '2026-01-01' AND event_date < '2026-04-01'
    GROUP BY user_id  
    HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date  END) IS NOT NULL
)
SELECT 
    COUNT(*) AS converted_users,
    ROUND(AVG(EXTRACT(EPOCH FROM (cart_time - view_time)) / 60), 2) AS avg_view_to_cart_minutes,
    ROUND(AVG(EXTRACT(EPOCH FROM (purchase_time - cart_time)) / 60), 2) AS avg_cart_to_perchase_minutes,
    ROUND(AVG(EXTRACT(EPOCH FROM (purchase_time - view_time)) / 60), 2) AS avg_view_to_perchase_minutes

FROM user_journey;

--- revenue funnal analysis
WITH funnel_revenue AS (
    SELECT
    COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS total_visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,
    SUM(CASE WHEN event_type = 'purchase' THEN amount END) AS total_revenue,
    COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders

    FROM user_events
    WHERE event_date >= '2026-01-01' AND event_date < '2026-04-01'
)
SELECT
    total_visitors,
    total_buyers,
    total_revenue,
    total_orders,
    ROUND(total_revenue/total_orders, 1) AS avg_price_per_order,
    ROUND(total_revenue/total_buyers, 1) AS revenue_per_buyer,
    ROUND(total_revenue/total_visitors, 1) AS revenue_per_visitor

FROM funnel_revenue;