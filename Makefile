TARGET := iphone:clang:latest:11.0
ARCHS = arm64
PACKAGE_VERSION = 1.0.0
INSTALL_TARGET_PROCESSES = YouTube

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = yt-ios-tweaks
yt-ios-tweaks_FILES = Tweak.x
yt-ios-tweaks_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
