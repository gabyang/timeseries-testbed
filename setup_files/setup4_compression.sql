ALTER TABLE daily_ohlc_optimised SET (
    timescaledb.compress,
    timescaledb.compress_orderby = 'day DESC'
);

-- or
-- ALTER TABLE daily_ohlc SET (
--     timescaledb.compress,
--     timescaledb.compress_orderby = 'day DESC'
-- );
