-- ========================================
-- SEED DATA - Инициализация тестовых данных
-- ========================================

-- Очистка данных (если нужно перезапустить)
-- TRUNCATE TABLE playlist_movies, playlist, recommendation, movie_genre, movie_actor, movie_director,
-- ad_views, advertisements, adv_type, payments, payment_methods, reviews, views, online_movies,
-- reservations, tickets, showtimes, seats, seat_types, halls, cinemas, actors, directors, movies,
-- genres, countries, languages, age_restrictions, users, user_roles RESTART IDENTITY CASCADE;

-- ========================================
-- 1. СПРАВОЧНИКИ (Dictionaries)
-- ========================================

-- Роли пользователей
INSERT INTO user_roles (name) VALUES
  ('admin'),
  ('user'),
  ('moderator'),
  ('vip')
ON CONFLICT DO NOTHING;

-- Жанры
INSERT INTO genres (name) VALUES
  ('Action'),
  ('Drama'),
  ('Comedy'),
  ('Horror'),
  ('Sci-Fi'),
  ('Thriller'),
  ('Romance'),
  ('Documentary'),
  ('Fantasy'),
  ('Animation')
ON CONFLICT DO NOTHING;

-- Страны
INSERT INTO countries (name) VALUES
  ('USA'),
  ('Russia'),
  ('UK'),
  ('France'),
  ('Japan'),
  ('South Korea'),
  ('Germany'),
  ('Italy'),
  ('Spain'),
  ('Canada')
ON CONFLICT DO NOTHING;

-- Возрастные ограничения
INSERT INTO age_restrictions (age_restriction) VALUES
  (0),
  (6),
  (12),
  (16),
  (18)
ON CONFLICT DO NOTHING;

-- Языки
INSERT INTO languages (name) VALUES
  ('English'),
  ('Russian'),
  ('Spanish'),
  ('French'),
  ('Japanese'),
  ('Korean'),
  ('German'),
  ('Italian')
ON CONFLICT DO NOTHING;

-- Типы мест
INSERT INTO seat_types (name) VALUES
  ('standard'),
  ('vip'),
  ('premium'),
  ('couple')
ON CONFLICT DO NOTHING;

-- Методы оплаты
INSERT INTO payment_methods (name) VALUES
  ('cash'),
  ('card'),
  ('online'),
  ('apple_pay'),
  ('google_pay')
ON CONFLICT DO NOTHING;

-- Типы рекламы
INSERT INTO adv_type (name, priority) VALUES
  ('Premium', 100),
  ('Standard', 50),
  ('Basic', 10),
  ('Partner', 75)
ON CONFLICT DO NOTHING;

-- ========================================
-- 2. ПОЛЬЗОВАТЕЛИ
-- ========================================

INSERT INTO users (first_name, last_name, email, password, contact_num, role_id, age) VALUES
  -- Админ
  ('Admin', 'Adminov', 'admin@cinema.com', 'admin123', '+79991234567', 1, 30),

  -- Активные пользователи с плейлистами и историей
  ('Ivan', 'Petrov', 'ivan@example.com', 'password123', '+79991234568', 2, 25),
  ('Maria', 'Smirnova', 'maria@example.com', 'password123', '+79991234569', 2, 28),
  ('Alexey', 'Kozlov', 'alexey@example.com', 'password123', '+79991234570', 4, 35),

  -- Пользователи только с просмотрами
  ('Elena', 'Volkova', 'elena@example.com', 'password123', '+79991234571', 2, 22),
  ('Dmitry', 'Sokolov', 'dmitry@example.com', 'password123', '+79991234572', 2, 40),

  -- Новые пользователи без истории
  ('Anna', 'Novikova', 'anna@example.com', 'password123', '+79991234573', 2, 19),
  ('Sergey', 'Lebedev', 'sergey@example.com', 'password123', '+79991234574', 2, 17),
  ('Olga', 'Morozova', 'olga@example.com', 'password123', '+79991234575', 2, 45),

  -- Модератор
  ('Moderator', 'User', 'moderator@cinema.com', 'mod123', '+79991234576', 3, 32);

-- ========================================
-- 3. АКТЕРЫ И РЕЖИССЕРЫ
-- ========================================

