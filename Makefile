build:
	docker build -f Dockerfile -t tedezed/docker:latest .

push:
	docker push tedezed/docker:latest

default: build push