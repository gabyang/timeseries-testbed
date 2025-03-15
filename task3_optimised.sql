-- Find Engulfing bearish pattern (simply the opposite of Engulfing bullish pattern) (optimised)
SELECT day, open, high, low, close, volume
FROM daily_ohlc_prev                  -- MATERIALIZED VIEW
WHERE prev_close > prev_open
  AND close < open
  AND open > prev_close
  AND close < prev_open;


-- Find Evening star pattern (simply the opposite of morning star pattern) (optimised)
SELECT day, open, high, low, close, volume
FROM daily_ohlc_prev                  -- MATERIALIZED VIEW
WHERE 
    prev_prev_close > prev_prev_open
    AND prev_open > prev_prev_close
    AND prev_close > prev_prev_close
    AND close < open
    AND close < (prev_prev_open + prev_prev_close) / 2;


-- Find Three white soldier patterns (optimised)
SELECT day, open, high, low, close, volume
FROM daily_ohlc_prev                  -- MATERIALIZED VIEW
WHERE 
    prev_prev_close > prev_prev_open  -- First day is bullish
    AND open BETWEEN prev_prev_open AND prev_prev_close  -- Second day opens within first day
    AND close > prev_prev_close       -- Second day closes higher
    AND close > open                  -- Second day is bullish
    AND open BETWEEN prev_open AND prev_close  -- Third day opens within second day
    AND close > prev_close            -- Third day closes higher
    AND close > open;                 -- Third day is bullish