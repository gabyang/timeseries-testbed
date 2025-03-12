CREATE TABLE daily_ohlc_optimised (
    day DATE PRIMARY KEY,
    open INT NOT NULL,
    high INT NOT NULL,
    low INT NOT NULL,
    close INT NOT NULL,
    volume INT NOT NULL
);
SELECT create_hypertable('daily_ohlc_optimised', 'day', chunk_time_interval => INTERVAL '30 year');
INSERT INTO daily_ohlc_optimised (day, open, high, low, close, volume)
SELECT 
    day,
    FLOOR(open * 100)::INT AS open,
    FLOOR(high * 100)::INT AS high,
    FLOOR(low * 100)::INT AS low,
    FLOOR(close * 100)::INT AS close,
    volume::INT AS volume
FROM daily_ohlc;
