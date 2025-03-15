-- Find Engulfing Bullish pattern (optimised)
SELECT day, open, high, low, close, volume
FROM daily_ohlc_prev          -- MATERIALIZED VIEW
WHERE prev_close < prev_open  -- Previous day is bearish
  AND close > open            -- Current day is bullish
  AND open < prev_close       -- The bullish candle opens lower than the previous close
  AND close > prev_open; 


-- Find Piercing Line pattern (optimised)
SELECT day, open, high, low, close, volume
FROM daily_ohlc_prev          -- MATERIALIZED VIEW
WHERE prev_close < prev_open  -- Previous day is bearish
  AND close > open            -- Current day is bullish
  AND open < prev_low         -- Bullish candle opens lower than previous low
  AND close > (prev_open + prev_close) / 2; -- Closes more than halfway into bearish candle


-- Find Morning Star pattern (optimised)
SELECT day, open, high, low, close, volume
FROM daily_ohlc_prev                  -- MATERIALIZED VIEW
WHERE 
    prev_prev_close < prev_prev_open  -- First day is bearish
    AND prev_open < prev_prev_close  
    AND prev_close < prev_prev_close
    AND close > open                  -- Third day is bullish
    AND close > (prev_prev_open + prev_prev_close) / 2; 
