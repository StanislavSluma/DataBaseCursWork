DELETE FROM cinemas
WHERE id = %(id)s
RETURNING id;