#!/bin/bash

# FFmpeg Android Build Script for armeabi-v7a
# Minimal build with specific codecs: AV1, VP9, HEVC, H.264
# Target: Android API 24, NDK r21e, static nonfree build

set -e

# Configuration
export ANDROID_NDK_HOME="${ANDROID_NDK_HOME:-$HOME/android-ndk-r21e}"
export ANDROID_API=24
export ANDROID_ARCH=arm
export ANDROID_EABI=armv7a-linux-androideabi
export MIN_SDK_VERSION=24

# Build directories
BUILD_DIR="$(pwd)/build"
OUTPUT_DIR="$(pwd)/output"
FFMPEG_DIR="$(pwd)/ffmpeg"

# Toolchain setup
TOOLCHAIN=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64
SYSROOT=$TOOLCHAIN/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/armv7a-linux-androideabi${MIN_SDK_VERSION}-

export CC="${CROSS_PREFIX}clang"
export CXX="${CROSS_PREFIX}clang++"
export AR="$TOOLCHAIN/bin/llvm-ar"
export AS="${CROSS_PREFIX}clang"
export LD="$TOOLCHAIN/bin/ld"
export RANLIB="$TOOLCHAIN/bin/llvm-ranlib"
export STRIP="$TOOLCHAIN/bin/llvm-strip"
export NM="$TOOLCHAIN/bin/llvm-nm"

# Additional flags
export CFLAGS="-O3 -fPIC -DANDROID -D__ANDROID_API__=$MIN_SDK_VERSION -march=armv7-a -mfloat-abi=softfp -mfpu=neon"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="-L$SYSROOT/usr/lib/arm-linux-androideabi/$MIN_SDK_VERSION -L$SYSROOT/usr/lib/arm-linux-androideabi -lc -lm -ldl"

echo "========================================"
echo "FFmpeg Android Build Configuration"
echo "========================================"
echo "NDK Home: $ANDROID_NDK_HOME"
echo "API Level: $ANDROID_API"
echo "Architecture: armeabi-v7a"
echo "Toolchain: $TOOLCHAIN"
echo "========================================"

# Create build directories
mkdir -p "$BUILD_DIR"
mkdir -p "$OUTPUT_DIR"

# Clone FFmpeg if not exists
if [ ! -d "$FFMPEG_DIR" ]; then
    echo "Cloning FFmpeg (shallow clone with submodules)..."
    git clone --recurse-submodules --remote-submodules --shallow-submodules -j4 --depth 1 \
        'https://git.ffmpeg.org/ffmpeg.git' "$FFMPEG_DIR"
fi

cd "$FFMPEG_DIR"

# Configure FFmpeg with minimal codec set
echo "Configuring FFmpeg..."
./configure \
    --prefix="$OUTPUT_DIR" \
    --enable-cross-compile \
    --target-os=android \
    --arch=arm \
    --cpu=armv7-a \
    --cross-prefix="${CROSS_PREFIX}" \
    --sysroot="$SYSROOT" \
    --cc="${CC}" \
    --cxx="${CXX}" \
    --ar="${AR}" \
    --ranlib="${RANLIB}" \
    --strip="${STRIP}" \
    --nm="${NM}" \
    --extra-cflags="$CFLAGS" \
    --extra-cxxflags="$CXXFLAGS" \
    --extra-ldflags="$LDFLAGS" \
    --enable-static \
    --disable-shared \
    --enable-nonfree \
    --enable-gpl \
    --disable-doc \
    --disable-htmlpages \
    --disable-manpages \
    --disable-podpages \
    --disable-txtpages \
    --disable-debug \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-avdevice \
    --disable-postproc \
    --disable-network \
    --disable-bsfs \
    --disable-filters \
    --disable-protocols \
    --enable-protocol=file \
    --disable-devices \
    --disable-muxers \
    --disable-demuxers \
    --enable-demuxer=matroska \
    --enable-demuxer=mov \
    --enable-demuxer=mp4 \
    --enable-demuxer=h264 \
    --enable-demuxer=hevc \
    --enable-demuxer=ivf \
    --enable-demuxer=webm_dash_manifest \
    --disable-parsers \
    --enable-parser=av1 \
    --enable-parser=vp9 \
    --enable-parser=h264 \
    --enable-parser=hevc \
    --disable-encoders \
    --enable-encoder=libx264 \
    --enable-encoder=libsvtav1 \
    --enable-encoder=libvpx_vp9 \
    --enable-encoder=libx265 \
    --disable-decoders \
    --enable-decoder=av1 \
    --enable-decoder=libdav1d \
    --enable-decoder=libaom_av1 \
    --enable-decoder=vp9 \
    --enable-decoder=libvpx_vp9 \
    --enable-decoder=hevc \
    --enable-decoder=libx265 \
    --enable-decoder=h264 \
    --enable-libdav1d \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libvpx \
    --enable-libsvtav1 \
    --enable-libaom \
    --disable-everything \
    --enable-avcodec \
    --enable-avformat \
    --enable-avutil \
    --enable-swresample \
    --enable-swscale \
    --enable-small \
    --enable-asm \
    --enable-neon

echo "Building FFmpeg..."
make -j$(nproc)

echo "Installing to output directory..."
make install

echo "========================================"
echo "Build Complete!"
echo "========================================"
echo "Output directory: $OUTPUT_DIR"
ls -lh "$OUTPUT_DIR/lib/"
echo "========================================"

# Create archive for release
cd "$OUTPUT_DIR"
RELEASE_NAME="ffmpeg-android-armeabi-v7a-minimal-$(date +%Y%m%d)"
tar -czf "../${RELEASE_NAME}.tar.gz" .
echo "Release archive created: ${RELEASE_NAME}.tar.gz"
