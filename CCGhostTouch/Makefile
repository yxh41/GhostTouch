ifeq ($(THEOS_DEVICE_SIMULATOR),1)
ARCHS := x86_64 arm64
TARGET := simulator:clang:latest:15.0
IPHONE_SIMULATOR_ROOT := $(shell ../devkit/sim-root.sh)
else
ARCHS := arm64 arm64e
TARGET := iphone:clang:16.5:15.0
INSTALL_TARGET_PROCESSES := SpringBoard
endif

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME := CCGhostTouch

CCGhostTouch_BUNDLE_EXTENSION += bundle

CCGhostTouch_FILES += CCGhostTouch.mm
CCGhostTouch_FILES += $(wildcard ../TVZPrefs/*.mm)

ifeq ($(THEOS_DEVICE_SIMULATOR),1)
CCGhostTouch_FILES += ../libroot/dyn.c
endif
ifeq ($(THEOS_PACKAGE_SCHEME),roothide)
CCGhostTouch_FILES += ../libroot/dyn.c
endif

CCGhostTouch_CFLAGS += -fobjc-arc
CCGhostTouch_CFLAGS += -I../TVZPrefs
CCGhostTouch_CFLAGS += -DPACKAGE_VERSION=\"$(PACKAGE_VERSION)\"

ifeq ($(THEOS_DEVICE_SIMULATOR),1)
CCGhostTouch_CFLAGS += -DIPHONE_SIMULATOR_ROOT=\"$(IPHONE_SIMULATOR_ROOT)\"
endif

ifeq ($(THEOS_DEVICE_SIMULATOR),1)
CCGhostTouch_LDFLAGS += -FFrameworks/_Simulator
endif

CCGhostTouch_FRAMEWORKS += UIKit
CCGhostTouch_PRIVATE_FRAMEWORKS += ControlCenterUIKit
CCGhostTouch_INSTALL_PATH += /Library/ControlCenter/Bundles

include $(THEOS_MAKE_PATH)/bundle.mk
