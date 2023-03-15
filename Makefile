#!/usr/bin/make -f
.DEFAULT_GOAL := help
.PHONY: help

COMMAND_COLOR  := \033[0;1;32m
TITLE_COLOR := \033[0;1;33m
NO_COLOR := \033[0m

help: ## List all command name
		
	@printf "${TITLE_COLOR}Usage:${NO_COLOR}\n";\
	printf "  ${COMMAND_COLOR}make command${NO_COLOR}\n\n";\
	\
	printf "${TITLE_COLOR}Example:${NO_COLOR}\n";\
	printf "  ${COMMAND_COLOR}make help${NO_COLOR}\n\n";\
	\
	printf "${TITLE_COLOR}Available commands:${NO_COLOR}\n";\
	\
	grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' ${MAKEFILE_LIST} \
	| sed -n "s/^\(.*\): \(.*\)##\(.*\)/  $(shell printf "${COMMAND_COLOR}")\1$(shell printf "${NO_COLOR}")@\3/p" \
	| column -t -s'@';

prepaire-test-env: ## Prepaire test environment
	@if [ ! -f tests/TestConfiguration.php ]; then\
		echo "Prepaire TestConfiguration.php based on environment variable";\
		cp tests/TestConfiguration.env.php tests/TestConfiguration.php;\
	fi;\
	if [ ! -f bin/phpunit ] || [ ! -d vendor ]; then\
		echo "Composer install";\
		docker run --tty --user $$(id -u):$$(id -g) \
			--volume $$(pwd):$$(pwd) \
			--workdir $$(pwd) composer:2.3.10 install;\
	fi

test-on-php82: prepaire-test-env ## Run unit test on php 8.2
	docker run \
	--user $$(id -u):$$(id -g) \
	--volume $$(pwd):$$(pwd) \
	--workdir $$(pwd) \
	php:8.2-alpine -d memory_limit=-1 \
	bin/phpunit -c tests/phpunit.xml

test-on-php81: prepaire-test-env ## Run unit test on php 8.1
	docker run \
	--user $$(id -u):$$(id -g) \
	--volume $$(pwd):$$(pwd) \
	--workdir $$(pwd) \
	php:8.1-alpine -d memory_limit=-1 \
	bin/phpunit -c tests/phpunit.xml

test-on-php80: prepaire-test-env ## Run unit test on php 8.0
	docker run \
	--user $$(id -u):$$(id -g) \
	--volume $$(pwd):$$(pwd) \
	--workdir $$(pwd) \
	php:8.0-alpine -d memory_limit=-1 \
	bin/phpunit -c tests/phpunit.xml

test-on-php74: prepaire-test-env ## Run unit test on php 7.4
	docker run \
	--user $$(id -u):$$(id -g) \
	--volume $$(pwd):$$(pwd) \
	--workdir $$(pwd) \
	php:7.4-alpine -d memory_limit=-1 \
	bin/phpunit -c tests/phpunit.xml

test-on-php73: prepaire-test-env ## Run unit test on php 7.3
	docker run \
	--user $$(id -u):$$(id -g) \
	--volume $$(pwd):$$(pwd) \
	--workdir $$(pwd) \
	php:7.3-alpine -d memory_limit=-1 \
	bin/phpunit -c tests/phpunit.xml

test: test-on-php82 test-on-php81 test-on-php80 test-on-php74 test-on-php73 ## Run unit test on all php version zf support

it-test-on-php82: prepaire-test-env ## Run intergration test on php 8.2
	PHP_ALPINE_IMAGE=php:8.2-alpine \
	docker-compose up --build --abort-on-container-exit --remove-orphans

it-test-on-php81: prepaire-test-env ## Run intergration test on php 8.1
	PHP_ALPINE_IMAGE=php:8.1-alpine \
	docker-compose up --build --abort-on-container-exit --remove-orphans

it-test-on-php80: prepaire-test-env ## Run intergration test on php 8.0
	PHP_ALPINE_IMAGE=php:8.0-alpine \
	docker-compose up --build --abort-on-container-exit --remove-orphans

it-test-on-php74: prepaire-test-env ## Run intergration test on php 7.4
	PHP_ALPINE_IMAGE=php:7.4-alpine \
	docker-compose up --build --abort-on-container-exit --remove-orphans

it-test-on-php73: prepaire-test-env ## Run intergration test on php 7.3
	PHP_ALPINE_IMAGE=php:7.3-alpine \
	docker-compose up --build --abort-on-container-exit --remove-orphans

it-test: it-test-on-php82 it-test-on-php81 it-test-on-php80 it-test-on-php74 it-test-on-php73 ## Run intergration test on all php version zf support