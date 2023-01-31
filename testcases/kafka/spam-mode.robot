*** Settings ***
Library    KafkaLibrary
Library    RobotKafkaLibrary.Producer
Library    RobotKafkaLibrary.Consumer
Library    ./commons/extended_producer.py    WITH NAME    ExtendedKafkaProducer

*** Test Cases ***
#Test Connect Kafka
#    ${RESULT} =     Connect To Kafka Custom
#    log    ${RESULT}
#    Log to console   ${RESULT}

Test producer topic test publish message
    [tags]  Publish Kafka
    ${RESULT} =     Publish  localhost:9092   testRobot   "TEST KAFKA"
    log    ${RESULT}
    Log to console   ${RESULT}

Test consumer topic test subscribe message
    [tags]  Consume Kafka
    ${MSG} =     Subscribe  localhost:9092   testRobot
    log    ${MSG}
    Log to console   ${MSG}