-- Функция проверки возрастного ограничения
CREATE OR REPLACE FUNCTION check_age_restriction()
RETURNS TRIGGER AS $$
DECLARE
  v_user_age INT;
  v_movie_age_restriction INT;
BEGIN
  SELECT age INTO v_user_age
  FROM users
  WHERE id = NEW.user_id;

  SELECT ar.age_restriction INTO v_movie_age_restriction
  FROM movies m
  JOIN age_restrictions ar ON m.age_restriction_id = ar.id
  JOIN showtimes s ON m.id = s.movie_id
  WHERE s.id = NEW.showtime_id;

  IF v_user_age < v_movie_age_restriction THEN
    RAISE EXCEPTION 'User is not old enough to watch this movie. Required: %+, User age: %',
      v_movie_age_restriction, v_user_age;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Триггер проверки возраста при покупке билета
CREATE TRIGGER check_age_restriction_trigger
BEFORE INSERT ON tickets
FOR EACH ROW EXECUTE FUNCTION check_age_restriction();


-- Функция уменьшения свободных мест при покупке билетов
CREATE OR REPLACE FUNCTION update_seats() RETURNS TRIGGER AS $$
DECLARE
  v_capacity INTEGER;
  v_sold_tickets INTEGER;
BEGIN
  SELECT h.capacity INTO v_capacity
  FROM halls h
  JOIN showtimes s ON h.id = s.hall_id
  WHERE s.id = NEW.showtime_id;

  SELECT COUNT(*) INTO v_sold_tickets
  FROM tickets
  WHERE showtime_id = NEW.showtime_id;

  IF v_sold_tickets >= v_capacity THEN
    RAISE EXCEPTION 'Недостаточно свободных мест';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_seats_after_insert
BEFORE INSERT ON tickets
FOR EACH ROW EXECUTE FUNCTION update_seats();


-- Функция проверки уникальности места на сеансе
CREATE OR REPLACE FUNCTION check_seat_uniqueness() RETURNS TRIGGER AS $$
DECLARE
  v_seat_exists INTEGER;
BEGIN
  SELECT COUNT(*) INTO v_seat_exists
  FROM tickets
  WHERE showtime_id = NEW.showtime_id
    AND seat_id = NEW.seat_id;

  IF v_seat_exists > 0 THEN
    RAISE EXCEPTION 'Это место уже занято на данном сеансе';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_seat_uniqueness_trigger
BEFORE INSERT ON tickets
FOR EACH ROW EXECUTE FUNCTION check_seat_uniqueness();


-- Функция автоматического обновления рейтинга фильма при добавлении/удалении отзывов
CREATE OR REPLACE FUNCTION update_movie_rating()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE movies
  SET rating = (
    SELECT ROUND(AVG(rating)::numeric, 1)
    FROM reviews
    WHERE movie_id = COALESCE(NEW.movie_id, OLD.movie_id)
  )
  WHERE id = COALESCE(NEW.movie_id, OLD.movie_id);
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_movie_rating_trigger
AFTER INSERT OR UPDATE OR DELETE ON reviews
FOR EACH ROW EXECUTE FUNCTION update_movie_rating();

-- Функция динамического ценообразования на основе заполненности зала
CREATE OR REPLACE FUNCTION dynamic_pricing() RETURNS TRIGGER AS $$
DECLARE
    tickets_sold INT;
    hall_capacity INT;
    occupancy_rate DECIMAL(5,2);
BEGIN
    SELECT COUNT(*) INTO tickets_sold
    FROM tickets
    WHERE showtime_id = NEW.showtime_id;

    SELECT h.capacity INTO hall_capacity
    FROM halls h
    JOIN showtimes s ON h.id = s.hall_id
    WHERE s.id = NEW.showtime_id;

    IF hall_capacity > 0 THEN
        occupancy_rate = (tickets_sold::DECIMAL / hall_capacity) * 100;

        IF occupancy_rate > 70 THEN
            NEW.price = NEW.price * 1.2;
        ELSIF occupancy_rate > 50 THEN
            NEW.price = NEW.price * 1.1;
        ELSIF occupancy_rate < 20 THEN
            NEW.price = NEW.price * 0.9;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER pricing_trigger
BEFORE INSERT ON tickets
FOR EACH ROW EXECUTE FUNCTION dynamic_pricing();


-- Функция автоматической генерации просмотра рекламы при просмотре онлайн-фильма
CREATE OR REPLACE FUNCTION generate_ad_view()
RETURNS TRIGGER AS $$
DECLARE
  v_ad_id INTEGER;
  v_movie_id INTEGER;
BEGIN
  SELECT movie_id INTO v_movie_id
  FROM online_movies
  WHERE id = NEW.online_movie_id;

  SELECT a.id INTO v_ad_id
  FROM advertisements a
  JOIN adv_type at ON a.type_id = at.id
  ORDER BY at.priority DESC, RANDOM()
  LIMIT 1;

  IF v_ad_id IS NOT NULL THEN
    INSERT INTO ad_views (ad_id, view_id, user_id, viewed_at, successful)
    VALUES (v_ad_id, NEW.id, NEW.user_id, NOW(), FALSE);
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER generate_ad_view_trigger
AFTER INSERT ON views
FOR EACH ROW EXECUTE FUNCTION generate_ad_view();