all:
	docker build . -t bloomapi/letsencrypt-gcloud-balancer:latest

push:
	docker push bloomapi/letsencrypt-gcloud-balancer:latest