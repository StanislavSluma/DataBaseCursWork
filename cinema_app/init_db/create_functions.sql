-- Функция рекомендации фильмов на основе истории просмотров
CREATE OR REPLACE FUNCTION recommend_movie(p_user_id BIGINT)
RETURNS TABLE(movie_id INTEGER, title VARCHAR(100), rating DECIMAL(2,1), genre_name VARCHAR(50)) AS $$
DECLARE
  v_genre_id BIGINT;
BEGIN
  SELECT mg.genre_id INTO v_genre_id
  FROM views v
  JOIN online_movies om ON v.online_movie_id = om.id
  JOIN movies m ON om.movie_id = m.id
  JOIN movie_genre mg ON m.id = mg.movie_id
  WHERE v.user_id = p_user_id
  GROUP BY mg.genre_id
  ORDER BY SUM(EXTRACT(EPOCH FROM v.view_dur_time)) DESC
  LIMIT 1;

  IF v_genre_id IS NULL THEN
    RETURN QUERY
    SELECT m.id, m.title, m.rating, g.name
    FROM movies m
    JOIN genres g ON m.genre_id = g.id
    ORDER BY m.rating DESC NULLS LAST
    LIMIT 10;
  ELSE
    RETURN QUERY
    SELECT m.id, m.title, m.rating, g.name
    FROM movies m
    JOIN movie_genre mg ON m.id = mg.movie_id
    JOIN genres g ON mg.genre_id = g.id
    WHERE mg.genre_id = v_genre_id
      AND m.id NOT IN (
        SELECT om.movie_id
        FROM views v
        JOIN online_movies om ON v.online_movie_id = om.id
        WHERE v.user_id = p_user_id
      )
    ORDER BY m.rating DESC NULLS LAST, RANDOM()
    LIMIT 10;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Функция рекомендации фильмов на основе плейлистов пользователя
CREATE OR REPLACE FUNCTION recommend_movie_based_on_playlists(p_user_id BIGINT)
RETURNS TABLE(movie_id INTEGER, title VARCHAR(100), rating DECIMAL(2,1), genre_name VARCHAR(50)) AS $$
DECLARE
  v_genre_id BIGINT;
BEGIN
  SELECT mg.genre_id INTO v_genre_id
  FROM playlist_movies pm
  JOIN playlist p ON pm.playlist_id = p.id
  JOIN movies m ON pm.movie_id = m.id
  JOIN movie_genre mg ON m.id = mg.movie_id
  WHERE p.user_id = p_user_id
  GROUP BY mg.genre_id
  ORDER BY COUNT(*) DESC
  LIMIT 1;

  IF v_genre_id IS NULL THEN
    RETURN;
  END IF;

  RETURN QUERY
  SELECT m.id, m.title, m.rating, g.name
  FROM movies m
  JOIN movie_genre mg ON m.id = mg.movie_id
  JOIN genres g ON mg.genre_id = g.id
  WHERE mg.genre_id = v_genre_id
    AND NOT EXISTS (
      SELECT 1
      FROM views v
      JOIN online_movies om ON v.online_movie_id = om.id
      WHERE om.movie_id = m.id
        AND v.user_id = p_user_id
    )
    AND NOT EXISTS (
      SELECT 1
      FROM playlist_movies pm
      JOIN playlist pl ON pm.playlist_id = pl.id
      WHERE pm.movie_id = m.id
        AND pl.user_id = p_user_id
    )
  ORDER BY m.rating DESC NULLS LAST, RANDOM()
  LIMIT 10;
END;
$$ LANGUAGE plpgsql;