include ../docker.mk
include ../help.mk
include ../ruby.mk

IMAGE_NAME=docker-tag

.PHONY: clean
clean: ## Clean up after the build process.

.PHONY: lint
lint: ruby-lint docker-lint ## Lint all of the files for this Action.

.PHONY: build
build: docker-build ## Build this Action.

.PHONY: test
test: ruby-test ## Test the components of this Action.

.PHONY: publish
publish: docker-publish ## Publish this Action.
