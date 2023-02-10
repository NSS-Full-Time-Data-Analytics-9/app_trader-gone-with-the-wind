SELECT *
FROM app_store_apps
FULL JOIN play_store_apps
USING (name)

--17,709 apps but lots of nulls in size_bytes, currency, price, review_count, rating, content_rating, primary_genre

SELECT genres, primary_genre
FROM play_store_apps
FULL JOIN app_store_apps
USING (name)
GROUP BY genres, primary_genre

--215 genres in both tables

SELECT DISTINCT currency
FROM app_store_apps

--only currency is USD

--See which apps are the cheapest with highest/most ratings

--app_store_apps--
SELECT name, price::money, rating, primary_genre, review_count::numeric
FROM app_store_apps
WHERE price < .99 AND rating > 4.5
ORDER BY review_count DESC

SELECT name, price::money, rating, primary_genre, SUM(review_count::numeric) as review
FROM app_store_apps
WHERE price < 2.50 AND rating > 4.5
GROUP BY name, price::money, rating, primary_genre
ORDER BY review DESC

--top 5 are head soccer, sniper 3D assassin, geometry dash lite, domino's pizza, CSR Racing 2

--play_store_apps--
SELECT SUM(review_count) AS review,
	name, price::money, rating, genres
FROM play_store_apps
WHERE price::money < '.99' AND rating > 4.5
GROUP BY play_store_apps.name, play_store_apps.price::money, play_store_apps.rating, play_store_apps.genres
ORDER BY review DESC
LIMIT 5;

Top were Clash of Clans, Clash Royale, Sniper 3D Gun Shooter, duolingo, clean masters

--Return on investment or ROI = (net income / cost of investment) x 100
--apps earn average of $5000 per month - $1000 to market so $4000 net income
--free apps cost $25,000 to buy so 4000/25000 x 100 = 16% ROI

--if app is $3.00 then costs $30,000 so 4000/30000 x 100 = 13%
--apps under $3.00 have best ROI as they cost $25,000 to purchase
-- if app is $5.00 then costs $50,000 so 4000/50,000 x 100 = 8%
--if app is $7.00 then costs $70,000 so 4000/70,000 x 100 = 5.7%


--whats a good roi? online it said %10

--Profit = revenue - expenses

--How much is average cost per app?
--app_store_apps

SELECT CAST(AVG(price) AS money)
FROM app_store_apps
WHERE price IS NOT NULL

--$1.73

SELECT CAST(AVG(price) AS money)
FROM play_store_apps
WHERE price IS NOT NULL
 
 --(48,000) x (1+(rounded rating*2) - (10,000 x price OR 25k)
 --528,000 - (250,000) = $278,000 profit -- if free - $3.00 and with 5 star rating
 
--app prices and ratings ordered by highest prices
SELECT app_store_apps.price::money AS app_price, 
		play_store_apps.price::money AS play_price, 														 	         app_store_apps.rating AS app_rating,
		play_store_apps.rating AS play_rating,
		name
FROM app_store_apps
FULL JOIN play_store_apps
USING (name)
WHERE app_store_apps.price IS NOT NULL 
AND app_store_apps.rating IS NOT NULL 
AND play_store_apps.price::money IS NOT NULL
ORDER BY app_price DESC



--1 year = 0 rating                         so 5 rating = 11 years
--1 year 6 months = .25 rating               
--2 years = .50 rating
--2 years 6 months = .75 rating
--3 year = 1.0 rating
--3 year 6 months = 1.25 rating
--4 years = 1.50 rating
--4 years 6 months = 1.75 rating
--5 years = 2.0 rating 

--revenue--
SELECT (48,000) x (1+(rounded rating*2) - (10,000 x price OR 25k)

SELECT (48000*(1+(rating*2))) - (10000*price) AS revenue
FROM app_store_apps		
				   
SELECT name, price, CASE WHEN price <= 0.00 THEN '25000' 	   
				   ELSE 'other_price' END AS new_prices
FROM app_store_apps
ORDER BY price DESC
				   
				   
SELECT DISTINCT name, app_store_apps.price::money, play_store_apps.price::money, app_store_apps.rating, play_store_apps.rating
FROM app_store_apps
INNER JOIN play_store_apps
USING(name)
WHERE app_store_apps.price <= 2.50
				   
SELECT DISTINCT name, app_store_apps.price::money, play_store_apps.price::money, ROUND((app_store_apps.rating + play_store_apps.rating)/2, 2) AS avg_rating
FROM app_store_apps
INNER JOIN play_store_apps
USING(name)
WHERE app_store_apps.price <= 2.50
				   
--Final query
				   
SELECT p.name, a.name, a.primary_genre, p .genres, p.install_count, a.review_count,
	cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) as avg_rating,
	ROUND((a.price + p.price::money::numeric)/2, 2) as avg_price
	FROM app_store_apps as a
	INNER JOIN play_store_apps as p
	USING(name)
	WHERE cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) > 4
	AND ROUND((a.price + p.price::money::numeric)/2, 2) <= 2.50
	AND (a.review_count::numeric > 5000 or p.review_count > 5000)
	GROUP BY p.name, a.name, p.genres, a.primary_genre, p.rating, a.rating, p.price, a.price, p.install_count, a.review_count
	ORDER BY cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) desc
--for valentine's day, date night with food and drink 
SELECT p.name, a.name, a.primary_genre, p .genres, p.install_count, a.review_count,
	cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) as avg_rating,
	ROUND((a.price + p.price::money::numeric)/2, 2) as avg_price
	FROM app_store_apps as a
	INNER JOIN play_store_apps as p
	USING(name)
	WHERE cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) > 3.5
	AND ROUND((a.price + p.price::money::numeric)/2, 2) <= 2.50
	AND (a.review_count::numeric > 5000 or p.review_count > 5000) AND a.primary_genre ILIKE 'food & drink' OR p.genres ILIKE 'food & drink'
	GROUP BY p.name, a.name, p.genres, a.primary_genre, p.rating, a.rating, p.price, a.price, p.install_count, a.review_count
	ORDER BY cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) desc
--entertainment
SELECT p.name, a.name, a.primary_genre, p .genres, p.install_count, a.review_count,
	cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) as avg_rating,
	ROUND((a.price + p.price::money::numeric)/2, 2) as avg_price
	FROM app_store_apps as a
	INNER JOIN play_store_apps as p
	USING(name)
	WHERE cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) > 3.5
	AND ROUND((a.price + p.price::money::numeric)/2, 2) <= 2.50
	AND (a.review_count::numeric > 5000 or p.review_count > 5000) AND (a.primary_genre ILIKE '%entertainment%') OR (p.genres ILIKE '%entertainment%')
	GROUP BY p.name, a.name, p.genres, a.primary_genre, p.rating, a.rating, p.price, a.price, p.install_count, a.review_count
	ORDER BY cast(round((p.rating+a.rating)*2,0)/4 as decimal(3,2)) desc

	

SELECT name, primary_genre, genres
FROM app_store_apps
INNER JOIN play_store_apps
USING (name)
WHERE primary_genre = 'Lifestyle'