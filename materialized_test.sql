select test('SELECT day, open, high, low, close, volume
FROM daily_ohlc_optimised_m
WHERE prev_close < prev_open  -- Previous day is bearish
  AND close > open            -- Current day is bullish
  AND open < prev_close       -- The bullish candle opens lower than the previous close
  AND close > prev_open;  ', 200);

select test('SELECT day, open, high, low, close, volume
FROM daily_ohlc_optimised_m
WHERE prev_close < prev_open  -- Previous day is bearish
  AND close > open            -- Current day is bullish
  AND open < prev_low         -- Bullish candle opens lower than previous low
  AND close > (prev_open + prev_close) / 2; -- Closes more than halfway into bearish candle', 200);

select test('SELECT day, open, high, low, close, volume
FROM daily_ohlc_optimised_m
WHERE 
    prev_prev_close < prev_prev_open  -- First day is bearish
    AND prev_open < prev_prev_close  
    AND prev_close < prev_prev_close
    AND close > open  -- Third day is bullish
    AND close > (prev_prev_open + prev_prev_close) / 2; ', 200);

select test('SELECT day, open, high, low, close, volume
FROM daily_ohlc_optimised_m
WHERE prev_close > prev_open
  AND close < open
  AND open > prev_close
  AND close < prev_open;', 200);

select test('SELECT day, open, high, low, close, volume
FROM daily_ohlc_optimised_m
WHERE 
    prev_prev_close > prev_prev_open
    AND prev_open > prev_prev_close
    AND prev_close > prev_prev_close
    AND close < open
    AND close < (prev_prev_open + prev_prev_close) / 2;', 200);

select test('SELECT day, open, high, low, close, volume
FROM daily_ohlc_optimised_m
WHERE 
    prev_prev_close > prev_prev_open  -- First day is bullish
    AND open BETWEEN prev_prev_open AND prev_prev_close  -- Second day opens within first day
    AND close > prev_prev_close  -- Second day closes higher
    AND close > open  -- Second day is bullish
    AND open BETWEEN prev_open AND prev_close  -- Third day opens within second day
    AND close > prev_close  -- Third day closes higher
    AND close > open;  -- Third day is bullish', 200)