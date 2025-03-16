-- because optimisation should work on all patterns, and there exist patterns that reference data from the previous 4 days, so materialized view is created with 5-day duration.
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
	LAG(volume, 2) OVER (ORDER BY day) AS prev_prev_volume,
    LAG(open, 3) OVER (ORDER BY day) AS prev3_open, 
    LAG(close, 3) OVER (ORDER BY day) AS prev3_close, 
	LAG(high, 3) OVER (ORDER BY day) AS prev3_high, 
    LAG(low, 3) OVER (ORDER BY day) AS prev3_low, 
	LAG(volume, 3) OVER (ORDER BY day) AS prev3_volume,
    LAG(open, 4) OVER (ORDER BY day) AS prev4_open, 
    LAG(close, 4) OVER (ORDER BY day) AS prev4_close, 
	LAG(high, 4) OVER (ORDER BY day) AS prev4_high, 
    LAG(low, 4) OVER (ORDER BY day) AS prev4_low, 
	LAG(volume, 4) OVER (ORDER BY day) AS prev4_volume
FROM 
    daily_ohlc_optimised
    -- or daily_ohlc
ORDER BY day;
