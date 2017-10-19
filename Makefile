all: build

build:
	docker build . -t bloomapi/letsencrypt-gcloud-balancer:latest

push: build
	docker push bloomapi/letsencrypt-gcloud-balancer:latest
