DELETE FROM users
WHERE id = %(id)s
RETURNING id;