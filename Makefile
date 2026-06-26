# Makefile for the sbx dev-container templates.
#
#   make builder        one-time: create+use a buildx builder for bake
#   make build          build all images and load them into the local docker
#   make base|kube|ansible
#   make push           build + push the :<variant>-latest tags
#   make test           run dgoss tests against all images
#   make clean          remove built images
#
# Images share one repo; the variant is the tag (e.g. ttyse/sbx-templates:base-latest).
# Set VERSION to also publish an immutable :<variant>-VERSION tag:
#   VERSION=2026-06-26 make push

IMAGE   ?= ttyse/sbx-templates
VERSION ?=
export IMAGE VERSION

BAKE     := docker buildx bake
IMAGES   := base kube ansible

# NB: the per-image test targets (test-base, ...) are matched by the `test-%`
# pattern rule below and must NOT be listed here — GNU make excludes .PHONY
# targets from pattern-rule matching, which would break them.
.PHONY: all build push base kube ansible builder test clean

all: build

## build all images and load them into the local docker image store
build:
	$(BAKE) --load

## build + push the :<variant>-latest tags (and :<variant>-VERSION if VERSION set)
push:
	$(BAKE) --push

## build a single image (loaded locally)
$(IMAGES):
	$(BAKE) --load $@

## one-time buildx builder setup (safe to re-run)
builder:
	docker buildx inspect sbx >/dev/null 2>&1 || docker buildx create --name sbx --use
	docker buildx use sbx

## run all image tests
test: $(addprefix test-,$(IMAGES))

## dgoss test a single image; keeps the container alive via `sleep infinity`
test-%:
	GOSS_FILES_PATH=test/$* dgoss run --entrypoint sleep $(IMAGE):$*-latest infinity

## remove the built images
clean:
	-docker rmi $(addprefix $(IMAGE):,$(addsuffix -latest,$(IMAGES)))
