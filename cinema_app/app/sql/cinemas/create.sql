INSERT INTO cinemas (name, address)
VALUES (%(name)s, %(address)s)
RETURNING id, name, address;