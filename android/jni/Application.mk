#APP_ABI := x86_64
APP_ABI := arm64-v8a x86_64
#APP_ABI := armeabi-v7a arm64-v8a
#APP_ABI := armeabi-v7a

#APP_STL := c++_static
#APP_STL := stlport_static
APP_STL := gnustl_static
#APP_CFLAGS := -O3 -DNDEBUG -g

# Ofast = break some IEEE754
#APP_CFLAGS = -O3 -ffast-math -funroll-loops

#APP_OPTIM=release

#NDK_TOOLCHAIN_VERSION=clang
