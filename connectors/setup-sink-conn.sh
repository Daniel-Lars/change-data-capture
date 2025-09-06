#!/bin/bash

# Wait for services to be ready
echo "Waiting for Kafka Connect to be ready..."
until curl -f http://localhost:8083/connectors; do
  sleep 5
done

echo "Setting up Confluent JDBC Sink connector..."
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d '{
    "name": "jdbc-connector",  
    "config": {
        "connector.class": "io.debezium.connector.jdbc.JdbcSinkConnector",  
        "tasks.max": "1",  
        "connection.url": "jdbc:postgresql://postgres_db_cprod:5432/'${CPROD_POSTGRES_DB}'",
        "connection.username": "'${CPROD_POSTGRES_USER}'",
        "connection.password": "'${CPROD_POSTGRES_PASSWORD}'",
        "insert.mode": "upsert",  
        "primary.key.mode": "record_value",  
        "primary.key.fields": "id",
        "schema.evolution": "basic",  
        "use.time.zone": "UTC",  
        "topics": "mycdc.public.cars",
        "auto.create": "true"
    }
}'

echo "CDC setup complete!"