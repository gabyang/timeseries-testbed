CREATE TABLE daily_ohlc (
    day DATE PRIMARY KEY,
    open NUMERIC NOT NULL,
    high NUMERIC NOT NULL,
    low NUMERIC NOT NULL,
    close NUMERIC NOT NULL,
    volume NUMERIC NOT NULL
);

SELECT create_hypertable('daily_ohlc', 'day');

INSERT INTO daily_ohlc (day, open, high, low, close, volume)
SELECT 
    time::DATE AS day,
    first(open, time) AS open,
    MAX(high) AS high,
    MIN(low) AS low,
    last(close, time) AS close,
    SUM(volume) AS volume
FROM stock_ticks
GROUP BY day
ORDER BY day;
