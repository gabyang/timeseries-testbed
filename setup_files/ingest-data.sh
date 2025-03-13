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