INSERT INTO directors (first_name, last_name) VALUES
  ('Christopher', 'Nolan'),
  ('Steven', 'Spielberg'),
  ('Quentin', 'Tarantino'),
  ('Martin', 'Scorsese'),
  ('James', 'Cameron'),
  ('Denis', 'Villeneuve'),
  ('Ridley', 'Scott'),
  ('David', 'Fincher'),
  ('Andrey', 'Zvyagintsev'),
  ('Timur', 'Bekmambetov');

INSERT INTO actors (first_name, last_name) VALUES
  ('Leonardo', 'DiCaprio'),
  ('Tom', 'Hanks'),
  ('Brad', 'Pitt'),
  ('Morgan', 'Freeman'),
  ('Robert', 'De Niro'),
  ('Scarlett', 'Johansson'),
  ('Ryan', 'Gosling'),
  ('Emma', 'Stone'),
  ('Konstantin', 'Khabensky'),
  ('Danila', 'Kozlovsky');

-- ========================================
-- 4. ФИЛЬМЫ
-- ========================================

INSERT INTO movies (title, description, release_date, rating, duration, genre_id, country_id, age_restriction_id) VALUES
  -- Action
  ('Inception', 'A thief who steals corporate secrets through dream-sharing technology', '2010-07-16', 8.8, '02:28:00', 1, 1, 4),
  ('The Matrix', 'A computer hacker learns about the true nature of reality', '1999-03-31', 8.7, '02:16:00', 5, 1, 4),
  ('Mad Max: Fury Road', 'In a post-apocalyptic wasteland, a woman rebels', '2015-05-15', 8.1, '02:00:00', 1, 1, 5),

  -- Drama
  ('The Shawshank Redemption', 'Two imprisoned men bond over years', '1994-09-23', 9.3, '02:22:00', 2, 1, 4),
  ('Forrest Gump', 'The presidencies of Kennedy and Johnson unfold', '1994-07-06', 8.8, '02:22:00', 2, 1, 3),
  ('Leviathan', 'A Russian drama about corruption', '2014-09-04', 7.6, '02:20:00', 2, 2, 5),

  -- Comedy
  ('The Grand Budapest Hotel', 'The adventures of a legendary concierge', '2014-03-28', 8.1, '01:39:00', 3, 1, 3),
  ('Intouchables', 'A quadriplegic aristocrat hires a young man as his caretaker', '2011-11-02', 8.5, '01:52:00', 3, 4, 3),

  -- Horror
  ('The Shining', 'A family heads to an isolated hotel', '1980-05-23', 8.4, '02:26:00', 4, 1, 5),
  ('Get Out', 'A young African-American visits his white girlfriend', '2017-02-24', 7.7, '01:44:00', 4, 1, 5),

  -- Sci-Fi
  ('Interstellar', 'A team of explorers travel through a wormhole', '2014-11-07', 8.6, '02:49:00', 5, 1, 4),
  ('Blade Runner 2049', 'A young blade runner discovers a secret', '2017-10-06', 8.0, '02:44:00', 5, 1, 4),
  ('Dune', 'Paul Atreides arrives on the desert planet Arrakis', '2021-10-22', 8.0, '02:35:00', 5, 1, 4),

  -- Thriller
  ('Se7en', 'Two detectives hunt a serial killer', '1995-09-22', 8.6, '02:07:00', 6, 1, 5),
  ('Fight Club', 'An insomniac office worker forms a fight club', '1999-10-15', 8.8, '02:19:00', 6, 1, 5),

  -- Romance
  ('La La Land', 'A jazz musician and an aspiring actress fall in love', '2016-12-09', 8.0, '02:08:00', 7, 1, 3),

  -- Animation
  ('Spirited Away', 'A young girl enters a world of spirits', '2001-07-20', 8.6, '02:05:00', 10, 5, 2),
  ('WALL-E', 'A robot falls in love with another robot', '2008-06-27', 8.4, '01:38:00', 10, 1, 1),

  -- Fantasy
  ('Harry Potter and the Prisoner of Azkaban', 'Harry Potter learns of an escaped prisoner', '2004-05-31', 7.9, '02:22:00', 9, 3, 3),
  ('The Lord of the Rings: The Fellowship', 'A meek Hobbit sets out on a journey', '2001-12-19', 8.8, '02:58:00', 9, 1, 3);

-- ========================================
-- 5. СВЯЗИ ФИЛЬМОВ (жанры, актеры, режиссеры)
-- ========================================

