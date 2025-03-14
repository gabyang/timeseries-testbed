-- referenced from https://stackoverflow.com/a/60900382
WITH
    -- gaps and islands problem in SQL start 
    -- see: https://www.youtube.com/watch?v=ffNngUTqYBM
    daily_ohlc_is_bullish AS (
        SELECT
            *,
            (t0.close > t0.open) AS is_bullish
        FROM
            daily_ohlc t0
        -- LIMIT
        --     50
        --     -- LIMIT 50 for testing purposes only
    ),
    daily_ohlc_is_bullish_lagged AS (
        SELECT
            *,
            (
                lag (t1.is_bullish) OVER (
                    ORDER BY
                        t1.day
                )
            ) AS is_bullish_lagged
        FROM
            daily_ohlc_is_bullish t1
    ),
    daily_ohlc_is_start_of_new_streak AS (
        SELECT
            *,
            (
                CASE
                    WHEN t2.is_bullish = t2.is_bullish_lagged THEN 0
                    ELSE 1
                END
            ) AS is_start_of_new_streak
        FROM
            daily_ohlc_is_bullish_lagged t2
    ),
    daily_ohlc_streak_id AS (
        SELECT
            *,
            SUM(t3.is_start_of_new_streak) OVER (
                ORDER BY
                    t3.day
            ) AS streak_id
        FROM
            daily_ohlc_is_start_of_new_streak t3
    ),
    daily_ohlc_streak_id_row_number AS (
        SELECT
            *,
            ROW_NUMBER() OVER (
                PARTITION BY
                    t4.streak_id
            ) AS streak_id_row_number
        FROM
            daily_ohlc_streak_id t4
    ),
    -- gaps and islands problem in SQL end
    daily_ohlc_number_of_days_in_streak AS (
        SELECT
            t5.streak_id,
            (
                CASE
                    WHEN t5.is_bullish = TRUE THEN COUNT(*)
                    ELSE 0
                END
            ) AS number_of_bullish_days_in_streak
        FROM
            daily_ohlc_streak_id_row_number t5
        GROUP BY
            t5.streak_id,
            t5.is_bullish
            -- SQL requires that t5.is_bullish is either in the GROUP BY clause or an aggregate
        ORDER BY
            t5.streak_id
    ),
    daily_ohlc_recombined AS (
        SELECT
            *
        FROM
            (
                daily_ohlc_streak_id_row_number t5
                INNER JOIN daily_ohlc_number_of_days_in_streak t6 ON t5.streak_id = t6.streak_id
            ) AS t7
        ORDER BY
            t7.day
    ),
    streaks AS (
    SELECT
        *,
        /* possibly more columns such as is_bullish, streak_id, row_number_in_streak, etc. */

        -- "z" is the number of consecutive bullish days that include this day
        -- "z" is used to avoid text wrapping in the terminal due to long column names
        GREATEST( (t8.number_of_bullish_days_in_streak - t8.streak_id_row_number) + 1, 0 ) AS z
    FROM
        daily_ohlc_recombined t8
    )



-- notable examples to look out for:
-- day="1996-01-31" is 3 consecutive bullish days (i.e., stock price increasing)
-- day="1996-01-08" is 3 consecutive bearish days (i.e., stock price decreasing)
--
--  we can use the above query result (let's call it streaks) and perform
-- `INNER JOIN streaks.day = xxx_pattern.day`
-- to find the "number_of_consecutive_bullish_days" for the xxx_candlestick pattern

SELECT 
    'Engulfing Bullish' AS pattern_name,
    COUNT(*) AS pattern_count,
    AVG(streaks.z - 1) AS avg_bullish_days_after,
    AVG(
        CASE WHEN (streaks.z - 1) >= 1 THEN 1 ELSE 0 END
    ) AS reliability_1day,
    AVG(
        CASE WHEN (streaks.z - 1) >= 2 THEN 1 ELSE 0 END
    ) AS reliability_2days,
    AVG(
        CASE WHEN (streaks.z - 1) >= 3 THEN 1 ELSE 0 END
    ) AS reliability_3days
FROM 
    engulfing_bullish_patterns p
    INNER JOIN streaks ON p.day = streaks.day
UNION ALL
SELECT 
    'Morning Star' AS pattern_name,
    COUNT(*) AS pattern_count,
    AVG(streaks.z - 1) AS avg_bullish_days_after,
    AVG(
        CASE WHEN (streaks.z - 1) >= 1 THEN 1 ELSE 0 END
    ) AS reliability_1day,
    AVG(
        CASE WHEN (streaks.z - 1) >= 2 THEN 1 ELSE 0 END
    ) AS reliability_2days,
    AVG(
        CASE WHEN (streaks.z - 1) >= 3 THEN 1 ELSE 0 END
    ) AS reliability_3days
FROM 
    morning_star_patterns p
    INNER JOIN streaks ON p.day = streaks.day
UNION ALL
SELECT 
    'Piercing Line' AS pattern_name,
    COUNT(*) AS pattern_count,
    AVG(streaks.z - 1) AS avg_bullish_days_after,
    AVG(
        CASE WHEN (streaks.z - 1) >= 1 THEN 1 ELSE 0 END
    ) AS reliability_1day,
    AVG(
        CASE WHEN (streaks.z - 1) >= 2 THEN 1 ELSE 0 END
    ) AS reliability_2days,
    AVG(
        CASE WHEN (streaks.z - 1) >= 3 THEN 1 ELSE 0 END
    ) AS reliability_3days
FROM 
    piercing_line_patterns p
    INNER JOIN streaks ON p.day = streaks.day;

