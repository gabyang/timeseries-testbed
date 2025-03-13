-- To identify bearish candlestick vs bullish candlestick, see:
-- https://en.wikipedia.org/wiki/Candlestick_pattern#Formation_of_candlestick

-- Task 1 
-- Find Hammer pattern

SELECT *
FROM (
    SELECT *,
           LAG(open) OVER (ORDER BY day) AS prev_open,
           LAG(close) OVER (ORDER BY day) AS prev_close
    FROM daily_ohlc
) AS sub
WHERE prev_close < prev_open   -- Previous day is bearish
  AND close > open             -- Current day is bullish
  AND high = close;            -- High price equals close price

-- Find Inverted Hammer pattern

SELECT *
FROM (
    SELECT *,
           LAG(open) OVER (ORDER BY day) AS prev_open,
           LAG(close) OVER (ORDER BY day) AS prev_close
    FROM daily_ohlc
) AS sub
WHERE prev_close < prev_open   -- Previous day is bearish
  AND close > open             -- Current day is bullish
  AND low = open;              -- Low price equals open price