-- Жанры фильмов (многие-ко-многим)
INSERT INTO movie_genre (movie_id, genre_id) VALUES
  (1, 1), (1, 5), (1, 6),  -- Inception: Action, Sci-Fi, Thriller
  (2, 1), (2, 5),          -- Matrix: Action, Sci-Fi
  (3, 1),                  -- Mad Max: Action
  (4, 2),                  -- Shawshank: Drama
  (5, 2), (5, 3),          -- Forrest Gump: Drama, Comedy
  (6, 2),                  -- Leviathan: Drama
  (7, 3),                  -- Grand Budapest: Comedy
  (8, 3), (8, 2),          -- Intouchables: Comedy, Drama
  (9, 4), (9, 6),          -- Shining: Horror, Thriller
  (10, 4), (10, 6),        -- Get Out: Horror, Thriller
  (11, 5), (11, 2),        -- Interstellar: Sci-Fi, Drama
  (12, 5), (12, 6),        -- Blade Runner: Sci-Fi, Thriller
  (13, 5), (13, 1),        -- Dune: Sci-Fi, Action
  (14, 6),                 -- Se7en: Thriller
  (15, 6), (15, 2),        -- Fight Club: Thriller, Drama
  (16, 7), (16, 3),        -- La La Land: Romance, Comedy
  (17, 10), (17, 9),       -- Spirited Away: Animation, Fantasy
  (18, 10), (18, 5),       -- WALL-E: Animation, Sci-Fi
  (19, 9),                 -- Harry Potter: Fantasy
  (20, 9), (20, 1);        -- LOTR: Fantasy, Action

-- Режиссеры фильмов
INSERT INTO movie_director (movie_id, director_id) VALUES
  (1, 1),   -- Inception - Nolan
  (2, 1),   -- Matrix - Nolan (для примера)
  (4, 4),   -- Shawshank - Scorsese (для примера)
  (5, 2),   -- Forrest Gump - Spielberg
  (6, 9),   -- Leviathan - Zvyagintsev
  (11, 1),  -- Interstellar - Nolan
  (12, 6),  -- Blade Runner 2049 - Villeneuve
  (13, 6),  -- Dune - Villeneuve
  (14, 8),  -- Se7en - Fincher
  (15, 8);  -- Fight Club - Fincher

-- Актеры в фильмах
INSERT INTO movie_actor (movie_id, actor_id) VALUES
  (1, 1),   -- Inception - DiCaprio
  (4, 4),   -- Shawshank - Freeman
  (5, 2),   -- Forrest Gump - Hanks
  (6, 9),   -- Leviathan - Khabensky
  (11, 1),  -- Interstellar - DiCaprio (для примера)
  (12, 7),  -- Blade Runner - Gosling
  (14, 3),  -- Se7en - Pitt
  (14, 4),  -- Se7en - Freeman
  (15, 3),  -- Fight Club - Pitt
  (16, 7),  -- La La Land - Gosling
  (16, 8);  -- La La Land - Stone

-- ========================================
-- 6. ОНЛАЙН ФИЛЬМЫ
-- ========================================

INSERT INTO online_movies (movie_id, language_id, url, created_at, updated_at) VALUES
  (1, 1, 'https://stream.cinema.com/inception-en', NOW(), NOW()),
  (1, 2, 'https://stream.cinema.com/inception-ru', NOW(), NOW()),
  (2, 1, 'https://stream.cinema.com/matrix-en', NOW(), NOW()),
  (4, 1, 'https://stream.cinema.com/shawshank-en', NOW(), NOW()),
  (5, 1, 'https://stream.cinema.com/forrest-en', NOW(), NOW()),
  (5, 2, 'https://stream.cinema.com/forrest-ru', NOW(), NOW()),
  (6, 2, 'https://stream.cinema.com/leviathan-ru', NOW(), NOW()),
  (11, 1, 'https://stream.cinema.com/interstellar-en', NOW(), NOW()),
  (12, 1, 'https://stream.cinema.com/blade-runner-en', NOW(), NOW()),
  (13, 1, 'https://stream.cinema.com/dune-en', NOW(), NOW()),
  (17, 5, 'https://stream.cinema.com/spirited-away-jp', NOW(), NOW()),
  (18, 1, 'https://stream.cinema.com/wall-e-en', NOW(), NOW());

-- ========================================
-- 7. ПРОСМОТРЫ ОНЛАЙН ФИЛЬМОВ
-- ========================================

