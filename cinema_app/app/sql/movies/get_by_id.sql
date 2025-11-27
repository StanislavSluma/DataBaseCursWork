SELECT id, title, description, release_date, rating, duration, genre_id, country_id, age_restriction_id
FROM movies
WHERE id = %(id)s;