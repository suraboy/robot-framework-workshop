from RobotKafkaLibrary.Producer import KafkaProducer
import json

from confluent_kafka import Consumer

conf = {
    'bootstrap.servers': 'localhost:9092',
    'sasl.mechanisms': "PLAIN",
    'security.protocol': "SASL_PLAINTEXT",
    'sasl.username': None,
    'sasl.password': None,
    'group.id': "simple-robot-framework",
    'auto.offset.reset': 'earliest',
    # 'ssl.ca.location': 'keys/kafka-external.pem'
}


def connect_to_kafka_custom():
    c = Consumer(conf)
    c.subscribe(['testRobot'])

    while True:
        msg = c.poll(1.0)

        if msg is None:
            continue
        if msg.error():
            print("Consumer error: {}".format(msg.error()))
            continue

        print('Received message: {}'.format(msg.value().decode('utf-8')))

    c.close()


def create_kafka_producer(bootstrap_servers, security_protocol='PLAINTEXT', sasl_mechanism=None,
                          sasl_plain_username=None, sasl_plain_password=None, ssl_cafile=None, **kwargs):
    producer = KafkaProducer(
        bootstrap_servers=bootstrap_servers,
        security_protocol=security_protocol,
        sasl_mechanism=sasl_mechanism,
        sasl_plain_username=sasl_plain_username,
        sasl_plain_password=sasl_plain_password,
        ssl_cafile=ssl_cafile,
        # ssl_check_hostname=True,
        acks='all',
        retries=15,
        # api_version=(2, 5, 0),
        **kwargs
    )
    return producer


def publish_message(producer, topic, value, value_serializer='str'):
    if value_serializer == 'json':
        value = json.dumps(value).encode('utf-8')
    future = producer.send(topic, value=value)
    future.get(timeout=60)
    return 'success'


class ExtendedKafkaProducer(KafkaProducer):
    @classmethod
    def create_kafka_producer(cls, bootstrap_servers, **kwargs):
        return create_kafka_producer(bootstrap_servers, **kwargs)