-- Пользователь 2 (Ivan) - активный, смотрит Sci-Fi
INSERT INTO views (online_movie_id, view_time, view_dur_time, user_id) VALUES
  (1, NOW() - INTERVAL '10 days', '02:28:00', 2),  -- Inception полностью
  (3, NOW() - INTERVAL '8 days', '02:10:00', 2),   -- Matrix почти полностью
  (8, NOW() - INTERVAL '5 days', '02:40:00', 2),   -- Interstellar полностью
  (9, NOW() - INTERVAL '3 days', '01:30:00', 2);   -- Blade Runner частично

-- Пользователь 3 (Maria) - любит драмы и романтику
INSERT INTO views (online_movie_id, view_time, view_dur_time, user_id) VALUES
  (4, NOW() - INTERVAL '15 days', '02:22:00', 3),  -- Shawshank полностью
  (5, NOW() - INTERVAL '12 days', '02:20:00', 3),  -- Forrest Gump
  (6, NOW() - INTERVAL '7 days', '01:00:00', 3);   -- Forrest Gump RU частично

-- Пользователь 4 (Alexey) - VIP, смотрит много разного
INSERT INTO views (online_movie_id, view_time, view_dur_time, user_id) VALUES
  (1, NOW() - INTERVAL '20 days', '02:28:00', 4),
  (3, NOW() - INTERVAL '18 days', '02:16:00', 4),
  (4, NOW() - INTERVAL '16 days', '02:22:00', 4),
  (8, NOW() - INTERVAL '14 days', '02:49:00', 4),
  (10, NOW() - INTERVAL '10 days', '02:35:00', 4),
  (12, NOW() - INTERVAL '5 days', '01:38:00', 4);

-- Пользователь 5 (Elena) - только просмотры, без плейлистов
INSERT INTO views (online_movie_id, view_time, view_dur_time, user_id) VALUES
  (11, NOW() - INTERVAL '6 days', '02:05:00', 5),  -- Spirited Away
  (12, NOW() - INTERVAL '4 days', '01:38:00', 5);  -- WALL-E

-- Пользователь 6 (Dmitry) - смотрит редко
INSERT INTO views (online_movie_id, view_time, view_dur_time, user_id) VALUES
  (5, NOW() - INTERVAL '30 days', '00:45:00', 6);  -- Forrest Gump частично

-- ========================================
-- 8. ОТЗЫВЫ
-- ========================================

