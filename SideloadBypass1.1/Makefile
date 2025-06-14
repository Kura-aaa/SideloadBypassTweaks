TARGET = iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = AppNameHere
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SideloadBypass1
SideloadBypass1_FILES = Tweak/Tweak.xm
SideloadBypass1_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/tweak.mk