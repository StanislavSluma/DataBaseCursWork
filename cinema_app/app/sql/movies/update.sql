UPDATE movies
SET
    title = COALESCE(%(title)s, title),
    description = COALESCE(%(description)s, description),
    release_date = COALESCE(%(release_date)s, release_date),
    rating = COALESCE(%(rating)s, rating),
    duration = COALESCE(%(duration)s, duration),
    genre_id = COALESCE(%(genre_id)s, genre_id),
    country_id = COALESCE(%(country_id)s, country_id),
    age_restriction_id = COALESCE(%(age_restriction_id)s, age_restriction_id)
WHERE id = %(id)s
RETURNING id, title, description, release_date, rating, duration, genre_id, country_id, age_restriction_id;