from fastapi import APIRouter, HTTPException, status
from typing import List
import os
from app.models.schemas import Cinema, CinemaCreate, CinemaUpdate
from app.database import get_db

router = APIRouter(prefix="/cinemas", tags=["cinemas"])

SQL_DIR = "app/sql/cinemas"

@router.post("/", response_model=Cinema, status_code=status.HTTP_201_CREATED)
def create_cinema(cinema: CinemaCreate):
    sql_path = os.path.join(SQL_DIR, "create.sql")

    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, cinema.dict())
            result = cursor.fetchone()
            return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/", response_model=List[Cinema])
def get_cinemas():
    sql_path = os.path.join(SQL_DIR, "get_all.sql")

    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()

    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute(sql)
        results = cursor.fetchall()
        return results


@router.get("/{cinema_id}", response_model=Cinema)
def get_cinema(cinema_id: int):
    sql_path = os.path.join(SQL_DIR, "get_by_id.sql")

    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()

    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute(sql, {"id": cinema_id})
        result = cursor.fetchone()

        if not result:
            raise HTTPException(status_code=404, detail="Cinema not found")

        return result


@router.put("/{cinema_id}", response_model=Cinema)
def update_cinema(cinema_id: int, cinema: CinemaUpdate):
    sql_path = os.path.join(SQL_DIR, "update.sql")

    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()

    params = cinema.dict(exclude_unset=True)
    params['id'] = cinema_id

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, params)
            result = cursor.fetchone()

            if not result:
                raise HTTPException(status_code=404, detail="Cinema not found")

            return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/{cinema_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_cinema(cinema_id: int):
    sql_path = os.path.join(SQL_DIR, "delete.sql")

    with open(sql_path, 'r', encoding='utf-8') as f:
        sql = f.read()

    with get_db() as conn:
        cursor = conn.cursor()
        cursor.execute(sql, {"id": cinema_id})
        result = cursor.fetchone()

        if not result:
            raise HTTPException(status_code=404, detail="Cinema not found")