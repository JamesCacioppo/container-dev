build:
	docker build -t obscuritylabs/dev-container:latest .
.PHONY: push
push:
	docker push obscuritylabs/dev-container:latest
.PHONY: run
run:
	docker run \
		--net=host \
		--rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--name dev-container \
		-it obscuritylabs/dev-container:latest
