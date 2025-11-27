UPDATE users
SET
    first_name = COALESCE(%(first_name)s, first_name),
    last_name = COALESCE(%(last_name)s, last_name),
    email = COALESCE(%(email)s, email),
    contact_num = COALESCE(%(contact_num)s, contact_num),
    role_id = COALESCE(%(role_id)s, role_id),
    age = COALESCE(%(age)s, age)
WHERE id = %(id)s
RETURNING id, first_name, last_name, email, contact_num, role_id, age;