INSERT INTO reviews (movie_id, rating, comment, created_at, updated_at) VALUES
  -- На Inception
  (1, 5, 'Mind-blowing! Best sci-fi movie ever!', NOW() - INTERVAL '9 days', NOW() - INTERVAL '9 days'),
  (1, 5, 'Потрясающий фильм, пересматриваю каждый год', NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days'),
  (1, 4, 'Confusing but brilliant', NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days'),

  -- На Shawshank
  (4, 5, 'The greatest movie of all time', NOW() - INTERVAL '14 days', NOW() - INTERVAL '14 days'),
  (4, 5, 'Perfect in every way', NOW() - INTERVAL '13 days', NOW() - INTERVAL '13 days'),

  -- На Interstellar
  (11, 5, 'Emotional and scientifically accurate', NOW() - INTERVAL '4 days', NOW() - INTERVAL '4 days'),
  (11, 4, 'Great visuals, touching story', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days'),

  -- На Dune
  (13, 5, 'Visually stunning masterpiece', NOW() - INTERVAL '9 days', NOW() - INTERVAL '9 days'),
  (13, 4, 'Great adaptation of the book', NOW() - INTERVAL '8 days', NOW() - INTERVAL '8 days'),

  -- На Spirited Away
  (17, 5, 'Beautiful animation and story', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),

  -- На WALL-E
  (18, 5, 'Touching story without many words', NOW() - INTERVAL '3 days', NOW() - INTERVAL '3 days');

-- ========================================
-- 9. ПЛЕЙЛИСТЫ
-- ========================================

-- Пользователь 2 (Ivan) - любитель Sci-Fi
INSERT INTO playlist (user_id, name) VALUES
  (2, 'My Sci-Fi Collection'),
  (2, 'To Watch Later');

-- Пользователь 3 (Maria) - драмы
INSERT INTO playlist (user_id, name) VALUES
  (3, 'Best Dramas'),
  (3, 'Date Night Movies');

-- Пользователь 4 (Alexey) - VIP с большой коллекцией
INSERT INTO playlist (user_id, name) VALUES
  (4, 'Favorites'),
  (4, 'Nolan Films'),
  (4, 'Weekend Watch');

-- Фильмы в плейлистах
INSERT INTO playlist_movies (movie_id, playlist_id, created_at) VALUES
  -- Ivan's Sci-Fi
  (1, 1, NOW() - INTERVAL '10 days'),
  (2, 1, NOW() - INTERVAL '9 days'),
  (11, 1, NOW() - INTERVAL '5 days'),
  (12, 1, NOW() - INTERVAL '4 days'),
  (13, 1, NOW() - INTERVAL '3 days'),

  -- Ivan's To Watch
  (9, 2, NOW() - INTERVAL '2 days'),
  (10, 2, NOW() - INTERVAL '2 days'),

  -- Maria's Dramas
  (4, 3, NOW() - INTERVAL '15 days'),
  (5, 3, NOW() - INTERVAL '12 days'),
  (6, 3, NOW() - INTERVAL '10 days'),

  -- Maria's Date Night
  (16, 4, NOW() - INTERVAL '6 days'),
  (8, 4, NOW() - INTERVAL '5 days'),

  -- Alexey's Favorites
  (1, 5, NOW() - INTERVAL '20 days'),
  (4, 5, NOW() - INTERVAL '18 days'),
  (11, 5, NOW() - INTERVAL '15 days'),

  -- Alexey's Nolan
  (1, 6, NOW() - INTERVAL '20 days'),
  (11, 6, NOW() - INTERVAL '14 days'),

  -- Alexey's Weekend
  (17, 7, NOW() - INTERVAL '8 days'),
  (18, 7, NOW() - INTERVAL '7 days');

-- ========================================
-- 10. КИНОТЕАТРЫ И ЗАЛЫ
-- ========================================

INSERT INTO cinemas (name, address) VALUES
  ('Cinema Park Premium', 'Moscow, Tverskaya St., 12'),
  ('Karo Film', 'Moscow, Arbat St., 45'),
  ('Formula Kino', 'St. Petersburg, Nevsky Prospect, 100'),
  ('Luxor Cinema', 'Kazan, Bauman St., 25');

-- Залы
INSERT INTO halls (cinema_id, hall_num, capacity) VALUES
  -- Cinema Park Premium
  (1, 1, 150),
  (1, 2, 200),
  (1, 3, 100),  -- VIP зал

  -- Karo Film
  (2, 1, 180),
  (2, 2, 120),

  -- Formula Kino
  (3, 1, 250),
  (3, 2, 150),
  (3, 3, 80),   -- IMAX

  -- Luxor
  (4, 1, 100),
  (4, 2, 120);

-- Места в залах
DO $$
DECLARE
  hall_record RECORD;
  row_num INT;
  seat_num INT;
  seat_type INT;
BEGIN
  FOR hall_record IN SELECT id, capacity FROM halls LOOP
    FOR row_num IN 1..10 LOOP
      FOR seat_num IN 1..(hall_record.capacity / 10) LOOP
        -- Определяем тип места
        IF row_num <= 2 THEN
          seat_type := 1;  -- standard (первые ряды)
        ELSIF row_num >= 8 THEN
          seat_type := 2;  -- vip (задние ряды)
        ELSIF seat_num IN (5, 6) AND row_num IN (5, 6) THEN
          seat_type := 3;  -- premium (центр)
        ELSE
          seat_type := 1;  -- standard
        END IF;

        INSERT INTO seats (hall_id, row_num, seat_num, seat_type_id)
        VALUES (hall_record.id, row_num, seat_num, seat_type);
      END LOOP;
    END LOOP;
  END LOOP;
END $$;

-- ========================================
-- 11. СЕАНСЫ
-- ========================================

-- Текущие и будущие сеансы
INSERT INTO showtimes (movie_id, hall_id, startime) VALUES
  -- Сегодня
  (13, 1, NOW() + INTERVAL '3 hours'),   -- Dune
  (13, 4, NOW() + INTERVAL '5 hours'),
  (11, 2, NOW() + INTERVAL '4 hours'),   -- Interstellar
  (12, 3, NOW() + INTERVAL '6 hours'),   -- Blade Runner

  -- Завтра
  (13, 1, NOW() + INTERVAL '1 day' + INTERVAL '3 hours'),
  (13, 6, NOW() + INTERVAL '1 day' + INTERVAL '5 hours'),
  (11, 2, NOW() + INTERVAL '1 day' + INTERVAL '4 hours'),
  (1, 5, NOW() + INTERVAL '1 day' + INTERVAL '7 hours'),
  (16, 7, NOW() + INTERVAL '1 day' + INTERVAL '8 hours'),

  -- Через 2 дня
  (13, 8, NOW() + INTERVAL '2 days' + INTERVAL '4 hours'),
  (18, 9, NOW() + INTERVAL '2 days' + INTERVAL '2 hours'),
  (17, 10, NOW() + INTERVAL '2 days' + INTERVAL '3 hours'),

  -- Прошлые сеансы (для статистики)
  (1, 1, NOW() - INTERVAL '2 days'),
  (1, 2, NOW() - INTERVAL '2 days'),
  (11, 3, NOW() - INTERVAL '3 days'),
  (4, 4, NOW() - INTERVAL '5 days'),
  (5, 5, NOW() - INTERVAL '5 days');

-- ========================================
-- 12. БИЛЕТЫ И БРОНИРОВАНИЯ
-- ========================================

-- Бронирования
INSERT INTO reservations (user_id, reservation_time) VALUES
  (2, NOW() - INTERVAL '2 days'),
  (3, NOW() - INTERVAL '2 days'),
  (4, NOW() - INTERVAL '3 days'),
  (4, NOW() - INTERVAL '5 days'),
  (5, NOW() - INTERVAL '5 days'),
  (2, NOW() + INTERVAL '1 hour'),  -- Будущее бронирование
  (3, NOW() + INTERVAL '2 hours');

-- Билеты на прошлые сеансы
INSERT INTO tickets (showtime_id, seat_id, user_id, price) VALUES
  -- Сеанс 13 (прошлый, Inception)
  (13, 15, 2, 500.00),
  (13, 16, 2, 500.00),
  (14, 215, 3, 500.00),
  (14, 216, 3, 500.00),

  -- Сеанс 15 (прошлый, Interstellar)
  (15, 315, 4, 600.00),
  (15, 316, 4, 600.00),
  (15, 317, 4, 600.00),

  -- Сеанс 16 (прошлый, Shawshank)
  (16, 415, 5, 450.00),

  -- Сеанс 17 (прошлый, Forrest Gump)
  (17, 515, 4, 450.00),
  (17, 516, 4, 450.00);

-- Билеты на будущие сеансы
INSERT INTO tickets (showtime_id, seat_id, user_id, price) VALUES
  -- Сеанс 1 (сегодня, Dune)
  (1, 55, 2, 700.00),
  (1, 56, 2, 700.00),

  -- Сеанс 5 (завтра, Dune)
  (5, 65, 3, 700.00),
  (5, 66, 3, 700.00);

-- ========================================
-- 13. ПЛАТЕЖИ
-- ========================================

INSERT INTO payments (reservation_id, payment_method_id, created_at, amount) VALUES
  (1, 2, NOW() - INTERVAL '2 days', 1000.00),   -- card
  (2, 3, NOW() - INTERVAL '2 days', 1000.00),   -- online
  (3, 2, NOW() - INTERVAL '3 days', 1800.00),   -- card
  (4, 4, NOW() - INTERVAL '5 days', 900.00),    -- apple_pay
  (5, 1, NOW() - INTERVAL '5 days', 450.00),    -- cash
  (6, 3, NOW() + INTERVAL '1 hour', 1400.00),   -- online (предоплата)
  (7, 2, NOW() + INTERVAL '2 hours', 1400.00);  -- card (предоплата)

-- ========================================
-- 14. РЕКЛАМА
-- ========================================

INSERT INTO advertisements (title, description, url, type_id) VALUES
  ('Coca-Cola Summer Campaign', 'Refresh yourself this summer', 'https://ads.cinema.com/coca-cola', 1),
  ('New iPhone 15 Pro', 'The most powerful iPhone ever', 'https://ads.cinema.com/iphone', 1),
  ('McDonald''s Movie Combo', 'Special offer for cinema visitors', 'https://ads.cinema.com/mcdonalds', 2),
  ('Car Insurance Promo', 'Get 20% off on car insurance', 'https://ads.cinema.com/insurance', 3),
  ('Local Restaurant', 'Visit our restaurant after the movie', 'https://ads.cinema.com/restaurant', 4),
  ('Upcoming Movie Trailer', 'Don''t miss the premiere next month', 'https://ads.cinema.com/trailer', 1);

-- Просмотры рекламы (автоматически создаются триггером при просмотре фильмов)
-- Но добавим несколько вручную для статистики
INSERT INTO ad_views (ad_id, view_id, user_id, viewed_at, successful) VALUES
  (1, 1, 2, NOW() - INTERVAL '10 days', TRUE),
  (2, 2, 2, NOW() - INTERVAL '8 days', TRUE),
  (3, 3, 2, NOW() - INTERVAL '5 days', FALSE),
  (1, 4, 3, NOW() - INTERVAL '15 days', TRUE),
  (2, 5, 3, NOW() - INTERVAL '12 days', TRUE),
  (4, 6, 4, NOW() - INTERVAL '20 days', TRUE),
  (5, 7, 4, NOW() - INTERVAL '18 days', FALSE),
  (6, 11, 5, NOW() - INTERVAL '6 days', TRUE);

-- ========================================
-- 15. РЕКОМЕНДАЦИИ
-- ========================================

-- Автоматические рекомендации на основе просмотров и плейлистов
INSERT INTO recommendation (user_id, movie_id, review_id, created_at) VALUES
  -- Для Ivan (любит Sci-Fi)
  (2, 13, NULL, NOW() - INTERVAL '2 days'),  -- Dune
  (2, 9, NULL, NOW() - INTERVAL '1 day'),    -- The Shining

  -- Для Maria (любит драмы)
  (3, 6, NULL, NOW() - INTERVAL '5 days'),   -- Leviathan
  (3, 16, NULL, NOW() - INTERVAL '3 days'),  -- La La Land

  -- Для Alexey (смотрит всё)
  (4, 14, NULL, NOW() - INTERVAL '8 days'),  -- Se7en
  (4, 15, NULL, NOW() - INTERVAL '7 days'),  -- Fight Club

  -- Для Elena (любит анимацию)
  (5, 19, NULL, NOW() - INTERVAL '2 days'),  -- Harry Potter

  -- Для новых пользователей - популярные фильмы
  (7, 1, NULL, NOW()),   -- Inception
  (7, 4, NULL, NOW()),   -- Shawshank
  (8, 1, NULL, NOW()),
  (9, 11, NULL, NOW());  -- Interstellar

-- ========================================
-- ИТОГОВАЯ СТАТИСТИКА
-- ========================================

-- Вывод статистики
DO $$
BEGIN
  RAISE NOTICE '========================================';
  RAISE NOTICE 'DATABASE INITIALIZATION COMPLETED';
  RAISE NOTICE '========================================';
  RAISE NOTICE 'Users: %', (SELECT COUNT(*) FROM users);
  RAISE NOTICE 'Movies: %', (SELECT COUNT(*) FROM movies);
  RAISE NOTICE 'Online Movies: %', (SELECT COUNT(*) FROM online_movies);
  RAISE NOTICE 'Cinemas: %', (SELECT COUNT(*) FROM cinemas);
  RAISE NOTICE 'Halls: %', (SELECT COUNT(*) FROM halls);
  RAISE NOTICE 'Seats: %', (SELECT COUNT(*) FROM seats);
  RAISE NOTICE 'Showtimes: %', (SELECT COUNT(*) FROM showtimes);
  RAISE NOTICE 'Tickets: %', (SELECT COUNT(*) FROM tickets);
  RAISE NOTICE 'Views: %', (SELECT COUNT(*) FROM views);
  RAISE NOTICE 'Reviews: %', (SELECT COUNT(*) FROM reviews);
  RAISE NOTICE 'Playlists: %', (SELECT COUNT(*) FROM playlist);
  RAISE NOTICE 'Playlist Movies: %', (SELECT COUNT(*) FROM playlist_movies);
  RAISE NOTICE 'Recommendations: %', (SELECT COUNT(*) FROM recommendation);
  RAISE NOTICE 'Advertisements: %', (SELECT COUNT(*) FROM advertisements);
  RAISE NOTICE 'Ad Views: %', (SELECT COUNT(*) FROM ad_views);
  RAISE NOTICE '========================================';
END $$;