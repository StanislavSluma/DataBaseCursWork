from fastapi import APIRouter, HTTPException, status, Depends
from typing import List, Optional
from pydantic import BaseModel
from datetime import datetime
from app.database import get_db
from app.auth import get_current_user, CurrentUser
import traceback

router = APIRouter(prefix="/reviews", tags=["Reviews"])


class ReviewBase(BaseModel):
    movie_id: int
    rating: int  # 1-10
    comment: Optional[str] = None


class ReviewCreate(ReviewBase):
    pass


class ReviewUpdate(BaseModel):
    rating: Optional[int] = None
    comment: Optional[str] = None


class Review(ReviewBase):
    id: int
    created_at: datetime
    updated_at: Optional[datetime] = None


class ReviewWithUser(Review):
    user_email: str
    user_name: Optional[str] = None


@router.post("/", response_model=Review, status_code=status.HTTP_201_CREATED)
async def create_review(
        review: ReviewCreate,
        current_user: CurrentUser = Depends(get_current_user)
):
    if review.rating < 1 or review.rating > 5:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Rating must be between 1 and 5"
        )

    sql = """
        INSERT INTO reviews (movie_id, rating, comment, created_at, updated_at)
        VALUES (%(movie_id)s, %(rating)s, %(comment)s, NOW(), NOW())
        RETURNING id, movie_id, rating, comment, created_at, updated_at;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()

            cursor.execute("SELECT id FROM movies WHERE id = %(id)s", {"id": review.movie_id})
            if not cursor.fetchone():
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Movie not found"
                )

            cursor.execute(sql, review.model_dump())
            result = cursor.fetchone()

            print(f"Отзыв создан пользователем {current_user.email} на фильм {review.movie_id}")
            print(f"Триггер update_movie_rating_trigger сработал!")

            return result

    except HTTPException:
        raise
    except Exception as e:
        print(f"Ошибка создания отзыва: {e}")
        traceback.print_exc()
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/movie/{movie_id}", response_model=List[ReviewWithUser])
def get_movie_reviews(movie_id: int):
    sql = """
        SELECT 
            r.id, r.movie_id, r.rating, r.comment, 
            r.created_at, r.updated_at,
            u.email as user_email,
            CONCAT(u.first_name, ' ', u.last_name) as user_name
        FROM reviews r
        LEFT JOIN users u ON r.id = u.id
        WHERE r.movie_id = %(movie_id)s
        ORDER BY r.created_at DESC;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"movie_id": movie_id})
            results = cursor.fetchall()
            return results
    except Exception as e:
        print(f"Ошибка получения отзывов: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/", response_model=List[ReviewWithUser])
def get_all_reviews(limit: int = 50):
    sql = """
        SELECT 
            r.id, r.movie_id, r.rating, r.comment, 
            r.created_at, r.updated_at,
            u.email as user_email,
            CONCAT(u.first_name, ' ', u.last_name) as user_name
        FROM reviews r
        LEFT JOIN users u ON r.id = u.id
        ORDER BY r.created_at DESC
        LIMIT %(limit)s;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"limit": limit})
            results = cursor.fetchall()
            return results
    except Exception as e:
        print(f"Ошибка получения отзывов: {e}")
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/{review_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_review(
        review_id: int,
        current_user: CurrentUser = Depends(get_current_user)
):
    sql = "DELETE FROM reviews WHERE id = %(id)s RETURNING id, movie_id;"

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"id": review_id})
            result = cursor.fetchone()

            if not result:
                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Review not found"
                )

            print(f"Отзыв {review_id} удален")
            print(f"Триггер update_movie_rating_trigger пересчитал рейтинг!")

    except HTTPException:
        raise
    except Exception as e:
        print(f"Ошибка удаления отзыва: {e}")
        raise HTTPException(status_code=400, detail=str(e))