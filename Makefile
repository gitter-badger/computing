.PHONY: help build start stop test test-env bb bd book-build book-deploy

# Docker image name and tag
IMAGE:=dddlab/computing
TAG?=latest
# Shell that make should use
SHELL:=bash

help: ## http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: DARGS?=
build: ## Make the latest build of the image
	docker build $(DARGS) --rm --force-rm -t $(IMAGE):$(TAG) .

start: ARGS?=-d
start: PORT?=8888
start: ## Start container with docker-compose.yml
	IMAGE=$(IMAGE) PORT=$(PORT) docker-compose up $(ARGS)

stop: ARGS?=
stop: ## Stop container with docker-compose.yml
	IMAGE=$(IMAGE) docker-compose down $(ARGS)

test: ## Make a test run against the latest image
	pytest tests

test-env: ## Make a test environment by installing test dependencies with pip
	pip install -r tests/requirements.txt

bb: ## shortcut for book-build
	make book-build

bd: ## shortcut for book-deploy
	make book-deploy

book-build: ## build jupyter-book
	jupyter-book build .
    
book-deploy: ## deploy jupyter-book to github pages
	ghp-import -n -p -f _build/html
    