IMAGE_NAME := quay.io/theauthgear/golang
PLATFORM := linux/amd64,linux/arm64
VARIANT := noble

.PHONY: image
image:
	for version in $$(jq -r "keys[]" versions.json); do \
		patch=$$(jq -r ".\"$$version\".version" versions.json) && \
		docker buildx build --pull --platform=$(PLATFORM) -t $(IMAGE_NAME):$$version-$(VARIANT) -t $(IMAGE_NAME):$$patch-$(VARIANT) --push $$version/$(VARIANT); \
	done
