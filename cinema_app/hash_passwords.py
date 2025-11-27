from passlib.context import CryptContext
from app.database import get_db

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_existing_passwords():
    sql_select = "SELECT id, email, password FROM users;"
    sql_update = "UPDATE users SET password = %(hashed_password)s WHERE id = %(id)s;"

    with get_db() as conn:
        cursor = conn.cursor()

        cursor.execute(sql_select)
        users = cursor.fetchall()

        print(f"Найдено пользователей: {len(users)}")

        for user in users:
            password = user['password']

            if password and password.startswith('$2b$'):
                print(f"{user['email']} - пароль уже захеширован")
                continue

            hashed = pwd_context.hash(password)

            cursor.execute(sql_update, {
                'id': user['id'],
                'hashed_password': hashed
            })

            print(f"{user['email']} - пароль обновлен")

        print("\nВсе пароли обновлены!")


if __name__ == "__main__":
    hash_existing_passwords()