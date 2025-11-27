from fastapi import APIRouter, HTTPException
from typing import List, Dict, Any
from app.database import get_db

router = APIRouter(prefix="/analytics", tags=["analytics"])


@router.get("/stats")
def get_stats() -> Dict[str, int]:
    try:
        with get_db() as conn:
            cursor = conn.cursor()

            stats = {}

            cursor.execute("SELECT COUNT(*) as count FROM movies")
            stats['movies'] = cursor.fetchone()['count']

            cursor.execute("SELECT COUNT(*) as count FROM users")
            stats['users'] = cursor.fetchone()['count']

            cursor.execute("SELECT COUNT(*) as count FROM showtimes")
            stats['showtimes'] = cursor.fetchone()['count']

            cursor.execute("SELECT COUNT(*) as count FROM tickets")
            stats['tickets'] = cursor.fetchone()['count']

            cursor.execute("SELECT COUNT(*) as count FROM reviews")
            stats['reviews'] = cursor.fetchone()['count']

            cursor.execute("SELECT COUNT(*) as count FROM cinemas")
            stats['cinemas'] = cursor.fetchone()['count']

            print(f"Статистика загружена: {stats}")
            return stats

    except Exception as e:
        print(f"Ошибка получения статистики: {e}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/popular-movies")
def get_popular_movies(limit: int = 10) -> List[Dict[str, Any]]:
    sql = """
        SELECT 
            m.id,
            m.title,
            m.rating,
            COUNT(t.id) AS tickets_sold,
            COALESCE(SUM(t.price), 0) AS total_revenue
        FROM movies m
        LEFT JOIN showtimes s ON m.id = s.movie_id
        LEFT JOIN tickets t ON s.id = t.showtime_id
        GROUP BY m.id, m.title, m.rating
        ORDER BY tickets_sold DESC
        LIMIT %(limit)s;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"limit": limit})
            results = cursor.fetchall()
            return results
    except Exception as e:
        print(f"Ошибка получения популярных фильмов: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/cinema-revenue")
def get_cinema_revenue() -> List[Dict[str, Any]]:
    sql = """
        SELECT 
            c.id,
            c.name,
            c.address,
            COUNT(DISTINCT h.id) AS total_halls,
            COUNT(t.id) AS tickets_sold,
            COALESCE(SUM(t.price), 0) AS total_revenue
        FROM cinemas c
        LEFT JOIN halls h ON c.id = h.cinema_id
        LEFT JOIN showtimes s ON h.id = s.hall_id
        LEFT JOIN tickets t ON s.id = t.showtime_id
        GROUP BY c.id, c.name, c.address
        ORDER BY total_revenue DESC;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            results = cursor.fetchall()
            return results
    except Exception as e:
        print(f"Ошибка получения выручки кинотеатров: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/user-activity/{user_id}")
def get_user_activity(user_id: int) -> Dict[str, Any]:
    sql = """
        SELECT 
            u.id,
            u.first_name,
            u.last_name,
            u.email,
            COUNT(DISTINCT t.id) AS tickets_purchased,
            COUNT(DISTINCT r.id) AS reviews_written,
            COUNT(DISTINCT v.id) AS movies_watched_online
        FROM users u
        LEFT JOIN tickets t ON u.id = t.user_id
        LEFT JOIN reviews r ON u.id = r.id
        LEFT JOIN views v ON u.id = v.user_id
        WHERE u.id = %(user_id)s
        GROUP BY u.id, u.first_name, u.last_name, u.email;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"user_id": user_id})
            result = cursor.fetchone()

            if not result:
                raise HTTPException(status_code=404, detail="User not found")

            return result
    except HTTPException:
        raise
    except Exception as e:
        print(f"Ошибка получения активности пользователя: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/ad-views-stats")
def get_ad_views_stats() -> List[Dict[str, Any]]:
    sql_path = "app/sql/analytics/ad_views_stats.sql"

    try:
        with open(sql_path, 'r', encoding='utf-8') as f:
            sql = f.read()

        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            results = cursor.fetchall()
            return results
    except Exception as e:
        print(f"Ошибка получения статистики: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/popular-movies")
def get_popular_movies(limit: int = 10) -> List[Dict[str, Any]]:
    sql = """
        SELECT 
            m.id,
            m.title,
            m.rating,
            COUNT(t.id) AS tickets_sold,
            SUM(t.price) AS total_revenue
        FROM movies m
        JOIN showtimes s ON m.id = s.movie_id
        JOIN tickets t ON s.id = t.showtime_id
        GROUP BY m.id, m.title, m.rating
        ORDER BY tickets_sold DESC
        LIMIT %(limit)s;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"limit": limit})
            results = cursor.fetchall()
            return results
    except Exception as e:
        print(f"Ошибка получения популярных фильмов: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/cinema-revenue")
def get_cinema_revenue() -> List[Dict[str, Any]]:
    sql = """
        SELECT 
            c.id,
            c.name,
            c.address,
            COUNT(DISTINCT h.id) AS total_halls,
            COUNT(t.id) AS tickets_sold,
            COALESCE(SUM(t.price), 0) AS total_revenue
        FROM cinemas c
        LEFT JOIN halls h ON c.id = h.cinema_id
        LEFT JOIN showtimes s ON h.id = s.hall_id
        LEFT JOIN tickets t ON s.id = t.showtime_id
        GROUP BY c.id, c.name, c.address
        ORDER BY total_revenue DESC;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql)
            results = cursor.fetchall()
            return results
    except Exception as e:
        print(f"Ошибка получения выручки кинотеатров: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/user-activity/{user_id}")
def get_user_activity(user_id: int) -> Dict[str, Any]:
    sql = """
        SELECT 
            u.id,
            u.first_name,
            u.last_name,
            u.email,
            COUNT(DISTINCT r.id) AS total_reservations,
            COUNT(DISTINCT t.id) AS tickets_purchased,
            COUNT(DISTINCT rev.id) AS reviews_written,
            COUNT(DISTINCT v.id) AS movies_watched_online
        FROM users u
        LEFT JOIN reservations r ON u.id = r.user_id
        LEFT JOIN tickets t ON u.id = t.user_id
        LEFT JOIN reviews rev ON u.id = rev.id
        LEFT JOIN views v ON u.id = v.user_id
        WHERE u.id = %(user_id)s
        GROUP BY u.id, u.first_name, u.last_name, u.email;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"user_id": user_id})
            result = cursor.fetchone()

            if not result:
                raise HTTPException(status_code=404, detail="User not found")

            return result
    except HTTPException:
        raise
    except Exception as e:
        print(f"Ошибка получения активности пользователя: {e}")
        raise HTTPException(status_code=400, detail=str(e))