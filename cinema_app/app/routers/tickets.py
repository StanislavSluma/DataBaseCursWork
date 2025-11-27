from fastapi import APIRouter, HTTPException, status, Depends
from typing import List
from pydantic import BaseModel
from decimal import Decimal
from app.database import get_db
from app.auth import get_current_user, CurrentUser

router = APIRouter(prefix="/tickets", tags=["Tickets"])


class TicketCreate(BaseModel):
    showtime_id: int
    seat_id: int
    price: Decimal


class Ticket(BaseModel):
    id: int
    showtime_id: int
    seat_id: int
    user_id: int
    price: Decimal


@router.post("/", response_model=Ticket, status_code=status.HTTP_201_CREATED)
async def buy_ticket(
        ticket: TicketCreate,
        current_user: CurrentUser = Depends(get_current_user)
):
    sql = """
        INSERT INTO tickets (showtime_id, seat_id, user_id, price)
        VALUES (%(showtime_id)s, %(seat_id)s, %(user_id)s, %(price)s)
        RETURNING id, showtime_id, seat_id, user_id, price;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()

            data = ticket.model_dump()
            data['user_id'] = current_user.id

            cursor.execute(sql, data)
            result = cursor.fetchone()

            print(f"Билет куплен пользователем {current_user.email}")
            print(f"Цена после триггера: {result['price']} (было: {ticket.price})")

            return result

    except Exception as e:
        error_msg = str(e)
        print(f"Ошибка покупки билета: {error_msg}")

        if "not old enough" in error_msg.lower():
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Вы слишком молоды для этого фильма. Ваш возраст: {current_user.age}"
            )
        elif "недостаточно свободных мест" in error_msg.lower():
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Недостаточно свободных мест на этом сеансе"
            )
        elif "место уже занято" in error_msg.lower():
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Это место уже занято"
            )
        else:
            raise HTTPException(status_code=400, detail=error_msg)


@router.get("/my", response_model=List[Ticket])
async def get_my_tickets(current_user: CurrentUser = Depends(get_current_user)):
    sql = """
        SELECT id, showtime_id, seat_id, user_id, price
        FROM tickets
        WHERE user_id = %(user_id)s
        ORDER BY id DESC;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"user_id": current_user.id})
            results = cursor.fetchall()
            return results
    except Exception as e:
        print(f"Ошибка получения билетов: {e}")
        raise HTTPException(status_code=400, detail=str(e))