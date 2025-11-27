from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime, date, timedelta
from decimal import Decimal


class UserBase(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: EmailStr
    contact_num: Optional[str] = None
    role_id: Optional[int] = None
    age: Optional[int] = None

class UserCreate(UserBase):
    password: str

class UserUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    contact_num: Optional[str] = None
    role_id: Optional[int] = None
    age: Optional[int] = None

class User(UserBase):
    id: int


class MovieBase(BaseModel):
    title: str
    description: Optional[str] = None
    release_date: Optional[date] = None
    rating: Optional[Decimal] = None
    duration: Optional[timedelta] = None
    genre_id: Optional[int] = None
    country_id: Optional[int] = None
    age_restriction_id: Optional[int] = None

    class Config:
        from_attributes = True
        json_encoders = {
            timedelta: lambda v: str(v) if v else None
        }


class MovieCreate(MovieBase):
    pass


class MovieUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    release_date: Optional[date] = None
    rating: Optional[Decimal] = None
    duration: Optional[timedelta] = None
    genre_id: Optional[int] = None
    country_id: Optional[int] = None
    age_restriction_id: Optional[int] = None


class Movie(MovieBase):
    id: int

    class Config:
        from_attributes = True
        json_encoders = {
            timedelta: lambda v: str(v) if v else None
        }

class CinemaBase(BaseModel):
    name: str
    address: str

class CinemaCreate(CinemaBase):
    pass

class CinemaUpdate(BaseModel):
    name: Optional[str] = None
    address: Optional[str] = None

class Cinema(CinemaBase):
    id: int

class HallBase(BaseModel):
    cinema_id: int
    hall_num: int
    capacity: int

class HallCreate(HallBase):
    pass

class HallUpdate(BaseModel):
    cinema_id: Optional[int] = None
    hall_num: Optional[int] = None
    capacity: Optional[int] = None

class Hall(HallBase):
    id: int

class SeatBase(BaseModel):
    hall_id: int
    row_num: int
    seat_num: int
    seat_type_id: Optional[int] = None

class SeatCreate(SeatBase):
    pass

class Seat(SeatBase):
    id: int

class ShowtimeBase(BaseModel):
    movie_id: int
    hall_id: int
    startime: datetime

class ShowtimeCreate(ShowtimeBase):
    pass

class ShowtimeUpdate(BaseModel):
    movie_id: Optional[int] = None
    hall_id: Optional[int] = None
    startime: Optional[datetime] = None

class Showtime(ShowtimeBase):
    id: int

class ReservationBase(BaseModel):
    user_id: int
    reservation_time: datetime

class ReservationCreate(ReservationBase):
    pass

class Reservation(ReservationBase):
    id: int

class TicketBase(BaseModel):
    showtime_id: int
    seat_id: int
    price: Decimal

class TicketCreate(TicketBase):
    pass

class Ticket(TicketBase):
    id: int

class ReviewBase(BaseModel):
    movie_id: int
    rating: int
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

class GenreBase(BaseModel):
    name: str

class GenreCreate(GenreBase):
    pass

class Genre(GenreBase):
    id: int

class DirectorBase(BaseModel):
    first_name: str
    last_name: str

class DirectorCreate(DirectorBase):
    pass

class Director(DirectorBase):
    id: int

class ActorBase(BaseModel):
    first_name: str
    last_name: str

class ActorCreate(ActorBase):
    pass

class Actor(ActorBase):
    id: int