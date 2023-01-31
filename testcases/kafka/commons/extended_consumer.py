from RobotKafkaLibrary.Consumer import KafkaConsumer
from json import loads
import json


def create_kafka_consumer(bootstrap_servers, group_id, security_protocol=None, sasl_mechanism=None,
                          sasl_plain_username=None, sasl_plain_password=None, ssl_certfile=None, **kwargs):
    consumer = KafkaConsumer(
        bootstrap_servers=[bootstrap_servers],
        group_id=group_id,
        security_protocol=security_protocol,
        sasl_mechanism=sasl_mechanism,
        sasl_plain_username=sasl_plain_username,
        sasl_plain_password=sasl_plain_password,
        ssl_cafile=ssl_certfile,
        ssl_check_hostname=True,
        api_version=(2, 5, 0),
        **kwargs
    )

    return consumer


def subscribe_to_topics(consumer, topic):
    consumer.subscribe(topics=[topic])
    return consumer


# This keyword takes two arguments:
# 1. consumer: A KafkaConsumer object that has already been created and subscribed to one or more topics.
# 2. count (optional, default 1): The number of messages to retrieve from the consumer.
def consume_message(consumer, expected, column):
    while True:
        if consumer is not None:
            for msg in consumer:
                if msg.value is None:
                    raise AssertionError("Actual JSON is empty")
                else:
                    print("Topic Name=%s,Message=%s" % (msg.topic, msg.value))
                    result = should_be_equal_json(msg.value, expected, column)
                    if result is None:
                        return msg.value
                    else:
                        continue
        else:
            raise AssertionError("Consume is None")


def should_be_equal_json(actual, expected, column):
    if type(actual) is json:
        actual_dict = loads(json.dumps(actual))
    else:
        actual_dict = loads(actual)

    expected_dict = loads(json.dumps(expected))

    if column not in expected_dict or column not in actual_dict or actual_dict[column] != expected_dict[column]:
        # raise AssertionError(f"Column '{column}' not found in actual JSON")
        return "false"


def commit_consumer_offsets(consumer):
    try:
        consumer.commit()
        return True
    except Exception as e:
        print("Error committing offsets:", e)
        return False


class ExtendedKafkaConsumer(KafkaConsumer):
    @classmethod
    def create_kafka_consumer(cls, bootstrap_servers, group_id, **kwargs):
        return create_kafka_consumer(bootstrap_servers, group_id, **kwargs)
