HOST_SYS =
HOST_CPU =

ifdef COMSPEC
  HOST_SYS = windows
  HOST_CPU = $(shell uname -m)
else
  UNAME = $(shell uname -s)
ifeq ($(UNAME), Linux)
  HOST_SYS = linux
  HOST_CPU = $(shell uname -m)
else
ifeq ($(UNAME), Darwin)
  HOST_SYS = osx
  HOST_CPU = universal
endif
endif
endif

ifndef HOST_SYS
  HOST_SYS = generic
  $(warning WARNING: Could not determine host system, assuming $(HOST_SYS))
endif

ifndef HOST_CPU
  HOST_CPU = generic
  $(warning WARNING: Could not determine host CPU, assuming $(HOST_CPU))
endif

HOST = $(HOST_SYS)-$(HOST_CPU)

ifndef TARGET
  TARGET = $(HOST)
endif
TARGET_SYS = $(shell echo $(TARGET) | sed "s/-.*$$//")
TARGET_CPU = $(shell echo $(TARGET) | sed "s/^$(TARGET_SYS)-//")

CC =
CXX =
CMAKE_TOOLCHAIN =
LIPO =
SDKFLAGS =
STRIP = strip
INSTFLAGS =

ifeq ($(HOST), $(TARGET))
  CC = gcc
  CXX = g++
ifeq ($(HOST_SYS), osx)
  #LIPO = lipo
endif
else				# Cross compilation
ifeq ($(HOST_SYS), linux)
ifeq ($(TARGET), windows-x86_64)
  CC = x86_64-w64-mingw32-gcc
  CXX = x86_64-w64-mingw32-g++
  CMAKE_TOOLCHAIN = x86_64-w64-mingw32.cmake
else
ifeq ($(TARGET), windows-i686)
  CC = i686-w64-mingw32-gcc
  CXX = i686-w64-mingw32-g++
  CMAKE_TOOLCHAIN = i686-w64-mingw32.cmake
else
ifeq ($(TARGET), osx-x86_64)
  CC = x86_64-apple-darwin11-gcc
  CXX = x86_64-apple-darwin11-g++
  CMAKE_TOOLCHAIN = x86_64-apple-darwin11.cmake
  SDKFLAGS = -mmacosx-version-min=10.7 -arch x86_64
  STRIP = x86_64-apple-darwin11-strip
else
ifeq ($(TARGET), osx-i386)
  CC = i386-apple-darwin11-gcc
  CXX = i386-apple-darwin11-g++
  CMAKE_TOOLCHAIN = i386-apple-darwin11.cmake
  SDKFLAGS = -mmacosx-version-min=10.7 -arch i386
  STRIP = i386-apple-darwin11-strip
else
ifeq ($(TARGET), osx-universal)
  #LIPO = x86_64-apple-darwin11-lipo
  #STRIP = x86_64-apple-darwin11-strip
endif
endif
endif
endif
endif
else
ifeq ($(HOST_SYS), osx)
ifeq ($(TARGET_SYS), osx)
  CC = gcc
  CXX = g++
  #SDKFLAGS = -isysroot /Developer/SDKs/MacOSX10.7.sdk -mmacosx-version-min=10.7 -arch $(TARGET_CPU)
  SDKFLAGS = -I /usr/local/Cellar/opencv3/3.1.0_3/include/
endif
endif
endif
endif

ifneq ($(STRIP), strip)
  INSTFLAGS = --strip-program=$(STRIP)
endif

ifeq ($(TARGET), osx-universal)

ifndef LIPO
  #$(error Building universal binaries for target $(TARGET) on host $(HOST) is unsupported)
endif

else

ifndef CC
  $(error C compilation for target $(TARGET) on host $(HOST) is unsupported)
endif

ifndef CXX
  $(error C++ compilation for target $(TARGET) on host $(HOST) is unsupported)
endif

endif
