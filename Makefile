.PHONY: build check lint test xcode-list

XCODEBUILD ?= xcodebuild

check:
	@scripts/check-baseline.sh

lint: check

test: check

build: check

xcode-list:
	@$(XCODEBUILD) -list -project Twemoji.xcodeproj
