#COLORS
GREEN  := $(shell tput -Txterm setaf 2)
WHITE  := $(shell tput -Txterm setaf 7)
YELLOW := $(shell tput -Txterm setaf 3)
RED    := $(shell tput -Txterm setaf 1)
RESET  := $(shell tput -Txterm sgr0)

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
# A category can be added with @category
HELP_FUN = \
    %help; \
    while(<>) { push @{$$help{$$2 // 'options'}}, [$$1, $$3] if /^([a-zA-Z\-]+)\s*:.*\#\#(?:@([a-zA-Z\-]+))?\s(.*)$$/ }; \
    print "usage: make [target]\n\n"; \
    for (sort keys %help) { \
    print "${WHITE}$$_:${RESET}\n"; \
    for (@{$$help{$$_}}) { \
    $$sep = " " x (32 - length $$_->[0]); \
    print "  ${YELLOW}$$_->[0]${RESET}$$sep${GREEN}$$_->[1]${RESET}\n"; \
    }; \
    print "\n"; }


.DEFAULT_GOAL := help

.PHONY: help create-ns delete-ns

help: ##@other Show this help.
	@perl -e '$(HELP_FUN)' $(MAKEFILE_LIST)

create-ns: ## Create namespace
	kubectl apply -f opt/namespaces/

delete-ns: ## Delete namespace
	kubectl delete -f opt/namespaces/

deploy: create-ns  ## Deploy to k8
	kubectl apply -f opt/trading-api/deployment.yaml
	kubectl apply -f opt/trading-api/service.yaml
    # kubectl apply -f opt/trading-api/persistane-volume-claim.yaml

delete: ## Delete deployment
	kubectl delete -f opt/trading-api/service.yaml
	kubectl delete -f opt/trading-api/deployment.yaml
    # kubectl delete -f opt/trading-api/persistane-volume-claim.yaml
