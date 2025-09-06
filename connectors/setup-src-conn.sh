#!/bin/bash

# Wait for services to be ready
echo "Waiting for Kafka Connect to be ready..."
until curl -f http://localhost:8083/connectors; do
  sleep 5
done

echo "Setting up source connector..."
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d '{
    "name": "postgres-source-connector",
    "config": {
      "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
      "database.hostname": "postgres_db_prod",
      "database.port": "5432",
      "database.user": "'${PROD_POSTGRES_USER}'",
      "database.password": "'${PROD_POSTGRES_PASSWORD}'",
      "database.dbname": "'${PROD_POSTGRES_DB}'",
      "database.server.name": "prod",
      "topic.prefix": "mycdc",
      "plugin.name": "pgoutput",
      "slot.name": "debezium_slot",
      "publication.name": "dbz_publication", 
      "transforms": "unwrap", 
      "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
      "key.converter": "org.apache.kafka.connect.json.JsonConverter",
      "value.converter": "org.apache.kafka.connect.json.JsonConverter",
      "table.include.list": "public.cars"
    }
  }'
