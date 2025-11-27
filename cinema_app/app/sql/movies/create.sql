INSERT INTO movies (title, description, release_date, rating, duration, genre_id, country_id, age_restriction_id)
VALUES (%(title)s, %(description)s, %(release_date)s, %(rating)s, %(duration)s, %(genre_id)s, %(country_id)s, %(age_restriction_id)s)
RETURNING id, title, description, release_date, rating, duration, genre_id, country_id, age_restriction_id;