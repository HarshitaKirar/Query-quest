# SQL Movie Database Schema and Queries

## Database Schema

### 1. Directors
```sql
CREATE TABLE Directors (
  director_id   INT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  birth_date    DATE
);

INSERT INTO Directors VALUES
  (1, 'Francis Ford Coppola',   '1939-04-07'),
  (2, 'Steven Spielberg',       '1946-12-18'),
  (3, 'Christopher Nolan',      '1970-07-30'),
  (4, 'Quentin Tarantino',      '1963-03-27'),
  (5, 'Peter Jackson',          '1961-10-31'),
  (6, 'Martin Scorsese',        '1942-11-17');
```

### 2. Actors
```sql
CREATE TABLE Actors (
  actor_id      INT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  birth_date    DATE
);

INSERT INTO Actors VALUES
  (1, 'Marlon Brando',     '1924-04-03'),
  (2, 'Al Pacino',         '1940-04-25'),
  (3, 'Robert De Niro',    '1943-08-17'),
  (4, 'Leonardo DiCaprio', '1974-11-11'),
  (5, 'Brad Pitt',         '1963-12-18'),
  (6, 'Morgan Freeman',    '1937-06-01'),
  (7, 'Christian Bale',    '1974-01-30'),
  (8, 'Samuel L. Jackson','1948-12-21');
```

### 3. Genres
```sql
CREATE TABLE Genres (
  genre_id  INT PRIMARY KEY,
  name      VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO Genres VALUES
  (1, 'Crime'),
  (2, 'Drama'),
  (3, 'Action'),
  (4, 'Thriller'),
  (5, 'Sci-Fi'),
  (6, 'Fantasy');
```

### 4. Movies
```sql
CREATE TABLE Movies (
  movie_id       INT PRIMARY KEY,
  title          VARCHAR(150) NOT NULL,
  release_date   DATE,
  duration_mins  INT,
  director_id    INT,
  is_original    BOOLEAN DEFAULT TRUE,
  FOREIGN KEY(director_id) REFERENCES Directors(director_id)
);

INSERT INTO Movies VALUES
  (1, 'The Godfather',         '1972-03-24', 175, 1, FALSE),
  (2, 'Pulp Fiction',          '1994-10-14', 154, 4, FALSE),
  (3, 'Inception',             '2010-07-16', 148, 3, TRUE),
  (4, 'The Dark Knight',       '2008-07-18', 152, 3, TRUE),
  (5, 'Schindler''s List',     '1993-12-15', 195, 6, FALSE),
  (6, 'The Lord of the Rings: The Fellowship of the Ring', '2001-12-19', 178, 5, FALSE);
```

### 5. WebSeries
```sql
CREATE TABLE WebSeries (
  series_id     INT PRIMARY KEY,
  title         VARCHAR(150) NOT NULL,
  start_date    DATE,
  end_date      DATE,
  seasons       INT,
  is_original   BOOLEAN DEFAULT TRUE
);

INSERT INTO WebSeries VALUES
  (101, 'Breaking Bad',      '2008-01-20', '2013-09-29', 5, TRUE),
  (102, 'Game of Thrones',   '2011-04-17', '2019-05-19', 8, FALSE),
  (103, 'Stranger Things',   '2016-07-15', NULL,       4, TRUE),
  (104, 'The Crown',         '2016-11-04', NULL,       4, TRUE);
```

### 6. Episodes
```sql
CREATE TABLE Episodes (
  episode_id      INT PRIMARY KEY,
  series_id       INT,
  season_number   INT,
  episode_number  INT,
  title           VARCHAR(150),
  air_date        DATE,
  duration_mins   INT,
  FOREIGN KEY(series_id) REFERENCES WebSeries(series_id)
);

INSERT INTO Episodes VALUES
  (1001, 101, 1, 1, 'Pilot',                   '2008-01-20', 58),
  (1002, 101, 5, 16, 'Felina',                '2013-09-29', 55),
  (1003, 102, 1, 1, 'Winter Is Coming',        '2011-04-17', 62),
  (1004, 102, 8, 6, 'The Iron Throne',       '2019-05-19', 80),
  (1005, 103, 1, 1, 'Chapter One: The Vanishing of Will Byers', '2016-07-15', 47),
  (1006, 104, 1, 1, 'Wolferton Splash',       '2016-11-04', 61);
```

### 7. MovieGenres
```sql
CREATE TABLE MovieGenres (
  movie_id   INT,
  genre_id   INT,
  PRIMARY KEY(movie_id, genre_id),
  FOREIGN KEY(movie_id) REFERENCES Movies(movie_id),
  FOREIGN KEY(genre_id) REFERENCES Genres(genre_id)
);

INSERT INTO MovieGenres VALUES
  (1,1),(1,2),
  (2,1),(2,4),
  (3,5),(3,4),
  (4,3),(4,4),
  (5,2),(5,1),
  (6,6),(6,3);
```

