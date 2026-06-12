.PHONY: build check lint test xcode-list xcode-build

XCODEBUILD ?= xcodebuild

check:
	@scripts/check-baseline.sh

lint: check

test: check

build: check

xcode-list:
	@$(XCODEBUILD) -list -project Twemoji.xcodeproj

xcode-build:
	@$(XCODEBUILD) -project Twemoji.xcodeproj -target Twemoji -sdk iphonesimulator -configuration Debug CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO ONLY_ACTIVE_ARCH=NO DISABLE_MANUAL_TARGET_ORDER_BUILD_WARNING=YES build
