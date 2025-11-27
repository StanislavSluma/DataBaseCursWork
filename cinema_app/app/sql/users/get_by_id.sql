SELECT id, first_name, last_name, email, contact_num, role_id, age
FROM users
WHERE id = %(id)s;