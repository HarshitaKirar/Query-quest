# Project 2 - Food Delivery App Database

## Database Schema

### 1. Apps
```sql
CREATE TABLE Apps (
  app_id        INT PRIMARY KEY,
  name          VARCHAR(50) UNIQUE NOT NULL,
  country       VARCHAR(50) NOT NULL,
  launch_date   DATE NOT NULL,
  active        BOOLEAN DEFAULT TRUE
);

INSERT INTO Apps VALUES
  (1, 'UberEats',   'USA',   '2014-06-12', TRUE),
  (2, 'DoorDash',   'USA',   '2013-02-12', TRUE),
  (3, 'Zomato',     'India', '2008-07-22', TRUE);
```

### 2. Users
```sql
CREATE TABLE Users (
  user_id            INT PRIMARY KEY,
  name               VARCHAR(100) NOT NULL,
  email              VARCHAR(100) UNIQUE NOT NULL,
  signup_date        DATE NOT NULL,
  subscription_type  VARCHAR(20) DEFAULT 'FREE'
);

INSERT INTO Users VALUES
  (1, 'Alice Johnson', 'alice.j@example.com', '2025-01-05', 'PREMIUM'),
  (2, 'Bob Smith',     'bob.smith@example.com', '2025-02-14', 'FREE'),
  (3, 'Carla Diaz',    'carla.d@example.com', '2025-03-20', 'FREE'),
  (4, 'David Li',      'david.li@example.com', '2025-04-02', 'PREMIUM'),
  (5, 'Eva Brown',     'eva.b@example.com', '2025-05-10', 'FREE');
```

### 3. Restaurants
```sql
CREATE TABLE Restaurants (
  restaurant_id   INT PRIMARY KEY,
  app_id          INT,
  name            VARCHAR(100) NOT NULL,
  city            VARCHAR(50),
  phone           VARCHAR(20),
  rating          DECIMAL(2,1) CHECK (rating BETWEEN 0.0 AND 5.0),
  created_date    DATE,
  FOREIGN KEY(app_id) REFERENCES Apps(app_id)
);

INSERT INTO Restaurants VALUES
  (101, 1, 'Spice Hub',        'Chicago', '312-555-0101', 4.5, '2020-06-15'),
  (102, 1, 'Green Bowl',       'Chicago', '312-555-0202', 4.2, '2021-01-10'),
  (103, 2, 'Burger Palace',    'San Francisco','415-555-0333', 4.8, '2019-09-01'),
  (104, 2, 'Sushi World',      'New York', '212-555-0444', 4.6, '2022-03-20'),
  (105, 3, 'Curry King',       'Mumbai',   '022-555-0555', 4.1, '2018-11-11');
```

### 4. Couriers
```sql
CREATE TABLE Couriers (
  courier_id     INT PRIMARY KEY,
  app_id         INT,
  name           VARCHAR(100) NOT NULL,
  vehicle_type   VARCHAR(20),
  onboarding_date DATE,
  active         BOOLEAN DEFAULT TRUE,
  FOREIGN KEY(app_id) REFERENCES Apps(app_id)
);

INSERT INTO Couriers VALUES
  (201, 1, 'Mike Turner',  'Bike',  '2024-06-01', TRUE),
  (202, 1, 'Nina Patel',   'Car',   '2025-01-15', TRUE),
  (203, 2, 'Carlos Ruiz',  'Bike',  '2023-12-05', TRUE),
  (204, 2, 'Sara Lee',     'Scooter','2024-02-20', FALSE),
  (205, 3, 'Raj Sharma',   'Bike',  '2022-08-10', TRUE);
```

### 5. MenuItems
```sql
CREATE TABLE MenuItems (
  menu_item_id   INT PRIMARY KEY,
  restaurant_id  INT,
  name            VARCHAR(100) NOT NULL,
  description     TEXT,
  price           DECIMAL(6,2) CHECK(price >= 0),
  available       BOOLEAN DEFAULT TRUE,
  FOREIGN KEY(restaurant_id) REFERENCES Restaurants(restaurant_id)
);

INSERT INTO MenuItems VALUES
  (301, 101, 'Chicken Tikka Masala',      'Grilled chicken in spiced curry',  12.99, TRUE),
  (302, 101, 'Paneer Butter Masala',      'Cottage cheese in creamy sauce',   11.49, TRUE),
  (303, 102, 'Quinoa Salad',              'Mixed greens with quinoa',          9.99,  TRUE),
  (304, 103, 'Double Cheeseburger',       'Beef patty with cheese',           10.99, TRUE),
  (305, 104, 'Salmon Nigiri',             'Fresh salmon over rice',            8.50,  TRUE),
  (306, 104, 'Tuna Roll',                 'Seaweed roll with tuna',            7.25,  FALSE),
  (307, 105, 'Lamb Rogan Josh',           'Spicy lamb curry',                 13.99, TRUE);
```

### 6. Orders
```sql
CREATE TABLE Orders (
  order_id            INT PRIMARY KEY,
  user_id             INT,
  restaurant_id       INT,
  courier_id          INT,
  app_id              INT,
  order_time          TIMESTAMP,
  delivered_time      TIMESTAMP,
  status              VARCHAR(20) CHECK(status IN ('PENDING','ASSIGNED','DELIVERED','CANCELLED')),
  total_amount        DECIMAL(8,2) CHECK(total_amount >= 0),
  FOREIGN KEY(user_id) REFERENCES Users(user_id),
  FOREIGN KEY(restaurant_id) REFERENCES Restaurants(restaurant_id),
  FOREIGN KEY(courier_id) REFERENCES Couriers(courier_id),
  FOREIGN KEY(app_id) REFERENCES Apps(app_id)
);

INSERT INTO Orders VALUES
  (401, 1, 101, 201, 1, '2025-06-01 12:15:00', '2025-06-01 12:45:00','DELIVERED', 25.48),
  (402, 2, 101, 202, 1, '2025-06-02 18:30:00', NULL,           'ASSIGNED', 34.47),
  (403, 3, 103, 203, 2, '2025-06-03 13:00:00', '2025-06-03 13:30:00','DELIVERED', 10.99),
  (404, 4, 104, NULL,2, '2025-06-04 20:20:00', NULL,           'PENDING', 8.50),
  (405, 5, 105, 205, 3, '2025-06-05 11:45:00', '2025-06-05 12:15:00','DELIVERED', 13.99);
```

