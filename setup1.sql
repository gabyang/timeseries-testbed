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
    day DATE PRIMARY KEY,
    open NUMERIC NOT NULL,
    high NUMERIC NOT NULL,
    low NUMERIC NOT NULL,
    close NUMERIC NOT NULL,
    volume NUMERIC NOT NULL
);

SELECT create_hypertable('daily_ohlc', 'day');
