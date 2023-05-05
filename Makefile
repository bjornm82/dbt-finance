# Platform can be overwritten, the platform type arm64 is used for M1 silicon chips
# of apple
PLATFORM?=linux/arm64/v8

GIT_VERSION ?= $(shell git rev-parse --abbrev-ref HEAD)

# Version definitions, project is our version, dbt is version of dbt to use
PROJECT_NAME?=FINA
DBT_VERSION?=latest
PROJECT_VERSION?=prd
VERSION=${DBT_VERSION}_${PROJECT_VERSION}

HUB?=bjornmooijekind
REPO?=dbt-snowboard
IMAGE?=${HUB}/${REPO}

VOLUME_PROFILE?=~/.dbt/profiles.yml:/root/.dbt/profiles.yml
VOLUME_PROJECT?=$(PWD)/fina:/usr/app/snow/dbt_packages/fina
VOLUMES?=-v ${VOLUME_PROFILE} -v ${VOLUME_PROJECT}

.PHONY: exec
exec:
	docker run --pull=always --rm ${VOLUMES} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:latest /bin/bash

.PHONY: dbt-deps
dbt-deps:
	docker run --pull=always --rm ${VOLUMES} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:latest dbt deps

.PHONY: dbt-clean
dbt-clean:
	docker run --pull=always --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:latest dbt clean

.PHONY: dbt-run
dbt-run:
	docker run --pull=always --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:latest dbt run --select state:modified --state=./
