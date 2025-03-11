# Time Series Database Group 4

## Set-up

1. Download `AAPL-time.zip` from [here](https://drive.google.com/file/d/1pTsSjXDFbl4CyVT5NSY12dQa6Tv0MwyC/view?usp=sharing)
1. Run the following commands to unzip and un-gzip the data files

    ```bash
    unzip AAPL-time.zip
    cd ./AAPL-time/AAPL
    gzip -d *.gz     # add -k to keep the .gz files
    ```

1. While still inside the `./AAPL-time/AAPL` folder, run the following command to process the stock data in place -- we want to convert the Unix timestamp to PostgreSQL TIMESTAMPTZ format for easier ingestion later on

    ```python
    python3 /path/to/project/directory/process_csv.py process
    ```

1. Install TimescaleDB by following the instructions [here](https://docs.timescale.com/self-hosted/latest/install/)

1. Run `setup1.sql` to create the tables / hyper tables in TimescaleDB

1. While still inside the `./AAPL-time/AAPL` folder, use `timescaledb-parallel-copy` to ingest the stock data into TimescaleDB

    ```bash
    export TARGET=postgres://USERNAME:PASSWORD@localhost:5432/DATABASE_NAME
    # e.g., using the default username of 'postgres', the default password as empty, and the default database name as 'postgres':
    # export TARGET=postgres://postgres:@localhost:5432/postgres

    for file in *; do
        timescaledb-parallel-copy \
            --skip-header \
            --connection $TARGET \
            --table stock_ticks \
            --file "$file" \
            --workers 8 \
            --reporting-period 30s
    done
    ```

1. Run `setup2.sql` to populate the `daily_ohlc` table using the `stock_ticks` data

1. Run the SQL queries to find the various candlestick patterns
