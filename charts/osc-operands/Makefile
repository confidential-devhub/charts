# Makefile for osc-operands Helm chart deployment

SHELL := /bin/bash
CHART_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
SCRIPT_DIR := $(CHART_DIR)/scripts
FILES_DIR := $(CHART_DIR)/files

RELEASE_NAME ?= osc-operands
NAMESPACE ?= openshift-sandboxed-containers-operator

.PHONY: ssh-keys
ssh-keys: ## Generate SSH keys in files/ directory (auto-creates if missing)
	@mkdir -p $(FILES_DIR)
	@# Check if user set custom SSH key paths via values.yaml
	@PUB_KEY_PATH=$$(grep -A2 "sshKey:" $(CHART_DIR)/values.yaml | grep "publicKeyPath:" | sed 's/.*publicKeyPath: *"\?\([^"]*\)"\?.*/\1/' | grep -v '^ *#' | head -1); \
	PRIV_KEY_PATH=$$(grep -A3 "sshKey:" $(CHART_DIR)/values.yaml | grep "privateKeyPath:" | sed 's/.*privateKeyPath: *"\?\([^"]*\)"\?.*/\1/' | grep -v '^ *#' | head -1); \
	if [ -n "$$PUB_KEY_PATH" ] && [ "$$PUB_KEY_PATH" != "" ]; then \
		if [[ "$$PUB_KEY_PATH" == files/* ]]; then \
			if [ -f "$(CHART_DIR)/$$PUB_KEY_PATH" ]; then \
				echo "✓ Using existing SSH keys from values.yaml:" >&2; \
				echo "  Public:  $$PUB_KEY_PATH" >&2; \
				if [ -n "$$PRIV_KEY_PATH" ]; then echo "  Private: $$PRIV_KEY_PATH" >&2; fi; \
			else \
				echo "Generating new SSH keys in files/ directory..." >&2; \
				PRIV_KEY="$(FILES_DIR)/$${PUB_KEY_PATH##*/}"; \
				PRIV_KEY="$${PRIV_KEY%.pub}"; \
				ssh-keygen -t ed25519 -f "$$PRIV_KEY" -N "" -C "osc-peerpods-ssh-key" >&2 && \
				echo "✓ SSH keys generated:" >&2; \
				echo "  Public:  $$PUB_KEY_PATH" >&2; \
				echo "  Private: $$PRIV_KEY_PATH" >&2; \
			fi; \
		else \
			echo "Error: SSH keys must be in the files/ directory" >&2; \
			echo "" >&2; \
			echo "Found in values.yaml:" >&2; \
			echo "  publicKeyPath: $$PUB_KEY_PATH" >&2; \
			echo "" >&2; \
			echo "Please copy your keys to files/ and update values.yaml:" >&2; \
			echo "  cp $$PUB_KEY_PATH $(FILES_DIR)/" >&2; \
			if [ -n "$$PRIV_KEY_PATH" ]; then echo "  cp $$PRIV_KEY_PATH $(FILES_DIR)/" >&2; fi; \
			echo "  Then set: publicKeyPath: \"files/$${PUB_KEY_PATH##*/}\"" >&2; \
			exit 1; \
		fi; \
	elif [ -f "$(FILES_DIR)/id_rsa.pub" ]; then \
		echo "✓ Using existing SSH keys in files/ directory" >&2; \
	else \
		echo "Generating new SSH keys in files/ directory..." >&2; \
		ssh-keygen -t ed25519 -f $(FILES_DIR)/id_rsa -N "" -C "osc-peerpods-ssh-key" >&2 && \
		echo "✓ SSH keys generated" >&2; \
	fi

.PHONY: template
template: ssh-keys ## Show rendered templates (requires PROVIDER=<azure|gcp>)
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

.PHONY: mirror-images
mirror-images: ## Mirror airgap images to registry (requires VALUES_FILE with airgap.registry set)
ifndef VALUES_FILE
	$(error VALUES_FILE is required. Usage: make mirror-images VALUES_FILE=<path/to/values.yaml>)
endif
	@$(SCRIPT_DIR)/mirror-to-acr.sh $(VALUES_FILE)
