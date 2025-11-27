SELECT
  ad_id,
  COUNT(*) AS total_views,
  SUM(CASE WHEN successful THEN 1 ELSE 0 END) AS successful_views,
  AVG(CASE WHEN successful THEN 1.0 ELSE 0.0 END) AS success_rate
FROM ad_views
GROUP BY ad_id
ORDER BY total_views DESC;