### 8. SeriesGenres
```sql
CREATE TABLE SeriesGenres (
  series_id  INT,
  genre_id   INT,
  PRIMARY KEY(series_id, genre_id),
  FOREIGN KEY(series_id) REFERENCES WebSeries(series_id),
  FOREIGN KEY(genre_id) REFERENCES Genres(genre_id)
);

INSERT INTO SeriesGenres VALUES
  (101,2),(101,4),
  (102,6),(102,4),
  (103,5),(103,2),
  (104,2),(104,2);
```

### 9. MovieCast
```sql
CREATE TABLE MovieCast (
  movie_id  INT,
  actor_id  INT,
  role      VARCHAR(100),
  PRIMARY KEY(movie_id, actor_id),
  FOREIGN KEY(movie_id) REFERENCES Movies(movie_id),
  FOREIGN KEY(actor_id) REFERENCES Actors(actor_id)
);

INSERT INTO MovieCast VALUES
  (1,1,'Vito Corleone'),
  (1,2,'Michael Corleone'),
  (2,5,'Mr. Blonde'),
  (3,4,'Cobb'),
  (4,7,'Bruce Wayne / Batman'),
  (5,3,'Oskar Schindler'),
  (6,6,'Gandalf'),
  (6,8,'Aragorn');
```

### 10. SeriesCast
```sql
CREATE TABLE SeriesCast (
  series_id  INT,
  actor_id   INT,
  role       VARCHAR(100),
  PRIMARY KEY(series_id, actor_id),
  FOREIGN KEY(series_id) REFERENCES WebSeries(series_id),
  FOREIGN KEY(actor_id) REFERENCES Actors(actor_id)
);

INSERT INTO SeriesCast VALUES
  (101,4,'Walter White'),
  (101,6,'Mike Ehrmantraut'),
  (102,1,'Eddard Stark'),
  (102,8,'Jon Snow'),
  (103,7,'Chief Jim Hopper'),
  (104,2,'Queen Elizabeth II');
```

### 11. Users
```sql
CREATE TABLE Users (
  user_id           INT PRIMARY KEY,
  username          VARCHAR(50) UNIQUE,
  email             VARCHAR(100),
  join_date         DATE,
  subscription_type VARCHAR(20)
);

INSERT INTO Users VALUES
  (1,'cinephile42','user1@example.com','2020-05-20','PREMIUM'),
  (2,'binge_master','user2@example.com','2021-08-10','FREE');
```

### 12. Reviews
```sql
CREATE TABLE Reviews (
  review_id    INT PRIMARY KEY,
  user_id      INT,
  content_type VARCHAR(10) CHECK(content_type IN('MOVIE','SERIES')),
  content_id   INT,
  rating       DECIMAL(2,1) CHECK(rating BETWEEN 0.0 AND 10.0),
  comment      TEXT,
  review_date  DATE,
  FOREIGN KEY(user_id) REFERENCES Users(user_id)
);

INSERT INTO Reviews VALUES
  (9001,1,'MOVIE',1, 9.2,'A masterpiece!',      '2022-01-15'),
  (9002,2,'MOVIE',3, 8.8,'Mind-bending sci-fi.', '2022-08-01'),
  (9003,1,'SERIES',101,9.5,'Unforgettable arc.','2021-12-05'),
  (9004,2,'SERIES',103,8.7,'Nostalgic and thrilling.','2023-07-20');
```

## Query Exercises

### 1. Easy
a. List each movie's title, release_date, and its director's name.

b. Retrieve all movie titles where is_original = TRUE.

c. Show every web series' title, start_date, and seasons.


### 2. Medium

a. For each actor, count how many movies they've appeared in. Return actor_id, actor name, and movie count, ordered descending.

b. For each genre, calculate how many movies belong to it. Return genre_id, name, and the movie count, including genres with zero movies.

c. Compute the average rating for each series. Show only series with at least two reviews, returning series_id, title, and average rating.

d. List all episodes of "Breaking Bad" (series_id = 101), showing season_number, episode_number, title, and air_date, ordered by season and episode.


### 3. Hard

a. Use a window function to rank movies by their average review rating (highest first). Return movie_id, title, average_rating, and rank.

b. Combine movies and series into one list (using UNION) of content_type ('MOVIE'/'SERIES'), title, and average rating, then select only those with average ≥ 9.0.

c. For each director, compute the average rating across all their movies, and list only those with an average ≥ 8.5. Return director name and their average movie rating.

