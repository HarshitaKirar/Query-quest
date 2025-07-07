# Project 3 - Biryani Database

## Database Schema

### 1. BiryaniVarieties
```sql
CREATE TABLE BiryaniVarieties (
  biryani_id    INT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  region        VARCHAR(50),
  spice_level   TINYINT CHECK (spice_level BETWEEN 1 AND 10),
  vegetarian    BOOLEAN NOT NULL
);

INSERT INTO BiryaniVarieties VALUES
 (1, 'Hyderabadi Chicken',    'Hyderabad',    8, FALSE),
 (2, 'Lucknowi (Awadhi)',     'Lucknow',      6, FALSE),
 (3, 'Kolkata Biryani',       'Kolkata',      5, FALSE),
 (4, 'Malabar Biryani',       'Kerala',       7, FALSE),
 (5, 'Ambur Biryani',         'Tamil Nadu',   7, FALSE),
 (6, 'Veg Dum Biryani',       'Delhi',        4, TRUE),
 (7, 'Tehari (Veg)',          'Lucknow',      3, TRUE),
 (8, 'Sindhi Biryani',        'Sindh',        9, FALSE);
```

### 2. Ingredients
```sql
CREATE TABLE Ingredients (
  ingredient_id  INT PRIMARY KEY,
  name           VARCHAR(50) NOT NULL,
  category       VARCHAR(20),            -- e.g., Spice, Grain, Protein, Herb
  is_allergen    BOOLEAN DEFAULT FALSE
);

INSERT INTO Ingredients VALUES
 (10, 'Basmati Rice',     'Grain',    FALSE),
 (11, 'Chicken',          'Protein',  FALSE),
 (12, 'Potato',           'Vegetable',FALSE),
 (13, 'Yogurt',           'Dairy',    TRUE),
 (14, 'Onion',            'Vegetable',FALSE),
 (15, 'Tomato',           'Vegetable',FALSE),
 (16, 'Saffron',          'Spice',    FALSE),
 (17, 'Ginger-Garlic Paste','Spice',  FALSE),
 (18, 'Garam Masala',     'Spice',    FALSE),
 (19, 'Green Chili',      'Spice',    FALSE),
 (20, 'Cashews',          'Nut',      TRUE),
 (21, 'Mint Leaves',      'Herb',     FALSE),
 (22, 'Bay Leaf',         'Spice',    FALSE);
```

### 3. Recipes (which ingredients go into each biryani)
```sql
CREATE TABLE Recipes (
  recipe_id     INT PRIMARY KEY,
  biryani_id    INT,
  ingredient_id INT,
  quantity      DECIMAL(5,2),
  unit          VARCHAR(20),
  CONSTRAINT fk_recipe_biryani FOREIGN KEY (biryani_id) REFERENCES BiryaniVarieties(biryani_id),
  CONSTRAINT fk_recipe_ing     FOREIGN KEY (ingredient_id) REFERENCES Ingredients(ingredient_id)
);

INSERT INTO Recipes VALUES
 (100, 1, 10,  500.00, 'g'),
 (101, 1, 11,  400.00, 'g'),
 (102, 1, 13,  100.00, 'ml'),
 (103, 1, 16,    1.00, 'g'),
 (104, 1, 18,    2.00, 'tbsp'),
 (105, 2, 10,  450.00, 'g'),
 (106, 2, 11,  350.00, 'g'),
 (107, 2, 14,  150.00, 'g'),
 (108, 2, 18,    1.50, 'tbsp'),
 (109, 3, 10,  500.00, 'g'),
 (110, 3, 12,  200.00, 'g'),
 (111, 3, 14,  100.00, 'g'),
 (112, 3, 17,   50.00, 'g'),
 (113, 4, 10,  550.00, 'g'),
 (114, 4, 11,  300.00, 'g'),
 (115, 4, 15,  100.00, 'g'),
 (116, 4, 21,   20.00, 'g'),
 (117, 5, 10,  480.00, 'g'),
 (118, 5, 11,  380.00, 'g'),
 (119, 5, 20,   30.00, 'g'),
 (120, 5, 18,    2.00, 'tbsp'),
 (121, 6, 10,  500.00, 'g'),
 (122, 6, 13,  200.00, 'ml'),
 (123, 6, 14,  100.00, 'g'),
 (124, 6, 19,    2.00, 'pcs'),
 (125, 7, 10,  450.00, 'g'),
 (126, 7, 12,  150.00, 'g'),
 (127, 7, 21,   15.00, 'g'),
 (128, 8, 10,  500.00, 'g'),
 (129, 8, 11,  400.00, 'g'),
 (130, 8, 17,   60.00, 'g');
```

### 4. Restaurants
```sql
CREATE TABLE Restaurants (
  restaurant_id     INT PRIMARY KEY,
  name               VARCHAR(100) NOT NULL,
  city               VARCHAR(50),
  established_date   DATE
);

INSERT INTO Restaurants VALUES
 (201, 'Spice Route',         'Chicago',   '2018-05-10'),
 (202, 'Royal Biryani',       'Houston',   '2020-11-20'),
 (203, 'Biryani Junction',    'New York',  '2017-03-15'),
 (204, 'Dum House',           'Atlanta',   '2019-08-08'),
 (205, 'Urban Biryani Bar',   'San Jose',  '2021-01-25');
```

