
-- Use 'INTERSECT' to  returns only apps with same price that presents in both tables.

SELECT name,price::money
FROM public.app_store_apps AS a
INTERSECT 
SELECT name,price::money
FROM public.play_store_apps
ORDER BY price DESC;

--Use 'INTERSECT' to returns only apps that presents in both tables.

SELECT name
FROM public.app_store_apps
INTERSECT
SELECT name
FROM public.play_store_apps;


--Number of Apps by price range in app store table

SELECT COUNT (price) AS num_of_apps_in_appstore,
       CASE WHEN price >=0.00 AND price <=1.00 THEN '$0.00-1.00'
	        WHEN price >= 1.01 AND price <=10.00 THEN '$1.01-10.00'
			ELSE '$11.00 or above' END AS price_range_appstore
FROM public.app_store_apps
GROUP BY price_range_appstore
ORDER BY num_of_apps_in_appstore;


--Number of Apps by price range in playstore

SELECT COUNT (price) AS num_of_apps_in_playtore,
       CASE WHEN trim(price,'$')::numeric <=1.00 THEN '$0.00-1.00'
	        WHEN trim(price,'$')::numeric >= 1.01 AND trim(price,'$')::numeric <=10.00 THEN '$1.01-10.00'
			ELSE '$11 or above' END AS price_range_playstore
FROM public.play_store_apps
GROUP BY price_range_playstore;

			
--TOP 5 genre Based on Appstore--

SELECT  primary_genre, COUNT(*) as num_apps
FROM public.app_store_apps
GROUP BY primary_genre
ORDER BY num_apps DESC
LIMIT 5;

--Only paid/app-in-purchase apps in Appstore

SELECT name,price::numeric::money AS avg_price,rating
FROM public.app_store_apps
WHERE price > 0.00
      AND rating >4
ORDER BY rating DESC


-- TOP 5 genre Based on Playstore
 
SELECT  DISTINCT genres, COUNT(*) as num_apps
FROM public.play_store_apps
GROUP BY genres 
ORDER BY num_apps DESC
LIMIT 5;

--Only paid/app in purchase Apps in playstore 

SELECT name,type, AVG(trim(price, '$')::numeric) AS avg_price,rating
FROM public.play_store_apps
WHERE genres ILIKE 'TOOLS'
     AND type ILIKE 'Paid'
     AND rating >=4
GROUP BY name,type,rating
ORDER BY rating DESC

-- Apps based on avg review ratings by content ratings in appstore

SELECT name,AVG(rating) AS avg_ratings,content_rating
FROM public.app_store_apps
WHERE rating >=4
GROUP BY name,content_rating
ORDER BY avg_ratings DESC


--Apps based on avg review ratings by content ratings in playstore

SELECT name,AVG(rating) AS avg_ratings,content_rating
FROM public.play_store_apps
WHERE rating >=4
GROUP BY name,content_rating
ORDER BY avg_ratings DESC;


--Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.

SELECT p.name, a.name, a.primary_genre, p .genres, a.review_count, p.install_count,
	avg_table.avg_rating1, avg_table.avg_price1, ((48000*(1+(avg_table.avg_rating1)*2))-25000) as profit
FROM app_store_apps as a
INNER JOIN play_store_apps as p
	USING(name)
INNER JOIN (SELECT ROUND((a1.price + p1.price::money::numeric)/2, 2) as avg_price1, cast(round((p1.rating+a1.rating)*2,0)/4 as decimal(3,2)) as avg_rating1, a1.name
			FROM app_store_apps as a1
		    INNER JOIN play_store_apps as p1
		    USING(name)) as avg_table
USING(name)
WHERE cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) > 4
	AND ROUND((a.price + p.price::money::numeric)/2, 2) <= 2.50
	AND (a.review_count::numeric > 5000 or p.review_count::numeric > 5000)
GROUP BY p.name, a.name, p.genres, a.primary_genre, p.rating, a.rating, p.price, a.price,a.review_count, p.install_count, avg_table.avg_rating1, avg_table.avg_price1
ORDER BY cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) desc
LIMIT 10;
								
	
	
--Top 4 Develop a Top 4 list of the apps that App Trader.

SELECT p.name AS name_playstore, a.name AS name_appstore, a.primary_genre, p .genres, a.review_count, p.install_count,
	cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) as avg_rating,
	ROUND((a.price + p.price::money::numeric)/2, 2) as avg_price
FROM app_store_apps as a
INNER JOIN play_store_apps as p
USING(name)
WHERE cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) > 3
	  AND ROUND((a.price + p.price::money::numeric)/2, 2) <= 2.50
	  AND (a.review_count::numeric > 2000 or p.review_count::numeric > 2000)
	  AND (genres ilike '%food%' or primary_genre ilike'%food%')
GROUP BY p.name, a.name, p.genres, a.primary_genre, p.rating, a.rating, p.price, a.price,a.review_count, p.install_count
ORDER BY cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) desc
LIMIT 4;
		

	
	
	

	
	
	