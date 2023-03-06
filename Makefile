# Platform can be overwritten, the platform type arm64 is used for M1 silicon chips
# of apple
PLATFORM?=linux/arm64/v8

GIT_VERSION ?= $(shell git rev-parse --abbrev-ref HEAD)

# Version definitions, project is our version, dbt is version of dbt to use
PROJECT_NAME?=FINA
DBT_VERSION?=latest
PROJECT_VERSION?=prd
VERSION=${DBT_VERSION}_${PROJECT_VERSION}

HUB?=docker.for.mac.localhost:5001
REPO?=snowboard
IMAGE?=${HUB}/${REPO}

VOLUME_PROFILE?=~/.dbt/profiles.yml:/root/.dbt/profiles.yml
VOLUME_PROJECT?=$(PWD)/FINA:/usr/app/snow/dbt_packages/FINA
VOLUMES?=-v ${VOLUME_PROFILE} -v ${VOLUME_PROJECT}

.PHONY: dbt-deps
dbt-deps:
	docker run --rm -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:${VERSION} deps

.PHONY: login
login:
	aws ecr get-login-password --region ${AWS_REGION} --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com

.PHONY: dbt-init
dbt-init:
	docker run --rm ${VOLUMES} -e PROJECT_NAME=${PROJECT_NAME} -e ENV=${GIT_VERSION} -it ${IMAGE} init

.PHONY: dbt-clean
dbt-clean:
	docker run --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE} clean

.PHONY: dbt-run
dbt-run:
	docker run --rm ${VOLUMES} -e ENV=${GIT_VERSION} -e PROJECT_NAME=${PROJECT_NAME} -it ${IMAGE}:${VERSION} run
