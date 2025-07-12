--Easy
--1.a.List the name, country, and launch_date of all apps where active = TRUE.SELECT name, country, launch_date
SELECT name, country, launch_date
FROM Apps
WHERE active = TRUE;

--1.b.Retrieve each user_id, name, and subscription_type for users with a "PREMIUM" subscription.
SELECT user_id, name, subscription_type
FROM Users
WHERE subscription_type = 'PREMIUM';

--1.c.Show the restaurant name, menu item name, and price for all items where available = TRUE.
SELECT r.name AS restaurant_name, m.name AS menu_item_name, m.price
FROM MenuItems m
JOIN Restaurants r ON m.restaurant_id = r.restaurant_id
WHERE m.available = TRUE;


--Medium
--2. a. Restaurant Ratings
--For each restaurant, calculate its average review rating. Return restaurant_id, restaurant name, and AVG(rating), including only restaurants with at least one review.
SELECT r.restaurant_id, r.name, AVG(rv.rating) AS avg_rating
FROM Restaurants r
JOIN Reviews rv ON r.restaurant_id = rv.restaurant_id
GROUP BY r.restaurant_id, r.name;

--2.b. Order Details
--List order_id, user name, restaurant name, courier name (if assigned), status, and total_amount for every order.
SELECT o.order_id, u.name AS user_name, r.name AS restaurant_name, 
       c.name AS courier_name, o.status, o.total_amount
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
LEFT JOIN Couriers c ON o.courier_id = c.courier_id;

--2. c. App Revenues
--For each app, compute the total number of orders and the total revenue (SUM(total_amount)).
--Return app_id, app name, order count, and total revenue, ordered by revenue descending.
SELECT a.app_id, a.name, COUNT(o.order_id) AS order_count, 
       SUM(o.total_amount) AS total_revenue
FROM Apps a
JOIN Orders o ON a.app_id = o.app_id
GROUP BY a.app_id, a.name
ORDER BY total_revenue DESC;

--2. d. Courier Performance
--For each courier, find the number of orders they have delivered and their average delivery time in minutes.
--Return courier_id, courier name, delivered count, and avg delivery duration.
SELECT c.courier_id, c.name,
       COUNT(o.order_id) AS delivered_count,
       AVG(TIMESTAMPDIFF(MINUTE, o.order_time, o.delivered_time)) AS avg_delivery_time
FROM Couriers c
JOIN Orders o ON c.courier_id = o.courier_id
WHERE o.status = 'DELIVERED'
GROUP BY c.courier_id, c.name;


--Hard
--3. a. City Ranking of Restaurants
--Use a window function to rank restaurants within each city by their total order count.
SELECT r.city, r.restaurant_id, r.name,
       COUNT(o.order_id) AS order_count,
       RANK() OVER (PARTITION BY r.city ORDER BY COUNT(o.order_id) DESC) AS city_rank
FROM Restaurants r
LEFT JOIN Orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.city, r.restaurant_id, r.name;

--3. b. Never-Ordered Items
--Identify menu items that have never been ordered.
SELECT m.menu_item_id, m.name
FROM MenuItems m
LEFT JOIN OrderItems oi ON m.menu_item_id = oi.menu_item_id
WHERE oi.menu_item_id IS NULL;

--3. c. Top Revenue Zone
--Determine which delivery zone has generated the highest total order revenue.
SELECT z.name AS zone_name, z.city, SUM(o.total_amount) AS total_revenue
FROM Zones z
JOIN RestaurantZones rz ON z.zone_id = rz.zone_id
JOIN Restaurants r ON rz.restaurant_id = r.restaurant_id
JOIN Orders o ON r.restaurant_id = o.restaurant_id
GROUP BY z.name, z.city
ORDER BY total_revenue DESC
LIMIT 1;
