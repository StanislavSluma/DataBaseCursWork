from fastapi import APIRouter, HTTPException, status, Depends
from typing import List, Optional
from pydantic import BaseModel, EmailStr
from app.database import get_db
from app.auth import get_password_hash, get_current_user, CurrentUser
import traceback

router = APIRouter(prefix="/users", tags=["Users"])


class UserBase(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: EmailStr
    contact_num: Optional[str] = None
    role_id: Optional[int] = None
    age: Optional[int] = None


class UserCreate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: EmailStr
    password: str
    contact_num: Optional[str] = None
    role_id: Optional[int] = 2
    age: Optional[int] = None


class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    contact_num: Optional[str] = None
    role_id: Optional[int] = None
    age: Optional[int] = None
    password: Optional[str] = None


class User(UserBase):
    id: int


@router.post("/", response_model=User, status_code=status.HTTP_201_CREATED)
def create_user(user: UserCreate):
    sql_check = "SELECT id FROM users WHERE email = %(email)s;"
    sql_insert = """
        INSERT INTO users (first_name, last_name, email, password, contact_num, role_id, age)
        VALUES (%(first_name)s, %(last_name)s, %(email)s, %(password)s, %(contact_num)s, %(role_id)s, %(age)s)
        RETURNING id, first_name, last_name, email, contact_num, role_id, age;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()

            cursor.execute(sql_check, {"email": user.email})
            if cursor.fetchone():
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Email already registered"
                )

            user_data = user.model_dump()

            user_data['password'] = get_password_hash(user.password)

            cursor.execute(sql_insert, user_data)
            result = cursor.fetchone()

            print(f"Пользователь создан: {result['email']}")
            return result

    except HTTPException:
        raise
    except Exception as e:
        print(f"Ошибка создания пользователя: {e}")
        traceback.print_exc()
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/", response_model=List[User])
def get_users(
        skip: int = 0,
        limit: int = 100
):
    sql = """
        SELECT id, first_name, last_name, email, contact_num, role_id, age
        FROM users
        ORDER BY id
        LIMIT %(limit)s OFFSET %(skip)s;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"limit": limit, "skip": skip})
            results = cursor.fetchall()
            return results
    except Exception as e:
        print(f"Ошибка получения пользователей: {e}")
        traceback.print_exc()
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/{user_id}", response_model=User)
def get_user(user_id: int):
    sql = """
        SELECT id, first_name, last_name, email, contact_num, role_id, age
        FROM users
        WHERE id = %(id)s;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"id": user_id})
            result = cursor.fetchone()

            if not result:
                raise HTTPException(status_code=404, detail="User not found")

            return result
    except HTTPException:
        raise
    except Exception as e:
        print(f"Ошибка получения пользователя: {e}")
        traceback.print_exc()
        raise HTTPException(status_code=400, detail=str(e))


@router.put("/{user_id}", response_model=User)
async def update_user(
        user_id: int,
        user: UserUpdate,
        current_user: CurrentUser = Depends(get_current_user)
):
    if current_user.id != user_id and current_user.role_id != 1:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not enough permissions"
        )

    update_fields = []
    params = {"id": user_id}

    user_data = user.model_dump(exclude_unset=True)

    if 'password' in user_data and user_data['password']:
        user_data['password'] = get_password_hash(user_data['password'])

    for field, value in user_data.items():
        if value is not None:
            update_fields.append(f"{field} = %({field})s")
            params[field] = value

    if not update_fields:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="No fields to update"
        )

    sql = f"""
        UPDATE users
        SET {', '.join(update_fields)}
        WHERE id = %(id)s
        RETURNING id, first_name, last_name, email, contact_num, role_id, age;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, params)
            result = cursor.fetchone()

            if not result:
                raise HTTPException(status_code=404, detail="User not found")

            print(f"Пользователь {user_id} обновлен")
            return result
    except HTTPException:
        raise
    except Exception as e:
        print(f"Ошибка обновления пользователя: {e}")
        traceback.print_exc()
        raise HTTPException(status_code=400, detail=str(e))


@router.delete("/{user_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_user(
        user_id: int,
        current_user: CurrentUser = Depends(get_current_user)
):
    if current_user.role_id != 1:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Only admin can delete users"
        )

    sql = "DELETE FROM users WHERE id = %(id)s RETURNING id;"

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"id": user_id})
            result = cursor.fetchone()

            if not result:
                raise HTTPException(status_code=404, detail="User not found")

            print(f"Пользователь {user_id} удален")
    except HTTPException:
        raise
    except Exception as e:
        print(f"Ошибка удаления пользователя: {e}")
        traceback.print_exc()
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/me/profile", response_model=User)
async def get_my_profile(current_user: CurrentUser = Depends(get_current_user)):
    return current_user