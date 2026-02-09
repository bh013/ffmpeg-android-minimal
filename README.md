# FFmpeg Android Minimal Build (armeabi-v7a)

A minimal, optimized FFmpeg build for Android with only essential video codecs. This project provides automated builds of FFmpeg with AV1, VP9, HEVC, and H.264 support.

## Features

- **Static build** - No shared library dependencies
- **Nonfree enabled** - Includes GPL and proprietary codecs
- **Minimal size** - Only selected codecs, no unnecessary components
- **Automated builds** - GitHub Actions workflow for consistent releases
- **Android NDK r21e** - Compatible with API level 24+
- **armeabi-v7a** - Optimized for ARMv7 with NEON

## Supported Codecs

### Decoders
| Format | Decoders |
|--------|----------|
| AV1 | `av1` (native), `libdav1d`, `libaom_av1` |
| VP9 | `vp9` (native), `libvpx_vp9` |
| HEVC/H.265 | `hevc` (native), `libx265` |
| H.264 | `h264` (native) |

### Encoders
| Format | Encoders |
|--------|----------|
| AV1 | `libsvtav1` |
| VP9 | `libvpx_vp9` |
| HEVC/H.265 | `libx265` |
| H.264 | `libx264` |

## Build Configuration

- **Android NDK:** r21e
- **API Level:** 24 (Android 7.0+)
- **Architecture:** armeabi-v7a
- **Linking:** Static
- **CPU Features:** ARMv7-a with NEON, soft-float ABI
- **Optimization:** `-O3` with size optimizations

## Quick Start

### Using Pre-built Releases

1. Download the latest release from [Releases](../../releases)
2. Extract the archive:
   ```bash
   tar -xzf ffmpeg-android-armeabi-v7a-minimal.tar.gz
   ```
3. Link against the static libraries in your Android project

### Building from Source

#### Prerequisites

- Ubuntu 22.04+ (or similar Linux distribution)
- Android NDK r21e
- Build tools: git, make, yasm, nasm, cmake, pkg-config

#### Build Steps

1. Clone this repository:
   ```bash
   git clone <your-repo-url>
   cd ffmpeg-android-minimal
   ```

2. Download and extract Android NDK r21e:
   ```bash
   cd ~
   wget https://dl.google.com/android/repository/android-ndk-r21e-linux-x86_64.zip
   unzip android-ndk-r21e-linux-x86_64.zip
   export ANDROID_NDK_HOME=$HOME/android-ndk-r21e
   ```

3. Run the build script:
   ```bash
   ./build_ffmpeg_android.sh
   ```

4. Find the build output in the `output/` directory

## Integration with Android Projects

### Using with CMake

Add to your `CMakeLists.txt`:

```cmake
set(FFMPEG_DIR "${CMAKE_SOURCE_DIR}/ffmpeg")

add_library(avcodec STATIC IMPORTED)
set_target_properties(avcodec PROPERTIES
    IMPORTED_LOCATION ${FFMPEG_DIR}/lib/libavcodec.a
)

add_library(avformat STATIC IMPORTED)
set_target_properties(avformat PROPERTIES
    IMPORTED_LOCATION ${FFMPEG_DIR}/lib/libavformat.a
)

add_library(avutil STATIC IMPORTED)
set_target_properties(avutil PROPERTIES
    IMPORTED_LOCATION ${FFMPEG_DIR}/lib/libavutil.a
)

add_library(swscale STATIC IMPORTED)
set_target_properties(swscale PROPERTIES
    IMPORTED_LOCATION ${FFMPEG_DIR}/lib/libswscale.a
)

add_library(swresample STATIC IMPORTED)
set_target_properties(swresample PROPERTIES
    IMPORTED_LOCATION ${FFMPEG_DIR}/lib/libswresample.a
)

include_directories(${FFMPEG_DIR}/include)

target_link_libraries(your-library
    avcodec
    avformat
    avutil
    swscale
    swresample
    z
    m
)
```

### Using with Gradle (ndk-build)

1. Copy the libraries to `src/main/jniLibs/armeabi-v7a/`
2. Copy headers to `src/main/cpp/include/`
3. Reference in your `Android.mk`:

```makefile
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := avcodec
LOCAL_SRC_FILES := ../jniLibs/armeabi-v7a/libavcodec.a
include $(PREBUILT_STATIC_LIBRARY)

# Repeat for other libraries...

include $(CLEAR_VARS)
LOCAL_MODULE := your-library
LOCAL_SRC_FILES := your-code.cpp
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_STATIC_LIBRARIES := avcodec avformat avutil swscale swresample
LOCAL_LDLIBS := -lz -lm -llog
include $(BUILD_SHARED_LIBRARY)
```

## Project Structure

```
.
 build_ffmpeg_android.sh      # Main build script
 .github/
   └── workflows/
       └── build-release.yml    # GitHub Actions workflow
 README.md                     # This file
 output/                       # Build output (generated)
    ├── lib/                      # Static libraries
    ├── include/                  # Header files
    └── bin/                      # Binaries (if enabled)
```

## GitHub Actions Workflow

The repository includes an automated build workflow that:

1. Sets up the build environment
2. Downloads and caches Android NDK r21e
3. Builds all external dependencies (dav1d, x264, x265, libvpx, SVT-AV1, libaom)
4. Configures and builds FFmpeg
5. Creates release archives
6. Publishes releases on git tags

### Triggering a Release

To create a new release:

```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

The workflow will automatically build and publish the release.

## Build Customization

### Modifying Codecs

Edit `build_ffmpeg_android.sh` and adjust the `--enable-decoder` and `--enable-encoder` flags:

```bash
--enable-decoder=av1 \
--enable-decoder=libdav1d \
# Add more decoders here
```

### Changing Target Architecture

To build for different architectures, modify these variables in `build_ffmpeg_android.sh`:

```bash
export ANDROID_ARCH=arm64           # For arm64-v8a
export ANDROID_EABI=aarch64-linux-android
```

And update the configure flags accordingly.

## Troubleshooting

### NDK Not Found

Ensure `ANDROID_NDK_HOME` is set:
```bash
export ANDROID_NDK_HOME=$HOME/android-ndk-r21e
```

### Build Fails with Missing Dependencies

Some external libraries (dav1d, x264, x265, etc.) need to be built first. The GitHub Actions workflow handles this automatically, but for local builds, you may need to build them separately.

### Disk Space Issues

The full FFmpeg source with git history is ~500MB. Use shallow clone to save space:
```bash
git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git
```

## License

This project configuration is provided as-is. FFmpeg and its dependencies are subject to their respective licenses:

- **FFmpeg**: LGPL 2.1+ or GPL 2+ (this build uses GPL with nonfree)
- **x264**: GPL 2+
- **x265**: GPL 2+
- **libvpx**: BSD 3-Clause
- **dav1d**: BSD 2-Clause
- **SVT-AV1**: BSD 2-Clause Clear
- **libaom**: BSD 2-Clause

**Note:** This is a nonfree build that cannot be redistributed in some contexts. Ensure you understand the licensing implications for your use case.

## References

- [FFmpeg Official Documentation](https://ffmpeg.org/documentation.html)
- [Android NDK Documentation](https://developer.android.com/ndk)
- [FFmpeg Compilation Guide](https://trac.ffmpeg.org/wiki/CompilationGuide)

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## Support

For issues and questions:
- Open an issue on GitHub
- Check FFmpeg documentation
- Review build logs in GitHub Actions

---

**Built with ❤️ for efficient Android video processing**
