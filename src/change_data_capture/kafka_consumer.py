from kafka import KafkaConsumer
import json
import time 

topic_name = 'mycdc.public.cars'
bootstrap_servers = ['localhost:29092']

consumer= KafkaConsumer(topic_name,
                        auto_offset_reset='earliest',
                        group_id=f'cool_group_{int(time.time())}', 
                        bootstrap_servers=bootstrap_servers,
                        consumer_timeout_ms=60000)

for msg in consumer:
    print(msg)
    print(json.loads(msg.value))