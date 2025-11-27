INSERT INTO users (first_name, last_name, email, password, contact_num, role_id, age)
VALUES (%(first_name)s, %(last_name)s, %(email)s, %(password)s, %(contact_num)s, %(role_id)s, %(age)s)
RETURNING id, first_name, last_name, email, contact_num, role_id, age;