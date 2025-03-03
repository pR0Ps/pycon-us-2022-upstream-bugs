JEKYLL=bundle exec jekyll
SHELL=bash

$(eval CONFIG= \
	$(shell find config -maxdepth 1 -type f -name '*.yml' | \
		  sort -g | awk -vORS=, ' {print $1} ')_config.yml)

PDF_CONFIG_FILE=config/pdf/pdf-config.yml
PDF_CONFIG=$(shell [[ -f $(PDF_CONFIG_FILE) ]] && echo ',$(PDF_CONFIG_FILE)')
$(eval OPTS= \
	--config "$(CONFIG)")

$(eval PDF_OPTS= \
	--config $(CONFIG)$(PDF_CONFIG))

##
# Targets
help:
	@echo 'Makefile for Jekyll site'
	@echo ''
	@echo 'Usage:'
	@echo 'make init            Initialize directory'
	@echo 'make html            Generate the web site'
	@echo 'make clean           Clean up generated site'
	@echo 'make pages           Generate and commit the github-pages site (the '
	@echo '                     result still needs to be pushed to github).'

.vendor:
	bundle config set path .vendor/bundle
	bundle install

.PHONY: init
init: docs .vendor

.PHONY: html
html: docs .vendor
	$(JEKYLL) build $(OPTS)

.PHONY: pdf
pdf: docs .vendor
	$(JEKYLL) build $(PDF_OPTS)

.PHONY: serve
serve: docs .vendor
	$(JEKYLL) serve -w $(OPTS)

.PHONY: pages
pages: html
	$(SHELL) scripts/commit_pages.sh

docs:
	$(SHELL) scripts/make_worktree.sh

.PHONY: clean
clean:
	$(JEKYLL) clean

