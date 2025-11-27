from fastapi import APIRouter, HTTPException, status, Depends
from app.auth import (
    LoginRequest, Token, get_password_hash, verify_password,
    create_access_token, get_current_user, CurrentUser
)
from app.models.schemas import UserCreate, User
from app.database import get_db
import traceback

router = APIRouter(prefix="/auth", tags=["🔐 Authentication"])


@router.post("/register", response_model=User, status_code=status.HTTP_201_CREATED)
def register(user: UserCreate):
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

            if not user_data.get('role_id'):
                user_data['role_id'] = 2

            cursor.execute(sql_insert, user_data)
            result = cursor.fetchone()

            print(f"Пользователь зарегистрирован: {result['email']}")
            return result

    except HTTPException:
        raise
    except Exception as e:
        print(f"Ошибка регистрации: {e}")
        traceback.print_exc()
        raise HTTPException(status_code=400, detail=str(e))


@router.post("/login", response_model=Token)
def login(login_data: LoginRequest):
    sql = """
        SELECT id, email, password, first_name, last_name
        FROM users
        WHERE email = %(email)s;
    """

    try:
        with get_db() as conn:
            cursor = conn.cursor()
            cursor.execute(sql, {"email": login_data.email})
            user = cursor.fetchone()

            if not user:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Incorrect email or password"
                )

            if not verify_password(login_data.password, user['password']):
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="Incorrect email or password"
                )

            access_token = create_access_token(
                data={"sub": str(user['id']), "email": user['email']}
            )

            print(f"Успешный вход: {user['email']}")

            return {
                "access_token": access_token,
                "token_type": "bearer"
            }

    except HTTPException:
        raise
    except Exception as e:
        print(f"Ошибка входа: {e}")
        traceback.print_exc()
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/me", response_model=CurrentUser)
async def get_me(current_user: CurrentUser = Depends(get_current_user)):
    return current_user


@router.post("/logout")
async def logout(current_user: CurrentUser = Depends(get_current_user)):
    print(f"Выход пользователя: {current_user.email}")
    return {"message": "Successfully logged out"}