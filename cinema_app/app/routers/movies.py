from fastapi import APIRouter, HTTPException, status
from typing import List
import os
from app.models.schemas import Movie, MovieCreate, MovieUpdate
from app.database import get_db

router = APIRouter(prefix="/movies", tags=["movies"])

SQL_DIR = "app/sql/movies"


@router.post("/", response_model=Movie, status_code=status.HTTP_201_CREATED)
def create_movie(movie: MovieCreate):
    sql_path = os.path.join(SQL_DIR, "create.sql")

    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, movie.dict())
            result = cursor.fetchone()
            return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/", response_model=List[Movie])
def get_movies():
    sql_path = os.path.join(SQL_DIR, "get_all.sql")

    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()

    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute(sql)
        results = cursor.fetchall()
        return results


@router.get("/{movie_id}", response_model=Movie)
def get_movie(movie_id: int):
    sql_path = os.path.join(SQL_DIR, "get_by_id.sql")

    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()

    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute(sql, {"id": movie_id})
        result = cursor.fetchone()

        if not result:
            raise HTTPException(status_code=404, detail="Movie not found")

        return result


@router.put("/{movie_id}", response_model=Movie)
def update_movie(movie_id: int, movie: MovieUpdate):
    sql_path = os.path.join(SQL_DIR, "update.sql")

    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()

    params = movie.dict(exclude_unset=True)
    params['id'] = movie_id

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, params)
            result = cursor.fetchone()

            if not result:
                raise HTTPException(status_code=404, detail="Movie not found")

            return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/{movie_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_movie(movie_id: int):
    sql_path = os.path.join(SQL_DIR, "delete.sql")

    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()

    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute(sql, {"id": movie_id})
        result = cursor.fetchone()

        if not result:
            raise HTTPException(status_code=404, detail="Movie not found")