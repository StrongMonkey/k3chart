TARGETS := $(shell ls scripts)

ci:
	./scripts/ci

bootstrap:
	./scripts/bootstrap

charts:
	./scripts/generate-charts

patch:
	./scripts/generate-patch

validate:
	./scripts/validate

.DEFAULT_GOAL := ci

.PHONY: $(TARGETS)
