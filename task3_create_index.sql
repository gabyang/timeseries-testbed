-- Composite index 
CREATE INDEX composite_index_day_open_close ON daily_ohlc(day, open, close);

-- Covering index 
CREATE INDEX covering_index_day ON daily_ohlc(day)
 INCLUDE (open, close);

-- BRIN index
CREATE INDEX brin_index_day ON daily_ohlc USING BRIN (day);

-- Functional index
CREATE INDEX functional_index_high_lt_low ON daily_ohlc((high < low));
CREATE INDEX functional_index_low_lt_high ON daily_ohlc((low < high));
