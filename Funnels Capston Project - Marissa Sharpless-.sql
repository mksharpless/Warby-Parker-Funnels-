--Quiz Funnel Question 1: Get to know the table/columns-- 
SELECT *
FROM survey
LIMIT 10; 

--Quiz Funnel Question 2: Quiz Funnel analyzing user moving between question 1 and question 2--

SELECT question, count(distinct user_id) AS "Number of User Responses"
FROM survey
GROUP BY question
ORDER BY question ASC;

--Home Try-On Funnel Question 4--
SELECT *
FROM home_try_on
LIMIT 5;
-- Answer - Column Names: user_id, number_of_pairs, address-- 
 
--Home Try-On Funnel Question 5 (Joining 3 tables)--
SELECT DISTINCT q.user_id, h.user_id IS NOT NULL AS 'is_home_try_on', h.number_of_pairs, p.user_ID IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id
Limit 10; 

--Start Insihgts # of people from quiz to home try on, # of people from home try on to purchase-- 
WITH funnels AS (SELECT DISTINCT q.user_id, h.number_of_pairs, h.user_id IS NOT NULL AS 'is_home_try_on', p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id)
SELECT COUNT(user_id) AS 'Funnels',
	SUM(is_home_try_on) AS 'Number Home Try On',
  SUM(is_purchase) AS 'Number Purchases'
FROM funnels;
--# of funnels is 1000. home_try_on is 750. 496 ppl purchased.-- 

--Funnel conversion comparison rates-- 
WITH funnels AS (SELECT DISTINCT q.user_id, h.number_of_pairs, h.user_id IS NOT NULL AS 'is_home_try_on', p.user_ID IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id)
SELECT COUNT(user_id) AS 'funnels',
	SUM(is_home_try_on) AS 'ppl_home_try_on',
  SUM(is_purchase) AS "num_purchases",
  1.0 * SUM(is_home_try_on) / COUNT(user_id) As "Quiz to Home Try On Rate", 1.0 * SUM(is_purchase) / SUM(is_home_try_on) AS "Home to Purchase Rate"
FROM funnels;
--% of quiz to home try on is 75%% of try on to purchase is 66%-- 

--Conversation rate of quiz to purchase--
WITH funnels AS ( SELECT DISTINCT q.user_id, h.number_of_pairs, h.user_id IS NOT NULL AS 'is_home_try_on', p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id)
SELECT COUNT(user_id) AS 'funnels',
	SUM(is_home_try_on) AS 'ppl_home_try_on',
  SUM(is_purchase) AS "num_purchases",
  1.0 * SUM(is_purchase) / COUNT(user_id) As "Overall Conversion Rate From Quiz"
FROM funnels;
--Conversation rate of quiz to purchase: 49.5%--


---Common results of the style quiz (COLOR)--
WITH funnels AS (SELECT DISTINCT q.user_id, h.number_of_pairs, p.color, h.user_id IS NOT NULL AS 'is_home_try_on', p.user_ID IS NOT NULL AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id)
SELECT color, count (color) AS 'Purchase Count'
FROM funnels
WHERE is_purchase=1
GROUP BY color
ORDER BY COUNT(color) DESC;


--Most popular models--
WITH funnels AS (SELECT DISTINCT q.user_id, h.number_of_pairs, p.color, h.user_id IS NOT NULL AS 'is_home_try_on', p.user_ID IS NOT NULL AS 'is_purchase', p.model_name, p.style, p.product_id
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id)
SELECT product_id, model_name, style, color, count (is_purchase) AS 'Number Sold'
FROM funnels
WHERE product_id IS NOT NULL
GROUP BY product_id
ORDER BY count (is_purchase) DESC;

--Average # of pairs taken home to convert-- 
WITH funnels AS (SELECT DISTINCT q.user_id, h.user_id IS NOT NULL AS 'is_home_try_on', p.user_id IS NOT NULL AS 'is_purchase', h.number_of_pairs
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON q.user_id = h.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = q.user_id)
SELECT AVG (number_of_pairs) AS 'Average Number of Pairs for Conversion'
FROM funnels
WHERE is_purchase=1; 
  
   