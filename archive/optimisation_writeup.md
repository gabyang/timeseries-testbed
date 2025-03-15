
### Optimisation for performance:

#### Query based improvements

1) Materialized View Definitions
A continuous aggregate in TimescaleDB is a materialized view that automatically refreshes and stores aggregated results efficiently over time.
Speeds up queries that use GROUP BY (e.g., OHLC calculations).


2) Leverage timescales specific query (hyperfunctions)
last(close, day)
first(open, day)

CREATE MATERIALIZED VIEW daily_ohlc_cagg
WITH (timescaledb.continuous) AS
SELECT 
    time_bucket('1 day', day) AS day,
    first(open, day) AS open,
    MAX(high) AS high,
    MIN(low) AS low,
    last(close, day) AS close,
    SUM(volume) AS volume
FROM daily_ohlc
GROUP BY day;

3) SQL Scripts: For creating indexes. Place discrete columns first in created indexes, then continuous columns

CREATE INDEX ON daily_ohlc_cagg (day DESC);
CREATE INDEX ON engulfing_bearish_patterns (day DESC);
CREATE INDEX ON evening_star_patterns (day DESC);
CREATE INDEX ON three_white_soldiers_patterns (day DESC);

----------------------------------------------------------------
CREATE INDEX ON daily_ohlc_cagg (day DESC, close, open);
CREATE INDEX ON daily_ohlc_cagg (day DESC, open, close);

#### Database based improvements

4) timescaledb-tune - memory (not really disk) (postgresql.conf)

#### Memory based improvements

5) schema improvements to reduce memory usage

avoid numeric data types, use int with max 2 dp. Stocks priced above $1 or penny stocks are typically quoted to 2 decimal places (https://www.investopedia.com/terms/t/tick.asp) (use smallint a range of -32,768 to +32,767 2bytes)
The storage requirement for a numeric value in PostgreSQL is two bytes for each group of four decimal digits, plus three to eight bytes of overhead.
For 24.98437:

Total digits: 7

Groups of four digits: 2 (2498 and 4370)

Storage: (2 * 2) + 3 to 8 bytes overhead

Total: 7 to 12 bytes

6) set_chunk_time_interval to define chunks that make up no more than 25% of main memory (across all hyper tables) 25% is the size of shared buffers 
shared_buffer = 25% of RAM.


#### More tuning
7) Background workers
Background workers perform background processing for operations specific to TimescaleDB (both live queries and background jobs, all kinds of User-Defined Actions/Policies).

The background worker's settings need to be tuned to get the most out of TimescaleDB—issues often arise when worker settings are not properly set. Some of the issues we see often caused by a misconfiguration of background workers are:
User-Defined Actions are not working properly.
Continuous aggregates are not working properly.
Compression policies are not working properly.
The retention policies are not working properly.
Database size rapidly increases, due to failures in compression and the data retention policies.

- You should configure the timescaledb.max_background_workers setting to be equal to the sum of your total number of databases + the total number of concurrent background workers you want running at any given point in time.
- By default, the max_parallel_workers setting corresponds to the number of CPUs available.
- max_worker_processes should be AT LEAST 3 (required for checkpointer, WAL writer, and vacuum processes) plus the sum of the background workers and parallel workers:
max_worker_processes = 3 + timescaledb.max_background_workers + max_parallel_workers.


https://www.timescale.com/blog/timescale-parameters-you-should-know-about-and-tune-to-maximize-your-performance