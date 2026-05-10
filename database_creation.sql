CREATE TABLE IF NOT EXISTS user_events (
    event_id        INT,
    user_id         INT,
    event_type      VARCHAR(50),
    event_date      TIMESTAMP,
    product_id      INT,
    amount          NUMERIC(10, 2),
    traffic_source  VARCHAR(50)
);

copy user_events FROM 'data/user_events.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',', NULL '');
