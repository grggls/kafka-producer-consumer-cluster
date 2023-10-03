test:
	python -m unittest discover -s tests -p 'test_*.py'

start:
	#sh -x ./kind-with-registry.sh
	kubectl create namespace kafkaplaypen --dry-run=client -o yaml | kubectl apply -f - --
	kubectl config set-context $(shell kubectl config current-context) --namespace=kafkaplaypen
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm install kafka-local bitnami/kafka --set auth.clientProtocol=plaintext,auth.interBrokerProtocol=plaintext,persistence.enabled=false,zookeeper.enabled=false --wait

build:
	docker build -t producer:latest ./producer
	docker build -t consumer:latest ./consumer
	docker tag producer:latest localhost:5001/producer:latest
	docker tag consumer:latest localhost:5001/consumer:latest
	docker push localhost:5001/producer:latest
	docker push localhost:5001/consumer:latest

run:
	kubectl delete deployment producer --namespace kafkaplaypen --wait --ignore-not-found=true
	kubectl delete deployment consumer --namespace kafkaplaypen --wait --ignore-not-found=true
	kubectl create deployment producer --image=localhost:5001/producer
	kubectl create deployment consumer --image=localhost:5001/consumer

lint:
	pipenv run format
	pipenv run lint
	hadolint ./producer/Dockerfile
	hadolint ./consumer/Dockerfile


.PHONY: test
