CREATE MATERIALIZED VIEW daily_ohlc_prev AS
SELECT 
    day,
    open AS open,
    close AS close,
    high AS high,
    low AS low,
    volume AS volume,
    LAG(open, 1) OVER (ORDER BY day) AS prev_open,      -- Previous day's open
    LAG(close, 1) OVER (ORDER BY day) AS prev_close,    -- Previous day's close
	LAG(high, 1) OVER (ORDER BY day) AS prev_high, 
    LAG(low, 1) OVER (ORDER BY day) AS prev_low, 
	LAG(volume, 1) OVER (ORDER BY day) AS prev_volume, 
    LAG(open, 2) OVER (ORDER BY day) AS prev_prev_open,  -- Second previous day's open
    LAG(close, 2) OVER (ORDER BY day) AS prev_prev_close, -- Second previous day's close
	LAG(high, 2) OVER (ORDER BY day) AS prev_prev_high, 
    LAG(low, 2) OVER (ORDER BY day) AS prev_prev_low, 
	LAG(volume, 2) OVER (ORDER BY day) AS prev_prev_volume 
FROM 
    daily_ohlc_aligned
ORDER BY day;
