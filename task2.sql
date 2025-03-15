-- Task 2 
-- Find Engulfing Bullish pattern
-- INSERT INTO engulfing_bullish_patterns (day, open, high, low, close, volume)
SELECT day, open, high, low, close, volume
FROM (
    SELECT *,
           LAG(open) OVER (ORDER BY day) AS prev_open,
           LAG(close) OVER (ORDER BY day) AS prev_close
    FROM daily_ohlc
    -- FROM daily_ohlc_optimised
) AS sub
WHERE prev_close < prev_open  -- Previous day is bearish
  AND close > open            -- Current day is bullish
  AND open < prev_close       -- The bullish candle opens lower than the previous close
  AND close > prev_open;      -- The bullish candle fully engulfs the bearish one


-- Find Piercing Line pattern
-- INSERT INTO piercing_line_patterns (day, open, high, low, close, volume)
SELECT day, open, high, low, close, volume
FROM (
    SELECT *,
           LAG(open) OVER (ORDER BY day) AS prev_open,
           LAG(close) OVER (ORDER BY day) AS prev_close,
           LAG(low) OVER (ORDER BY day) AS prev_low
    FROM daily_ohlc
    -- FROM daily_ohlc_optimised
) AS sub
WHERE prev_close < prev_open  -- Previous day is bearish
  AND close > open            -- Current day is bullish
  AND open < prev_low         -- Bullish candle opens lower than previous low
  AND close > (prev_open + prev_close) / 2; -- Closes more than halfway into bearish candle


-- Find Morning Star pattern
-- INSERT INTO morning_star_patterns (day, open, high, low, close, volume)
SELECT day, open, high, low, close, volume
FROM (
    SELECT *,
        LAG(open, 1) OVER (ORDER BY day) AS d1_open,
        LAG(close, 1) OVER (ORDER BY day) AS d1_close,
        LAG(open, 2) OVER (ORDER BY day) AS d0_open,
        LAG(close, 2) OVER (ORDER BY day) AS d0_close
    FROM daily_ohlc
    -- FROM daily_ohlc_optimised
) d2
WHERE 
    d0_close < d0_open  -- First day is bearish
    AND d1_open < d0_close  -- Second day's candlestick body is entirely below the first day's close
    AND d1_close < d0_close
    AND d2.close > d2.open  -- Third day is bullish
    AND d2.close > (d0_open + d0_close) / 2; -- Third day's close overlaps the first day's body

-- Task 2 Calculate average number of continuously bullish days following each pattern
-- (e.g., hammer, inverted hammer, morning star) + check how reliable each pattern is
-- at predicting the future stock prices

-- For implementation of "number of continuously bullish days following each pattern",
-- see `task2_number_of_consecutive_bullish_days.sql`
