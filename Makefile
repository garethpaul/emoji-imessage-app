.PHONY: check xcode-list

XCODEBUILD ?= xcodebuild

check:
	@scripts/check-baseline.sh

xcode-list:
	@$(XCODEBUILD) -list -project Twemoji.xcodeproj
