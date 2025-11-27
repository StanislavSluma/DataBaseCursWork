DELETE FROM movies
WHERE id = %(id)s
RETURNING id;