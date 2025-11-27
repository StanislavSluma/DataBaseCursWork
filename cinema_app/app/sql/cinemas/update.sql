UPDATE cinemas
SET
    name = COALESCE(%(name)s, name),
    address = COALESCE(%(address)s, address)
WHERE id = %(id)s
RETURNING id, name, address;