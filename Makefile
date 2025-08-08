IMAGE_NAME := quay.io/theauthgear/golang
PLATFORM := linux/amd64,linux/arm64
VARIANT := noble

.PHONY: image
image:
	for version in $(shell jq --raw-output '(keys | map(select(. != "tip" and (endswith("-rc") | not))))[]' versions.json); do \
		patch=$$(jq --raw-output ".\"$$version\".version" versions.json) && \
		docker buildx build --pull --platform=$(PLATFORM) -t $(IMAGE_NAME):$$version-$(VARIANT) -t $(IMAGE_NAME):$$patch-$(VARIANT) --push $$version/$(VARIANT); \
	done