### 7. OrderItems
```sql
CREATE TABLE OrderItems (
  order_item_id  INT PRIMARY KEY,
  order_id       INT,
  menu_item_id   INT,
  quantity       INT CHECK(quantity > 0),
  unit_price     DECIMAL(6,2) CHECK(unit_price >= 0),
  FOREIGN KEY(order_id) REFERENCES Orders(order_id),
  FOREIGN KEY(menu_item_id) REFERENCES MenuItems(menu_item_id)
);

INSERT INTO OrderItems VALUES
  (501, 401, 301, 1, 12.99),
  (502, 401, 302, 1, 11.49),
  (503, 401, 303, 1,  0.00),  -- complimentary
  (504, 402, 301, 2, 12.99),
  (505, 403, 304, 1, 10.99),
  (506, 404, 305, 1,  8.50),
  (507, 405, 307, 1, 13.99);
```

### 8. Payments
```sql
CREATE TABLE Payments (
  payment_id    INT PRIMARY KEY,
  order_id      INT,
  amount        DECIMAL(8,2),
  payment_method VARCHAR(20),
  payment_date  TIMESTAMP,
  FOREIGN KEY(order_id) REFERENCES Orders(order_id)
);

INSERT INTO Payments VALUES
  (601, 401, 25.48, 'Credit Card', '2025-06-01 12:15:00'),
  (602, 402, 34.47, 'PayPal',      '2025-06-02 18:35:00'),
  (603, 403, 10.99, 'Debit Card',  '2025-06-03 13:00:00'),
  (604, 405, 13.99, 'Cash',        '2025-06-05 11:45:00');
```

### 9. Reviews
```sql
CREATE TABLE Reviews (
  review_id      INT PRIMARY KEY,
  user_id        INT,
  restaurant_id  INT,
  rating         TINYINT CHECK(rating BETWEEN 1 AND 5),
  comment        TEXT,
  review_date    DATE,
  FOREIGN KEY(user_id) REFERENCES Users(user_id),
  FOREIGN KEY(restaurant_id) REFERENCES Restaurants(restaurant_id)
);

INSERT INTO Reviews VALUES
  (701, 1, 101, 5, 'Amazing food and fast delivery!',    '2025-06-02'),
  (702, 2, 101, 4, 'Tasty but arrived slightly late.',   '2025-06-03'),
  (703, 3, 103, 5, 'Best burger I ever had.',           '2025-06-04'),
  (704, 5, 105, 3, NULL,                                  '2025-06-06');
```

### 10. Zones (delivery areas)
```sql
CREATE TABLE Zones (
  zone_id       INT PRIMARY KEY,
  name          VARCHAR(50) NOT NULL,
  city          VARCHAR(50) NOT NULL
);

INSERT INTO Zones VALUES
  (801, 'Downtown', 'Chicago'),
  (802, 'Uptown',   'Chicago'),
  (803, 'SoMa',     'San Francisco');
```

### 11. RestaurantZones (many-to-many)
```sql
CREATE TABLE RestaurantZones (
  restaurant_id INT,
  zone_id       INT,
  PRIMARY KEY(restaurant_id, zone_id),
  FOREIGN KEY(restaurant_id) REFERENCES Restaurants(restaurant_id),
  FOREIGN KEY(zone_id) REFERENCES Zones(zone_id)
);

INSERT INTO RestaurantZones VALUES
  (101, 801),
  (101, 802),
  (103, 803);
```

## Query Exercises

### 1. Easy

a. List the name, country, and launch_date of all apps where active = TRUE.

b. Retrieve each user_id, name, and subscription_type for users with a "PREMIUM" subscription.

c. Show the restaurant name, menu item name, and price for all items where available = TRUE.


### 2. Medium

a. Restaurant Ratings
For each restaurant, calculate its average review rating. Return restaurant_id, restaurant name, and AVG(rating), including only restaurants with at least one review.

b. Order Details
List order_id, user name, restaurant name, courier name (if assigned), status, and total_amount for every order.

c. App Revenues
For each app, compute the total number of orders and the total revenue (SUM(total_amount)). Return app_id, app name, order count, and total revenue, ordered by revenue descending.

d. Courier Performance
For each courier, find the number of orders they have delivered (status = 'DELIVERED') and their average delivery time in minutes (use TIMESTAMPDIFF between order_time and delivered_time). Return courier_id, courier name, delivered count, and avg delivery duration.


### 3. Hard

a. City Ranking of Restaurants
Use a window function to rank restaurants within each city by their total order count. Return city, restaurant_id, name, order_count, and RANK() OVER (PARTITION BY city ORDER BY order_count DESC).

b. Never-Ordered Items
Identify menu items that have never been ordered. Return menu_item_id and name for items not present in OrderItems.

c. Top Revenue Zone
Determine which delivery zone has generated the highest total order revenue. Join Orders → Restaurants → RestaurantZones → Zones, sum total_amount per zone, and return the zone name, city, and total revenue, ordering to show the top zone first.

