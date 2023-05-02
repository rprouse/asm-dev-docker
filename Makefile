IMAGE_NAME := rprouse/asm-dev
DOCKERFILE := Dockerfile

DOCKER := docker

TAG := $(shell date '+%Y%m%d')-$(shell git rev-parse --short HEAD)
DATE_FULL := $(shell date -u "+%Y-%m-%dT%H:%M:%SZ")
UUID := $(shell cat /proc/sys/kernel/random/uuid)
VERSION := 1.8.0

all: build push

build: $(DOCKERFILE)
	$(DOCKER) build . -f $(DOCKERFILE) -t $(IMAGE_NAME):$(TAG) -t $(IMAGE_NAME):latest \
	--build-arg BUILD_DATE=$(DATE_FULL) \
	--build-arg VERSION=$(VERSION)

push: build
	$(DOCKER) push -a $(IMAGE_NAME)

clean:
	$(DOCKER) images --filter='reference=$(IMAGE_NAME)' --format='{{.Repository}}:{{.Tag}}' | xargs -r $(DOCKER) rmi -f

.PHONY: build push clean