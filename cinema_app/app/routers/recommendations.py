from fastapi import APIRouter, HTTPException
from typing import List, Dict, Any
from app.database import get_db

router = APIRouter(prefix="/recommendations", tags=["recommendations"])


@router.get("/movies/{user_id}")
def get_movie_recommendations(user_id: int) -> List[Dict[str, Any]]:
    sql = "SELECT * FROM recommend_movie(%(user_id)s);"

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"user_id": user_id})
            results = cursor.fetchall()
            return results
    except Exception as e:
        print(f"Ошибка получения рекомендаций: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/movies/playlist/{user_id}")
def get_playlist_based_recommendations(user_id: int) -> List[Dict[str, Any]]:
    sql = "SELECT * FROM recommend_movie_based_on_playlists(%(user_id)s);"

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"user_id": user_id})
            results = cursor.fetchall()

            if not results:
                return {
                    "message": "У пользователя нет плейлистов или все рекомендации исчерпаны",
                    "recommendations": []
                }

            return results
    except Exception as e:
        print(f"Ошибка получения рекомендаций на основе плейлистов: {e}")
        raise HTTPException(status_code=400, detail=str(e))