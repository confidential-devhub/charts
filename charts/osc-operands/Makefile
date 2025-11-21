# Makefile for osc-operands Helm chart deployment

SHELL := /bin/bash
CHART_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SCRIPT_DIR := $(CHART_DIR)/scripts

RELEASE_NAME ?= osc-operands
NAMESPACE ?= openshift-sandboxed-containers-operator

.PHONY: template
template: ## Show rendered templates (requires PROVIDER=<azure|gcp>)
ifndef PROVIDER
	$(error PROVIDER is required. Usage: make template PROVIDER=<azure|gcp>)
endif
	@source $(SCRIPT_DIR)/set-values/$(PROVIDER).sh && \
	export PROVIDER=$(PROVIDER) && \
	envsubst < $(CHART_DIR)/values.yaml | \
	helm template $(RELEASE_NAME) $(CHART_DIR) -f - --namespace $(NAMESPACE)

.PHONY: deploy-peerpods
deploy-peerpods: ## Deploy osc-operands with peerpods (requires PROVIDER=<azure|gcp>)
	@$(MAKE) template PROVIDER=$(PROVIDER) | oc apply -f -
