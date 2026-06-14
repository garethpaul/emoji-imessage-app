.PHONY: build check lint test xcode-list xcode-build

override ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
XCODEBUILD ?= xcodebuild

check:
	@"$(ROOT)scripts/check-baseline.sh"

lint: check

test: check

build: check

xcode-list:
	@$(XCODEBUILD) -list -project "$(ROOT)Twemoji.xcodeproj"

xcode-build:
	@$(XCODEBUILD) -project "$(ROOT)Twemoji.xcodeproj" -target Twemoji -sdk iphonesimulator -configuration Debug CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO ONLY_ACTIVE_ARCH=NO DISABLE_MANUAL_TARGET_ORDER_BUILD_WARNING=YES build
