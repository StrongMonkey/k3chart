TARGETS := $(shell ls scripts)

ci:
	./scripts/ci

bootstrap:
	./scripts/bootstrap

charts: bootstrap
	./scripts/generate-charts

patch: bootstrap
	./scripts/generate-patch

validate: bootstrap
	./scripts/validate

rebase: bootstrap
	./scripts/rebase

.DEFAULT_GOAL := ci

.PHONY: $(TARGETS)
