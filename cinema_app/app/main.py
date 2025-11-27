from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi.responses import HTMLResponse

from app.routers import users, movies, cinemas, analytics, recommendations
from app.routers import auth, reviews, tickets

app = FastAPI(
    title="🎬 Cinema Management System",
    description="""
    ## Система управления кинотеатром

    ### Возможности:
    - 🔐 Авторизация пользователей
    - ⭐ Отзывы и рейтинги (с триггерами)
    - 🎫 Покупка билетов (с проверками через триггеры)
    - 🎥 Управление фильмами и сеансами
    - 📊 Аналитика и рекомендации

    ### Демо-пользователи:
    - ivan@example.com / password123 (возраст 25)
    - anna@example.com / password123 (возраст 19)
    - sergey@example.com / password123 (возраст 17)
    """,
    version="1.0.0"
)

try:
    app.mount("/static", StaticFiles(directory="app/static"), name="static")
    templates = Jinja2Templates(directory="app/templates")
    HAS_UI = True
except:
    HAS_UI = False
    templates = None

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(reviews.router)
app.include_router(tickets.router)
app.include_router(users.router)
app.include_router(movies.router)
app.include_router(cinemas.router)
app.include_router(analytics.router)
app.include_router(recommendations.router)

if HAS_UI and templates:
    @app.get("/ui", response_class=HTMLResponse)
    async def ui_home(request: Request):
        return templates.TemplateResponse("index.html", {"request": request})


    @app.get("/ui/movies", response_class=HTMLResponse)
    async def ui_movies(request: Request):
        return templates.TemplateResponse("movies.html", {"request": request})


    @app.get("/ui/login", response_class=HTMLResponse)
    async def ui_login(request: Request):
        return templates.TemplateResponse("login.html", {"request": request})


@app.get("/")
def root():
    return {
        "message": "🎬 Cinema API",
        "docs": "/docs",
        "ui": "/ui" if HAS_UI else None
    }


@app.get("/health")
def health():
    return {"status": "healthy"}