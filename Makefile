TARGETS := $(shell ls scripts)

$(TARGETS):
	bash -c ./scripts/$@

.DEFAULT_GOAL := ci

.PHONY: $(TARGETS)
