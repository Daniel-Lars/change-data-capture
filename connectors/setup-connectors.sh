#!/bin/bash

set -e

CONNECT_URL="http://localhost:8083"

# Check if required environment variables are set
required_vars=("PROD_POSTGRES_USER" "PROD_POSTGRES_PASSWORD" "PROD_POSTGRES_DB" "CPROD_POSTGRES_USER" "CPROD_POSTGRES_PASSWORD" "CPROD_POSTGRES_DB")
for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        echo "Error: Environment variable $var is not set"
        exit 1
    fi
done

echo "Creating Debezium source connector..."
envsubst < ./src-postgres.json | curl -X POST "$CONNECT_URL/connectors" \
     -H "Content-Type: application/json" \
     -d @-

echo "Creating JDBC Sink connector..."
envsubst < ./sink-jdbc.json | curl -X POST "$CONNECT_URL/connectors" \
     -H "Content-Type: application/json" \
     -d @-

echo "Connectors setup complete."