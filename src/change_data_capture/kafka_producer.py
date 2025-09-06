from kafka import KafkaProducer

bootstrap_servers = ['localhost:29092']
topic_name = 'mytopic'

producer = KafkaProducer(bootstrap_servers=bootstrap_servers)

future = producer.send(topic_name, b'hello world 99')

result = future.get(timeout=10)  # Block until a single message is sent (or timeout)

print(f'Message sent {result}')

producer.close()

