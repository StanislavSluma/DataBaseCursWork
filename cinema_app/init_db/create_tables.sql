DROP TABLE IF EXISTS playlist_movies CASCADE;
DROP TABLE IF EXISTS playlist CASCADE;
DROP TABLE IF EXISTS recommendation CASCADE;
DROP TABLE IF EXISTS movie_genre CASCADE;
DROP TABLE IF EXISTS movie_actor CASCADE;
DROP TABLE IF EXISTS movie_director CASCADE;
DROP TABLE IF EXISTS ad_views CASCADE;
DROP TABLE IF EXISTS advertisements CASCADE;
DROP TABLE IF EXISTS adv_type CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS payment_methods CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS views CASCADE;
DROP TABLE IF EXISTS online_movies CASCADE;
DROP TABLE IF EXISTS reservations CASCADE;
DROP TABLE IF EXISTS tickets CASCADE;
DROP TABLE IF EXISTS showtimes CASCADE;
DROP TABLE IF EXISTS seats CASCADE;
DROP TABLE IF EXISTS seat_types CASCADE;
DROP TABLE IF EXISTS halls CASCADE;
DROP TABLE IF EXISTS cinemas CASCADE;
DROP TABLE IF EXISTS actors CASCADE;
DROP TABLE IF EXISTS directors CASCADE;
DROP TABLE IF EXISTS movies CASCADE;
DROP TABLE IF EXISTS genres CASCADE;
DROP TABLE IF EXISTS countries CASCADE;
DROP TABLE IF EXISTS languages CASCADE;
DROP TABLE IF EXISTS age_restrictions CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS user_roles CASCADE;

CREATE TABLE "user_roles" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(50)
);

CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(50),
  "last_name" VARCHAR(50),
  "email" VARCHAR(100) UNIQUE,
  "password" VARCHAR(100),
  "contact_num" VARCHAR(15),
  "role_id" BIGINT,
  "age" INT
);

CREATE TABLE "genres" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(50)
);

CREATE TABLE "countries" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(50) UNIQUE
);

CREATE TABLE "age_restrictions" (
  "id" SERIAL PRIMARY KEY,
  "age_restriction" INT UNIQUE
);

CREATE TABLE "movies" (
  "id" SERIAL PRIMARY KEY,
  "title" VARCHAR(100),
  "description" TEXT,
  "release_date" DATE,
  "rating" DECIMAL(2,1),
  "duration" INTERVAL,
  "genre_id" BIGINT,
  "country_id" BIGINT,
  "age_restriction_id" BIGINT
);

CREATE TABLE "directors" (
  "id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(50),
  "last_name" VARCHAR(50)
);

CREATE TABLE "actors" (
  "id" SERIAL PRIMARY KEY,
  "first_name" VARCHAR(50),
  "last_name" VARCHAR(50)
);

CREATE TABLE "cinemas" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(100),
  "address" VARCHAR(200)
);

CREATE TABLE "halls" (
  "id" SERIAL PRIMARY KEY,
  "cinema_id" INT,
  "hall_num" INT,
  "capacity" INT
);

CREATE TABLE "seat_types" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(50) UNIQUE
);

CREATE TABLE "seats" (
  "id" SERIAL PRIMARY KEY,
  "hall_id" INT,
  "row_num" INT,
  "seat_num" INT,
  "seat_type_id" INT
);

CREATE TABLE "showtimes" (
  "id" SERIAL PRIMARY KEY,
  "movie_id" INT,
  "hall_id" INT,
  "startime" TIMESTAMP
);

CREATE TABLE "tickets" (
  "id" SERIAL PRIMARY KEY,
  "showtime_id" INT,
  "seat_id" INT,
  "user_id" INT,
  "price" DECIMAL(8,2)
);

CREATE TABLE "reservations" (
  "id" SERIAL PRIMARY KEY,
  "user_id" BIGINT,
  "reservation_time" TIMESTAMP
);

CREATE TABLE "languages" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(50) UNIQUE
);

CREATE TABLE "online_movies" (
  "id" SERIAL PRIMARY KEY,
  "movie_id" INT,
  "language_id" BIGINT,
  "url" TEXT,
  "created_at" TIMESTAMP,
  "updated_at" TIMESTAMP
);

