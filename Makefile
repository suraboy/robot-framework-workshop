test:
	robot -d reports -L TRACE -b debug.log testcases

test-api:
	robot -d reports/services -L TRACE -b debug.log testcases/services

test-redis:
	robot -d reports/redis -L TRACE -b debug.log testcases/redis

test-kafka:
	robot -d reports/kafka -L TRACE -b debug.log testcases/kafka

install-pip3:
	pip3 install -r requirements.txt

install-pip:
	pip install -r requirements.txt
