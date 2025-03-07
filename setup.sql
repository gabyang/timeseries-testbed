CREATE TABLE stock_ticks (
    time TIMESTAMPTZ NOT NULL,
    open NUMERIC NOT NULL,
    high NUMERIC NOT NULL,
    low NUMERIC NOT NULL,
    close NUMERIC NOT NULL,
    volume NUMERIC NOT NULL
);

SELECT create_hypertable('stock_ticks', 'time');

CREATE TABLE daily_ohlc (
    day DATE PRIMARY KEY, -- 4 bytes
    open NUMERIC NOT NULL, -- avoid numeric data types, use int with max 2 dp. Stocks priced above $1 or penny stocks are typically quoted to 2 decimal places (https://www.investopedia.com/terms/t/tick.asp) (use smallint a range of -32,768 to +32,767 2bytes)
    high NUMERIC NOT NULL,
    low NUMERIC NOT NULL,
    close NUMERIC NOT NULL,
    volume NUMERIC NOT NULL
);

SELECT create_hypertable('daily_ohlc', 'day');

export TARGET=postgres://postgres:@localhost:5432/time_proj

for file in *; do
  timescaledb-parallel-copy \
    --skip-header \
    --connection $TARGET \
    --table stock_ticks \
    --file "$file" \
    --workers 8 \
    --reporting-period 30s
done

INSERT INTO daily_ohlc (day, open, high, low, close, volume)
SELECT 
    time::DATE AS day,
    first(open, time) AS open,
    MAX(high) AS high,
    MIN(low) AS low,
    last(close, time) AS close,
    SUM(volume) AS volume
FROM stock_ticks
GROUP BY day
ORDER BY day;



-- Optimisation possibility:
-- Add compression for historical data
ALTER TABLE stock_ticks SET (
    timescaledb.compress,
    timescaledb.compress_orderby = 'time DESC'
);

-- Create continuous aggregate for common queries
CREATE MATERIALIZED VIEW candlestick_hourly
WITH (timescaledb.continuous) AS
SELECT time_bucket('1 hour', time) AS bucket,
    FIRST(open, time) AS "open",
    MAX(high) AS high,
    MIN(low) AS low,
    LAST(close, time) AS "close",
    SUM(volume) AS volume
FROM stock_ticks
GROUP BY bucket;


CREATE TABLE daily_ohlc_op (
    day DATE PRIMARY KEY, -- 4 bytes
    open SMALLINT NOT NULL, -- 2 bytes
    high SMALLINT NOT NULL,
    low SMALLINT NOT NULL,
    close SMALLINT NOT NULL,
    volume INT NOT NULL -- 4 bytes, seen 127800
);

-- run a script to convert all values to 2dp and then to a 5 digit representation
-- ensure that int is fulfilled for volume