CREATE TABLE "views" (
  "id" SERIAL PRIMARY KEY,
  "online_movie_id" INT,
  "view_time" TIMESTAMP,
  "view_dur_time" INTERVAL,
  "user_id" INT
);

CREATE TABLE "reviews" (
  "id" SERIAL PRIMARY KEY,
  "movie_id" INT,
  "rating" INT,
  "comment" TEXT,
  "created_at" TIMESTAMP,
  "updated_at" TIMESTAMP
);

CREATE TABLE "payment_methods" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(50) UNIQUE
);

CREATE TABLE "payments" (
  "id" SERIAL PRIMARY KEY,
  "reservation_id" INT,
  "payment_method_id" BIGINT,
  "created_at" TIMESTAMP,
  "amount" DECIMAL(8,2)
);

CREATE TABLE "adv_type" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(50) UNIQUE,
  "priority" INT
);

CREATE TABLE "advertisements" (
  "id" SERIAL PRIMARY KEY,
  "title" VARCHAR(100),
  "description" TEXT,
  "url" TEXT,
  "type_id" BIGINT
);

CREATE TABLE "ad_views" (
  "id" SERIAL PRIMARY KEY,
  "ad_id" INT,
  "view_id" INT,
  "user_id" INT,
  "viewed_at" TIMESTAMP,
  "successful" BOOLEAN
);

CREATE TABLE "movie_director" (
  "id" SERIAL PRIMARY KEY,
  "movie_id" BIGINT,
  "director_id" BIGINT
);

CREATE TABLE "movie_actor" (
  "id" SERIAL PRIMARY KEY,
  "movie_id" BIGINT,
  "actor_id" BIGINT
);

CREATE TABLE "movie_genre" (
  "id" SERIAL PRIMARY KEY,
  "movie_id" BIGINT,
  "genre_id" BIGINT
);

CREATE TABLE "playlist" (
  "id" SERIAL PRIMARY KEY,
  "user_id" BIGINT,
  "name" VARCHAR(50)
);

CREATE TABLE "playlist_movies" (
  "id" SERIAL PRIMARY KEY,
  "movie_id" BIGINT,
  "playlist_id" BIGINT,
  "created_at" TIMESTAMP
);

CREATE TABLE "recommendation" (
  "id" SERIAL PRIMARY KEY,
  "user_id" BIGINT,
  "movie_id" BIGINT,
  "review_id" BIGINT,
  "created_at" TIMESTAMP DEFAULT NOW()
);

-- ========================================
-- ВНЕШНИЕ КЛЮЧИ
-- ========================================

