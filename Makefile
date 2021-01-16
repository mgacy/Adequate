POD_EXISTS := $(shell command -v pod 2> /dev/null)
BREW_EXISTS := $(shell command -v brew 2> /dev/null)
SOURCERY_EXISTS := $(shell command -v sourcery 2> /dev/null)
SWIFTGEN_EXISTS := $(shell command -v swiftgen 2> /dev/null)

init: validate
	cp buildscripts/env-vars.template.sh buildscripts/env-vars.sh
	cp buildscripts/env_configs/awsconfiguration.template.json buildscripts/env_configs/awsconfiguration-dev.json
	cp buildscripts/env_configs/awsconfiguration.template.json buildscripts/env_configs/awsconfiguration-prod.json
	cp buildscripts/env_configs/awsconfiguration.template.json buildscripts/env_configs/awsconfiguration-stg.json
	@echo "[*] Generating localization helper struct ..."
	swiftgen
	@echo "[*] Installing pods ..."
	pod install

validate: ##=> Check dependencies
	$(info [*] Checking dependencies...)
	$(MAKE) validate.cocoapods
	$(MAKE) validate.homebrew
	$(MAKE) validate.sourcery
	$(MAKE) validate.swiftgen

validate.cocoapods:
ifndef POD_EXISTS
	$(error Please install CocoaPods following the directions at 'https://guides.cocoapods.org/using/getting-started.html')
endif

validate.homebrew:
ifndef BREW_EXISTS
	$(error Please install Homebrew following the directions at 'https://brew.sh')
endif

validate.sourcery:
ifndef SOURCERY_EXISTS
	$(info [*] Installing Sourcery ...)
	$(shell brew install swiftgen)
endif

validate.swiftgen:
ifndef SWIFTGEN_EXISTS
	$(info [*] Installing Swiftgen ...")
	$(shell brew install swiftgen)
endif

.PHONY: init validate validate.cocoapods validate.homebrew validate.sourcery validate.swiftgen
