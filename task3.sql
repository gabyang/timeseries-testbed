-- Task 3

-- Find Engulfing bearish pattern (simply the opposite of Engulfing bullish pattern)
INSERT INTO engulfing_bearish_patterns (day, open, high, low, close, volume)
SELECT day, open, high, low, close, volume
FROM (
    SELECT *,
           LAG(open) OVER (ORDER BY day) AS prev_open,
           LAG(close) OVER (ORDER BY day) AS prev_close
    FROM daily_ohlc
) AS sub
WHERE prev_close > prev_open
  AND close < open
  AND open > prev_close
  AND close < prev_open;

-- Find Evening star pattern (simply the opposite of morning star pattern)
INSERT INTO evening_star_patterns (day, open, high, low, close, volume)
SELECT day, open, high, low, close, volume
FROM (
    SELECT *,
        LAG(open, 1) OVER (ORDER BY day) AS d1_open,
        LAG(close, 1) OVER (ORDER BY day) AS d1_close,
        LAG(open, 2) OVER (ORDER BY day) AS d0_open,
        LAG(close, 2) OVER (ORDER BY day) AS d0_close
    FROM daily_ohlc
) d2
WHERE 
    d0_close > d0_open
    AND d1_open > d0_close
    AND d1_close > d0_close
    AND d2.close < d2.open
    AND d2.close < (d0_open + d0_close) / 2;



-- Find Three white soldier patterns
-- INSERT INTO three_white_soldiers_patterns (day, open, high, low, close, volume)
SELECT day, open, high, low, close, volume
FROM (
    SELECT 
        *,
        LAG(open, 1) OVER (ORDER BY day) AS prev_open,
        LAG(close, 1) OVER (ORDER BY day) AS prev_close,
        LAG(open, 2) OVER (ORDER BY day) AS prev2_open,
        LAG(close, 2) OVER (ORDER BY day) AS prev2_close
    FROM daily_ohlc
) t
WHERE 
    prev2_close > prev2_open  -- First day is bullish
    AND open BETWEEN prev2_open AND prev2_close  -- Second day opens within first day
    AND close > prev2_close  -- Second day closes higher
    AND close > open  -- Second day is bullish
    AND open BETWEEN prev_open AND prev_close  -- Third day opens within second day
    AND close > prev_close  -- Third day closes higher
    AND close > open;  -- Third day is bullish