ALTER TABLE "users" ADD FOREIGN KEY ("role_id") REFERENCES "user_roles" ("id") ON DELETE SET NULL;
ALTER TABLE "movies" ADD FOREIGN KEY ("genre_id") REFERENCES "genres" ("id") ON DELETE SET NULL;
ALTER TABLE "movies" ADD FOREIGN KEY ("country_id") REFERENCES "countries" ("id") ON DELETE SET NULL;
ALTER TABLE "movies" ADD FOREIGN KEY ("age_restriction_id") REFERENCES "age_restrictions" ("id") ON DELETE SET NULL;
ALTER TABLE "halls" ADD FOREIGN KEY ("cinema_id") REFERENCES "cinemas" ("id") ON DELETE CASCADE;
ALTER TABLE "seats" ADD FOREIGN KEY ("hall_id") REFERENCES "halls" ("id") ON DELETE CASCADE;
ALTER TABLE "seats" ADD FOREIGN KEY ("seat_type_id") REFERENCES "seat_types" ("id") ON DELETE SET NULL;
ALTER TABLE "showtimes" ADD FOREIGN KEY ("movie_id") REFERENCES "movies" ("id") ON DELETE CASCADE;
ALTER TABLE "showtimes" ADD FOREIGN KEY ("hall_id") REFERENCES "halls" ("id") ON DELETE CASCADE;
ALTER TABLE "tickets" ADD FOREIGN KEY ("showtime_id") REFERENCES "showtimes" ("id") ON DELETE CASCADE;
ALTER TABLE "tickets" ADD FOREIGN KEY ("seat_id") REFERENCES "seats" ("id") ON DELETE SET NULL;
ALTER TABLE "tickets" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE SET NULL;
ALTER TABLE "reservations" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;
ALTER TABLE "online_movies" ADD FOREIGN KEY ("movie_id") REFERENCES "movies" ("id") ON DELETE CASCADE;
ALTER TABLE "online_movies" ADD FOREIGN KEY ("language_id") REFERENCES "languages" ("id") ON DELETE SET NULL;
ALTER TABLE "views" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE SET NULL;
ALTER TABLE "views" ADD FOREIGN KEY ("online_movie_id") REFERENCES "online_movies" ("id") ON DELETE CASCADE;
ALTER TABLE "reviews" ADD FOREIGN KEY ("movie_id") REFERENCES "movies" ("id") ON DELETE CASCADE;
ALTER TABLE "payments" ADD FOREIGN KEY ("reservation_id") REFERENCES "reservations" ("id") ON DELETE CASCADE;
ALTER TABLE "payments" ADD FOREIGN KEY ("payment_method_id") REFERENCES "payment_methods" ("id") ON DELETE SET NULL;
ALTER TABLE "ad_views" ADD FOREIGN KEY ("ad_id") REFERENCES "advertisements" ("id") ON DELETE CASCADE;
ALTER TABLE "ad_views" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE SET NULL;
ALTER TABLE "ad_views" ADD FOREIGN KEY ("view_id") REFERENCES "views" ("id") ON DELETE SET NULL;
ALTER TABLE "movie_actor" ADD FOREIGN KEY ("movie_id") REFERENCES "movies" ("id") ON DELETE CASCADE;
ALTER TABLE "movie_actor" ADD FOREIGN KEY ("actor_id") REFERENCES "actors" ("id") ON DELETE CASCADE;
ALTER TABLE "movie_genre" ADD FOREIGN KEY ("movie_id") REFERENCES "movies" ("id") ON DELETE CASCADE;
ALTER TABLE "movie_genre" ADD FOREIGN KEY ("genre_id") REFERENCES "genres" ("id") ON DELETE CASCADE;
ALTER TABLE "playlist" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;
ALTER TABLE "playlist_movies" ADD FOREIGN KEY ("playlist_id") REFERENCES "playlist" ("id") ON DELETE CASCADE;
ALTER TABLE "playlist_movies" ADD FOREIGN KEY ("movie_id") REFERENCES "movies" ("id") ON DELETE CASCADE;
ALTER TABLE "recommendation" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE;
ALTER TABLE "recommendation" ADD FOREIGN KEY ("movie_id") REFERENCES "movies" ("id") ON DELETE CASCADE;
ALTER TABLE "recommendation" ADD FOREIGN KEY ("review_id") REFERENCES "reviews" ("id") ON DELETE SET NULL;
ALTER TABLE "advertisements" ADD FOREIGN KEY ("type_id") REFERENCES "adv_type" ("id") ON DELETE SET NULL;
ALTER TABLE "movie_director" ADD FOREIGN KEY ("movie_id") REFERENCES "movies" ("id") ON DELETE CASCADE;
ALTER TABLE "movie_director" ADD FOREIGN KEY ("director_id") REFERENCES "directors" ("id") ON DELETE CASCADE;

-- ========================================
-- ИНДЕКСЫ
-- ========================================

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role_id ON users(role_id);
CREATE INDEX idx_movies_title ON movies(title);
CREATE INDEX idx_movies_genre_id ON movies(genre_id);
CREATE INDEX idx_movies_rating ON movies(rating);
CREATE INDEX idx_reviews_movie_id ON reviews(movie_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);
CREATE INDEX idx_showtimes_movie_id ON showtimes(movie_id);
CREATE INDEX idx_showtimes_hall_id ON showtimes(hall_id);
CREATE INDEX idx_tickets_showtime_id ON tickets(showtime_id);
CREATE INDEX idx_tickets_user_id ON tickets(user_id);
CREATE INDEX idx_payments_reservation_id ON payments(reservation_id);
CREATE INDEX idx_ad_views_ad_id ON ad_views(ad_id);
CREATE INDEX idx_ad_views_user_id ON ad_views(user_id);
CREATE INDEX idx_movies_title_hash ON movies USING hash(title);
CREATE INDEX idx_views_timestamp ON views USING brin(view_time);
CREATE INDEX idx_brin_movies_release_date ON movies USING brin(release_date);
CREATE INDEX idx_brin_showtimes_startime ON showtimes USING brin(startime);
CREATE INDEX idx_brin_reviews_created_at ON reviews USING brin(created_at);