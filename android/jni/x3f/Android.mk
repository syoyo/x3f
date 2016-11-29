LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# OpenCV(Must be defeined befor `LOCAL_MODULE` definition. -----------------
OPENCV_LIB_TYPE := STATIC
OPENCV_INSTALL_MODULES: on
include $(LOCAL_PATH)/../../deps/OpenCV-android-sdk/sdk/native/jni/OpenCV.mk
# --------------------------------------------------------------------------
 

LOCAL_MODULE := x3f

# Do not define NEON for arm64-v8a(its natively supported in ARM64bit)
ifeq ($(TARGET_ARCH_ABI),$(filter $(TARGET_ARCH_ABI), armeabi-v7a))
LOCAL_ARM_NEON := true
#LOCAL_ARM_MODE := arm
endif

# For address sanitizer
#LOCAL_CLANG := true
#LOCAL_SANITIZE := address
#LOCAL_MODULE_RELATIVE_PATH := asan
#LOCAL_CFLAGS := -Wall -fexceptions -Wno-extern-c-compat -fno-omit-frame-pointer

# For release build
LOCAL_CFLAGS := -Wall -fexceptions -Wno-extern-c-compat
LOCAL_CXXFLAGS := -O3 -g -std=c++11 -Wno-missing-braces

# FIXME
LOCAL_CFLAGS += -DVERSION=\"devel\"
LOCAL_CXXFLAGS += -DVERSION=\"devel\"

# OpenCV ---------------------------------------------------------------------
#LOCAL_CFLAGS += -DENABLE_OPENCV31
#LOCAL_CXXFLAGS += -DENABLE_OPENCV31
# ----------------------------------------------------------------------------

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/../../../src

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_C_INCLUDES)

# Add your application source files here...
LOCAL_SRC_FILES := \
   	../../../src/x3f_denoise.cpp \
   	../../../src/x3f_denoise_aniso.cpp \
   	../../../src/x3f_denoise_utils.cpp \
   	../../../src/x3f_histogram.c \
   	../../../src/x3f_image.c \
   	../../../src/x3f_io.c \
   	../../../src/x3f_matrix.c \
   	../../../src/x3f_meta.c \
   	../../../src/x3f_printf.c \
   	../../../src/x3f_process.c \
   	../../../src/x3f_spatial_gain.c \
   	../../../src/x3f_version.c \

LOCAL_LDLIBS := -llog -lz

include $(BUILD_SHARED_LIBRARY)
