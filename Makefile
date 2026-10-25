export PACKAGE_VERSION := 4.2

ifeq ($(THEOS_DEVICE_SIMULATOR),1)
ARCHS := arm64 x86_64
TARGET := simulator:clang:latest:15.0
FWK_DIR := Frameworks/_Simulator
IPHONE_SIMULATOR_ROOT := $(shell devkit/sim-root.sh)
else
ARCHS := arm64 arm64e
TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES := SpringBoard
FWK_DIR := Frameworks
endif

include $(THEOS)/makefiles/common.mk

SUBPROJECTS += TVZPrefs
SUBPROJECTS += CCGhostTouch

include $(THEOS_MAKE_PATH)/aggregate.mk

TWEAK_NAME := GhostTouch

GhostTouch_USE_MODULES := 0

GhostTouch_FILES += $(wildcard TVZPrefs/*.mm)
GhostTouch_FILES += $(wildcard TVZQuickPath/*.swift)
GhostTouch_FILES += $(wildcard LNTouchVisualizer/Private/*.m)
GhostTouch_FILES += GhostTouch.xm

ifeq ($(THEOS_DEVICE_SIMULATOR),1)
GhostTouch_FILES += libroot/dyn.c
endif

ifeq ($(THEOS_PACKAGE_SCHEME),roothide)
GhostTouch_FILES += libroot/dyn.c
GhostTouch_LIBRARIES += roothide
endif

GhostTouch_CFLAGS += -fobjc-arc
GhostTouch_CFLAGS += -I.
GhostTouch_CFLAGS += -ILNTouchVisualizer
GhostTouch_CFLAGS += -ILNTouchVisualizer/Private
GhostTouch_CFLAGS += -DPACKAGE_VERSION=\"$(PACKAGE_VERSION)\"

ifeq ($(THEOS_DEVICE_SIMULATOR),1)
GhostTouch_CFLAGS += -DIPHONE_SIMULATOR_ROOT=\"$(IPHONE_SIMULATOR_ROOT)\"
endif

GhostTouch_CCFLAGS += -Wno-unused-variable
GhostTouch_CCFLAGS += -Wno-unused-function

GhostTouch_LDFLAGS += -F$(FWK_DIR)

ifeq ($(THEOS_DEVICE_SIMULATOR),1)
GhostTouch_LDFLAGS += -rpath /opt/simject
endif

GhostTouch_SWIFT_BRIDGING_HEADER += GhostTouch-Bridging-Header.h
GhostTouch_PRIVATE_FRAMEWORKS += FrontBoardServices

ifeq ($(THEOS_DEVICE_SIMULATOR),1)
GhostTouch_EXTRA_FRAMEWORKS += RevealServer
endif

include $(THEOS_MAKE_PATH)/tweak.mk

export DEBUG
before-all::
	devkit/standardize-entitlements.sh

export THEOS_OBJ_DIR
after-all::
	@devkit/sim-install.sh
