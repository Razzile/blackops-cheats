TARGET_STRIP_FLAGS = -u -r -s /dev/null
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = blackops
blackops_FILES = test.mm
blackops_CFLAGS += -std=c++11 -stdlib=libc++ -Os
blackops_LIBRARIES = c++ Liberation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 blackops"
