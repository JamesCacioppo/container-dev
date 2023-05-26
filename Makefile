TAG ?= latest

.PHONY: build
build:
	docker build -t jcacioppo/dev-container:${TAG} -f Dockerfile .
.PHONY: push
push:
	docker push jcacioppo/dev-container:${TAG}
.PHONY: pull
pull:
	docker pull jcacioppo/dev-container:${TAG}
.PHONY: run
run:
	docker run \
		--net=host \
		--rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-w /root \
		--name dev-container \
		-it jcacioppo/dev-container:${TAG}
