import os
import psycopg2
from psycopg2.extras import RealDictCursor
from contextlib import contextmanager
from dotenv import load_dotenv

load_dotenv()


def get_db_params():
    db_params = {
        'host': os.getenv('DB_HOST', 'localhost'),
        'port': int(os.getenv('DB_PORT', 5432)),
        'database': os.getenv('DB_NAME', 'cinema_db'),
        'user': os.getenv('DB_USER', 'postgres'),
        'password': os.getenv('DB_PASSWORD', ''),
        'client_encoding': 'UTF8',
        'options': '-c client_encoding=UTF8'
    }
    return db_params


def get_db_connection():
    db_params = get_db_params()

    try:
        conn = psycopg2.connect(**db_params, cursor_factory=RealDictCursor)
        conn.set_client_encoding('UTF8')
        return conn
    except Exception as e:
        print(f"Ошибка подключения к БД: {e}")
        raise


@contextmanager
def get_db():
    conn = None
    try:
        conn = get_db_connection()
        yield conn
        conn.commit()
    except Exception as e:
        if conn:
            conn.rollback()
        print(f"Ошибка в БД: {e}")
        raise e
    finally:
        if conn:
            conn.close()