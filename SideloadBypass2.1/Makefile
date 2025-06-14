TARGET = iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = AppNameHere
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SideloadBypass2
SideloadBypass2_FILES = Tweak/Tweak.mm
SideloadBypass2_FRAMEWORKS = Foundation UIKit
SideloadBypass2_LDFLAGS += -Wl,-segalign,4000

include $(THEOS_MAKE_PATH)/tweak.mk