### 5. Menu (which biryanis each restaurant offers)
```sql
CREATE TABLE Menu (
  menu_id        INT PRIMARY KEY,
  restaurant_id  INT,
  biryani_id     INT,
  price          DECIMAL(6,2),
  available      BOOLEAN DEFAULT TRUE,
  CONSTRAINT fk_menu_rest FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id),
  CONSTRAINT fk_menu_biry FOREIGN KEY (biryani_id)    REFERENCES BiryaniVarieties(biryani_id)
);

INSERT INTO Menu VALUES
 (301, 201, 1, 12.50, TRUE),
 (302, 201, 6, 10.00, TRUE),
 (303, 202, 2, 11.00, TRUE),
 (304, 202, 7,  9.50, FALSE),
 (305, 203, 3, 13.25, TRUE),
 (306, 203, 8, 14.00, TRUE),
 (307, 204, 4, 12.75, TRUE),
 (308, 204, 5, 11.50, TRUE),
 (309, 205, 1, 13.00, TRUE),
 (310, 205, 2, 12.00, TRUE),
 (311, 205, 6, 10.50, TRUE),
 (312, 205, 7,  9.75, TRUE);
```

### 6. Reviews
```sql
CREATE TABLE Reviews (
  review_id      INT PRIMARY KEY,
  restaurant_id  INT,
  biryani_id     INT,
  rating         TINYINT CHECK (rating BETWEEN 1 AND 5),
  comments       TEXT,
  review_date    DATE,
  CONSTRAINT fk_rev_rest FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id),
  CONSTRAINT fk_rev_biry FOREIGN KEY (biryani_id)    REFERENCES BiryaniVarieties(biryani_id)
);

INSERT INTO Reviews VALUES
 (401, 201, 1, 5, 'Authentic flavor, loved the spice!',    '2025-05-10'),
 (402, 201, 6, 4, 'Good veg option but could use more flavor.','2025-06-01'),
 (403, 202, 2, 3, 'A bit dry for Lucknowi style.',         '2025-06-03'),
 (404, 202, 7, 4, 'Comforting and mild.',                  '2025-06-05'),
 (405, 203, 3, 5, 'Perfect balance of meat and rice.',      '2025-05-15'),
 (406, 203, 8, 4, 'Rich and spicy but slightly oily.',      '2025-05-20'),
 (407, 204, 4, 5, 'Malabar aroma was spot on!',            '2025-06-10'),
 (408, 204, 5, 4, 'Tender chicken, nice cashews.',         '2025-06-12'),
 (409, 205, 1, 4, 'Well seasoned, good portion.',           '2025-06-15'),
 (410, 205, 2, 3, 'Too tangy for my taste.',               '2025-06-18'),
 (411, 205, 6, 4, 'Veg biryani was flavorful.',            '2025-06-20'),
 (412, 201, 1, 5, 'Best chicken biryani in town!',         '2025-06-22'),
 (413, 203, 3, 2, 'Rice was undercooked.',                 '2025-06-25'),
 (414, 204, 4, 4, 'Loved the coconut notes.',              '2025-06-28'),
 (415, 202, 2, 5, 'Exactly like homemade Lucknowi.',       '2025-07-01');
```

### 7. Sales
```sql
CREATE TABLE Sales (
  sale_id        INT PRIMARY KEY,
  restaurant_id  INT,
  biryani_id     INT,
  sale_date      DATE,
  quantity_sold  INT,
  total_amount   DECIMAL(8,2),
  CONSTRAINT fk_sale_rest FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id),
  CONSTRAINT fk_sale_biry FOREIGN KEY (biryani_id)    REFERENCES BiryaniVarieties(biryani_id)
);

INSERT INTO Sales VALUES
 (501, 201, 1, '2025-05-10',  25, 312.50),
 (502, 201, 6, '2025-06-01',  10, 100.00),
 (503, 202, 2, '2025-06-03',  15, 165.00),
 (504, 202, 7, '2025-06-05',   8,  76.00),
 (505, 203, 3, '2025-05-15',  20, 265.00),
 (506, 203, 8, '2025-05-20',  12, 168.00),
 (507, 204, 4, '2025-06-10',  18, 229.50),
 (508, 204, 5, '2025-06-12',  22, 253.00),
 (509, 205, 1, '2025-06-15',  30, 390.00),
 (510, 205, 2, '2025-06-18',  16, 192.00),
 (511, 205, 6, '2025-06-20',  14, 147.00),
 (512, 201, 1, '2025-06-22',  28, 350.00),
 (513, 203, 3, '2025-06-25',  10, 132.50),
 (514, 204, 4, '2025-06-28',   9, 114.75),
 (515, 202, 2, '2025-07-01',  17, 187.00);
```

## Query Exercises

### 1. Easy

a. Retrieve each variety's biryani_id, name, region, and whether it's vegetarian (vegetarian).

b. Spicy non-veg biryanis
Find the name and spice_level of all biryanis where vegetarian = FALSE and spice_level ≥ 7.

c. Available menu items
Show each restaurant's name and the name of biryanis they offer where available = TRUE.


### 2. Medium

a. For each biryani variety, count how many distinct ingredients it uses. Return biryani_id, name, and the ingredient count.

b. Calculate total quantity_sold and total total_amount for each biryani across all restaurants. Return biryani_id, name, sum of quantity_sold, and sum of total_amount, ordered by quantity descending.

c. For each restaurant, compute the average rating from Reviews, and show only those with an average ≥ 4. Include restaurant_id, name, and AVG(rating).

d. List all biryani varieties (name) that include at least one allergen ingredient (is_allergen = TRUE).


### 3. Hard

a. For each month in 2025, find the biryani (biryani_id, name) with the highest quantity_sold. Use window functions to partition by month and rank by quantity_sold, then pick rank = 1.

b. Identify any menu entries where the average sale price (total_amount/quantity_sold) differs by more than 10% from the listed price in Menu. Return restaurant_id, biryani_id, price, average sale price, and the percentage difference.

c. Compare average ratings for each biryani between "summer" (June–August) and "winter" (December–February) 2025. Return biryani_id, name, avg rating in summer, avg rating in winter, and the difference.

