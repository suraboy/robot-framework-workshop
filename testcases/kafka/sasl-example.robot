*** Settings ***
Library    String
Library    RobotKafkaLibrary.Producer
Library    RobotKafkaLibrary.Consumer
Library    ./commons/extended_consumer.py    WITH NAME    ExtendedKafkaConsumer
Library    ./commons/extended_producer.py    WITH NAME    ExtendedKafkaProducer

*** Variables ***
# Local : Start =>
${KAFKA_BOOTSTRAP_SERVERS}      localhost:9092
${KAFKA_TOPIC}                  testRobot
${KAFKA_USERNAME}               None
${KAFKA_PASSWORD}               None
${KAFKA_SECURITY_PROTOCOL}      PLAINTEXT
${KAFKA_MECHANISM}              SASL_SSL
${KAFKA_CERT}                   None
${KAFKA_GROUP_ID}               simple-robot-framework

*** Test Cases ***
#Test Connect Produce Kafka By Confluent Kafka
#    ${RESULT} =     Connect To Kafka Custom
#    log    ${RESULT}
#    Log to console   ${RESULT}

Test Kafka Service By Robot Kafka Library
    ${reqID} =    Generate Random String    15

    # Create Kafka Producer
    ${producer}=    Create Kafka Producer    bootstrap_servers=${KAFKA_BOOTSTRAP_SERVERS}  security_protocol=${KAFKA_SECURITY_PROTOCOL}   sasl_mechanism=${KAFKA_MECHANISM}    sasl_plain_username=${KAFKA_USERNAME}    sasl_plain_password=${KAFKA_PASSWORD}  ssl_certfile=${KAFKA_CERT}

    # Convert JSON to string
    ${json_message}=    Create Dictionary    reqID=${reqID}    name=test robot framework

    # Publish a message to the Kafka topic
    ${RESULT}=  Publish Message    ${producer}    ${KAFKA_TOPIC}    value=${json_message}    value_serializer=json

    # Create Kafka Consumer
    ${consumer}=    Create Kafka Consumer    bootstrap_servers=${KAFKA_BOOTSTRAP_SERVERS}     group_id=${KAFKA_GROUP_ID}    security_protocol=${KAFKA_SECURITY_PROTOCOL}    sasl_mechanism=${KAFKA_MECHANISM}    sasl_plain_username=${KAFKA_USERNAME}    sasl_plain_password=${KAFKA_PASSWORD}     ssl_certfile=${KAFKA_CERT}

    # Subscribe to the Kafka topic
    Subscribe To Topics    ${consumer}    ${KAFKA_TOPIC}

    # Create expect json data
    ${expected_json}=    Create Dictionary    reqID=${reqID}

    # Consume a message from the Kafka topic
    ${message}=    Consume Message    ${consumer}   ${expected_json}    reqID
    Log    ${message}

    # Commit the consumer offsets
    Commit Consumer Offsets    ${consumer}