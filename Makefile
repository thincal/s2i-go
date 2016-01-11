
IMAGE_NAME = registry.ceyes.os:5000/openshift/s2i-golang-ceyes:1.4.3

build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
