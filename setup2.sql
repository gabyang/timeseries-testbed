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
