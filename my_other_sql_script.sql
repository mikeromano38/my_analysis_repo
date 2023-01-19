-- the query returns a call summary for countries having average call duration > average call duration of all calls
SELECT 
    country.country_name_eng,
    SUM(CASE WHEN call.id IS NOT NULL THEN 1 ELSE 0 END) AS calls,
    AVG(ISNULL(DATEDIFF(SECOND, call.start_time, call.end_time),0)) AS avg_difference
FROM country 
-- we've used left join to include also countries without any call
LEFT JOIN city ON city.country_id = country.id
LEFT JOIN customer ON city.id = customer.city_id
LEFT JOIN call ON call.customer_id = customer.id
GROUP BY 
    country.id,
    country.country_name_eng
-- filter out only countries having an average call duration > average call duration of all calls
HAVING AVG(ISNULL(DATEDIFF(SECOND, call.start_time, call.end_time),0)) > (SELECT AVG(DATEDIFF(SECOND, call.start_time, call.end_time)) FROM call)
ORDER BY calls DESC, country.id ASC;
