CAPSTONE PROJECT

Count number of campaigns:
SELECT COUNT(DISTINCT utm_campaign) AS 'campaign count'
FROM page_visits;

Count number of sources:
SELECT COUNT(DISTINCT utm_source) AS 'source count' 
FROM page_visits;

Establish unique campaigns and which sources are linked to them:
SELECT DISTINCT utm_campaign AS Campaigns, utm_source AS Sources
FROM page_visits;

Which pages are on the website?
SELECT DISTINCT page_name
FROM page_visits;

How many first touches is each campaign responsible for?
WITH first_touch AS (SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
    ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS Source,
       ft_attr.utm_campaign AS Campaign,
       COUNT(*) AS Count
FROM ft_attr
GROUP BY 1, 2

How many last touches is each campaign responsible for?
WITH last_touch AS (SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
    lt_attr AS (
	SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
      pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS Source,
       lt_attr.utm_campaign AS Campaign,
       COUNT(*) AS Count
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

How many visitors make a purchase?
SELECT COUNT (distinct user_id) as 'Vistors who purchase'
FROM page_visits
WHERE page_name = '4 - purchase';

How many last touches on the purchase page is each campaign responsible for?

WITH last_touch AS (SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
    ft_attr AS (
	SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
      pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS Source,
       ft_attr.utm_campaign AS Campaign,
       COUNT(*) AS Count
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

Optimizing the budget?
Count visitors and group by source - determine which sources attract most users/generate traffic

SELECT
utm_source as 'Source',
COUNT (distinct user_id) as 'Count Visitors'
FROM page_visits 
GROUP BY source
ORDER BY 2 DESC;




