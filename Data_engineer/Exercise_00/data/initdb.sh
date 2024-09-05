#!/bin/bash

# Define variables
CSV_FILE='data/subject/customer/data_vis.csv'
TABLE_NAME='employees'
DATABASE='piscineds'
USER='mochegri'
PASSWORD='mysecretpassword'
HOST='localhost'

# Wait for PostgreSQL to start
echo "Waiting for PostgreSQL to start..."
sleep 10

# Generate SQL command to create table based on CSV header
echo "Generating table schema from CSV header..."
HEADER=$(head -n 1 "$CSV_FILE")
COLUMNS=$(echo $HEADER | awk -F, '{ for (i=1; i<=NF; i++) printf "%s TEXT%s", $i, (i==NF ? "" : ", "); }')
CREATE_TABLE_SQL="CREATE TABLE IF NOT EXISTS $TABLE_NAME ($COLUMNS);"

# Create table
echo "Creating table..."
psql -U $USER -d $DATABASE -h $HOST -c "$CREATE_TABLE_SQL"

# Import CSV data into table
echo "Importing CSV data..."
psql -U $USER -d $DATABASE -h $HOST -c "COPY $TABLE_NAME FROM '/data/employees.csv' DELIMITER ',' CSV HEADER;"

echo "Database setup complete."
