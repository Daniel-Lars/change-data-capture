from kafka import KafkaConsumer

topic_name = 'mytopic'
bootstrap_servers = ['localhost:29092']

consumer= KafkaConsumer(topic_name, auto_offset_reset='earliest', bootstrap_servers=bootstrap_servers, consumer_timeout_ms=1000)

for msg in consumer:
    print(f"Topic: {msg.topic}, Partition: {msg.partition}, Offset: {msg.offset}, Key: {msg.key}, Value: {msg.value}")