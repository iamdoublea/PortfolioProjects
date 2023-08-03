**** Creating a Custom Zomato Dataset for EDA ****

drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);



drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);




select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;


* EDA STARTS *

*** The total amount each customer is spending on Zomato ***

SELECT
DISTINCT userid,
SUM(price) OVER (PARTITION BY userid) AS total_spend
FROM
sales AS S
JOIN
product AS P
ON P.product_id = S.product_id

OR 

SELECT
userid,
SUM(price) AS total_spend
FROM
sales AS S
JOIN
product AS P
ON P.product_id = S.product_id
GROUP BY
userid


*** How many days has each customer visited Zomato ***

SELECT
userid,
COUNT(DISTINCT created_date) AS days_visited
FROM 
sales
GROUP BY
userid


*** What was the first product purchased by each of the customer ***

SELECT
userid,
product_id,
created_date
FROM
(SELECT
userid,
P.product_id,
created_date,
RANK() OVER (PARTITION BY userid ORDER BY created_date) AS order_rank
FROM
sales AS S
JOIN
product AS P
ON P.product_id = S.product_id) AS new
WHERE
order_rank = 1


*** What is the most purchased item in the menu and how many times it has been purchased by the customers ***

SELECT
userid,
COUNT(product_id) AS purchase_count
FROM
sales
WHERE
product_id = 
(SELECT
TOP 1 product_id
FROM
sales
GROUP BY
product_id
ORDER BY
COUNT(product_id) DESC)
GROUP BY
userid


*** Which item was the most popular for each of the customer ***


SELECT
userid,product_id
FROM
(SELECT
*,
RANK() OVER (PARTITION BY userid ORDER BY purchase_count DESC) AS ranks
FROM
(SELECT
userid,
product_id,
COUNT(product_id) AS purchase_count
FROM
Sales
GROUP BY
userid,
product_id) AS new1) AS new2
WHERE
ranks = 1



*** Which item was purchased first by the customer after they became a member ***

SELECT
userid,
product_id
FROM
(SELECT
*,
RANK() OVER(PARTITION BY userid ORDER BY created_date) AS order_rank
FROM 
(SELECT
S.userid,created_date,gold_signup_date,product_id
FROM
sales AS S
JOIN
goldusers_signup AS G
ON S.userid = G.userid
AND
created_date >= gold_signup_date) AS new) AS final
WHERE
order_rank = 1



*** Which item was purchased just before the customer became a member ***

SELECT
userid,
product_id
FROM
(SELECT
*,
RANK() OVER(PARTITION BY userid ORDER BY created_date DESC) AS order_rank
FROM 
(SELECT
S.userid,created_date,gold_signup_date,product_id
FROM
sales AS S
JOIN
goldusers_signup AS G
ON S.userid = G.userid
AND
created_date < gold_signup_date) AS new) AS final
WHERE
order_rank = 1



*** What is the total order and amount spend for each user before then become a member ***

SELECT
userid,
SUM(total_order) AS total_orders,
SUM(amt) AS total spend
FROM (SELECT
userid,
total_order,
(total_order * price) AS amt
FROM (SELECT
S.userid,product_id,
COUNT(S.userid) AS total_order
FROM
sales AS S
JOIN
goldusers_signup AS G
ON S.userid = G.userid
AND
created_date < gold_signup_date
GROUP BY
S.userid,product_id) AS A
JOIN
product AS P
ON A.product_id = P.product_id) AS final
GROUP BY
userid


*** If buying each product generates point, example: Rs.5 = 2 Zomato points and each product has different purchasing points,
example: for pr 1 , for every Rs. 5 = 1 Zomato point; for pr 2 , for Rs.10 = 5 Zomato points; for pr 3, for Rs.5 = 1 Zomato points.

Calculate the points collected by each customers and for which products most points have been collected till now  ***


SELECT
userid,
SUM(points) AS total_points
FROM
(SELECT
*,
(CASE
  WHEN product_id = 1 THEN (multiples * 1)
  WHEN product_id = 2 THEN (multiples * 5)
  ELSE (multiples * 1)
END) AS points
FROM
(SELECT
*,
(CASE
  WHEN product_id = 1 THEN (spend/5)
  WHEN product_id = 2 THEN (spend/10)
  ELSE (spend/5)
END) multiples
FROM 
(SELECT
*,
(price * purcahse_cnt) AS spend
FROM
(SELECT
userid,
S.product_id,
COUNT(S.product_id) AS purcahse_cnt,
price
FROM
sales AS S
JOIN 
product AS P
ON S.product_id = P.product_id
GROUP BY
S.product_id,userid,price) AS A) AS B) AS C) AS D
GROUP BY
userid



SELECT TOP 1
product_id
FROM
(SELECT
*,
(CASE
  WHEN product_id = 1 THEN (multiples * 1)
  WHEN product_id = 2 THEN (multiples * 5)
  ELSE (multiples * 1)
END) AS points
FROM
(SELECT
*,
(CASE
  WHEN product_id = 1 THEN (spend/5)
  WHEN product_id = 2 THEN (spend/10)
  ELSE (spend/5)
END) multiples
FROM 
(SELECT
*,
(price * purcahse_cnt) AS spend
FROM
(SELECT
userid,
S.product_id,
COUNT(S.product_id) AS purcahse_cnt,
price
FROM
sales AS S
JOIN 
product AS P
ON S.product_id = P.product_id
GROUP BY
S.product_id,userid,price) AS A) AS B) AS C) AS D
ORDER BY
points DESC



*** In the first one year after customer joins the gold program ( including their joining date ) irrespective of what the customer has purchased they earn 5 zomato points for every 10 Rs spent.
Who earned more? and What was their earned point in their first year. ***

SELECT
userid, B.product_id,(price * 0.5) AS points
FROM
(SELECT
*
FROM
(SELECT
S.userid,product_id,created_date,gold_signup_date,
DATEDIFF(day, gold_signup_date,created_date) AS date_diff
FROM
sales AS S
JOIN
goldusers_signup AS G
ON S.userid = G.userid
WHERE
gold_signup_date <= created_date) AS A
WHERE
date_diff <= 365) AS B
JOIN
product AS P
ON B.product_id = P.product_id



*** Rank all transactions of the customer ***

SELECT
*,
RANK() OVER (PARTITION BY userid ORDER BY created_date ) AS ranks
FROM
sales



*** Rank all the transactions for each member whenever they are a zomato gold member. For every non gold member transaction mark as NA ***

SELECT
*,
(CASE
  WHEN rank2 = 0 THEN 'N.A.'
  ELSE rank2
END) AS final_rank
FROM
(SELECT
*,
CAST((CASE
  WHEN gold_signup_date IS NULL THEN 0
  ELSE rank1
END) AS varchar) AS rank2
FROM
(SELECT 
S.userid, created_date, gold_signup_date,
RANK() OVER (PARTITION BY S.userid ORDER BY created_date DESC) AS rank1
FROM
sales AS S
LEFT JOIN
goldusers_signup AS G
ON S.userid = G.userid
AND 
gold_signup_date <= created_date) AS A) AS B