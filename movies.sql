--Easy
--Q1(a) List each movie's title, release_date, and its director's name.
SELECT 
  m.title AS movie_title,
  m.release_date,
  d.name AS director_name
FROM Movies m
JOIN Directors d ON m.director_id = d.director_id;


--Q1(b) Retrieve all movie titles where is_original = TRUE.
SELECT 
  title 
FROM Movies 
WHERE is_original = TRUE;

--Q1(c)Show every web series' title, start_date, and seasons.
SELECT 
  title, 
  start_date, 
  seasons 
FROM WebSeries;


--Medium
--Q2.a. For each actor, count how many movies they've appeared in. Return actor_id, actor name, and movie count, ordered descending.
SELECT 
  a.actor_id,
  a.name AS actor_name,
  COUNT(mc.movie_id) AS movie_count
FROM Actors a
LEFT JOIN MovieCast mc ON a.actor_id = mc.actor_id
GROUP BY a.actor_id, a.name
ORDER BY movie_count DESC;


--b. For each genre, calculate how many movies belong to it. Return genre_id, name, and the movie count, including genres with zero movies.
SELECT 
  g.genre_id,
  g.name AS genre_name,
  COUNT(mg.movie_id) AS movie_count
FROM Genres g
LEFT JOIN MovieGenres mg ON g.genre_id = mg.genre_id
GROUP BY g.genre_id, g.name
ORDER BY movie_count DESC;


--c. Compute the average rating for each series. Show only series with at least two reviews, returning series_id, title, and average rating.
SELECT 
  s.series_id,
  s.title,
  AVG(r.rating) AS average_rating
FROM WebSeries s
JOIN Reviews r 
  ON r.content_type = 'SERIES' AND r.content_id = s.series_id
GROUP BY s.series_id, s.title
HAVING COUNT(r.review_id) >= 2;

--d. List all episodes of "Breaking Bad" (series_id = 101), showing season_number, episode_number, title, and air_date, ordered by season and episode.
SELECT 
  season_number,
  episode_number,
  title,
  air_date
FROM Episodes
WHERE series_id = 101
ORDER BY season_number, episode_number;

--Hard
--a. Use a window function to rank movies by their average review rating (highest first). Return movie_id, title, average_rating, and rank.
SELECT 
  m.movie_id,
  m.title,
  AVG(r.rating) AS average_rating,
  RANK() OVER (ORDER BY AVG(r.rating) DESC) AS r
FROM Movies m
JOIN Reviews r 
  ON r.content_type = 'MOVIE' AND r.content_id = m.movie_id
GROUP BY m.movie_id, m.title;


--b. Combine movies and series into one list (using UNION) of content_type ('MOVIE'/'SERIES'), title, and average rating, then select only those with average ≥ 9.0.
SELECT 'MOVIE' AS content_type, m.title, AVG(r.rating) AS average_rating
FROM Movies m
JOIN Reviews r ON r.content_type = 'MOVIE' AND r.content_id = m.movie_id
GROUP BY m.movie_id, m.title
HAVING AVG(r.rating) >= 9.0

UNION

SELECT 'SERIES' AS content_type, s.title, AVG(r.rating) AS average_rating
FROM WebSeries s
JOIN Reviews r ON r.content_type = 'SERIES' AND r.content_id = s.series_id
GROUP BY s.series_id, s.title
HAVING AVG(r.rating) >= 9.0;

--c. For each director, compute the average rating across all their movies, and list only those with an average ≥ 8.5. Return director name and their average movie rating.
SELECT 
  d.name AS director_name,
  AVG(r.rating) AS average_rating
FROM Directors d
JOIN Movies m ON d.director_id = m.director_id
JOIN Reviews r ON r.content_type = 'MOVIE' AND r.content_id = m.movie_id
GROUP BY d.director_id, d.name
HAVING AVG(r.rating) >= 8.5
ORDER BY average_rating DESC;


