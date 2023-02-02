*** Settings ***
Library    RedisLibrary

*** Variables ***
# Local : Start =>
${REDIS_HOST}                   localhost
${REDIS_PORT}                   6379
${REDIS_DATABASE}               0
${REDIS_KEY}	                robot.redis.test
${REDIS_DATA}	                "TEST"
*** Test Cases ***
Get Requests
    ${REDIS_CONN}	Connect To Redis	${REDIS_HOST}	${REDIS_PORT}	db=${REDIS_DATABASE}

    Append To Redis	${REDIS_CONN}	${REDIS_KEY}	${REDIS_DATA}
    @{key_list}=	Get All Match Keys	${REDIS_CONN}	robot*	1000