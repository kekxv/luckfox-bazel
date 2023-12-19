"""A module defining the third party dependency opencv"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def opencv_repositories():
    maybe(
        http_archive,
        name = "opencv_src",
        build_file_content = """filegroup(name = "all", srcs = glob(["**"]), visibility = ["//visibility:public"])""",
        urls = [
            "https://github.com/nihui/opencv-mobile/releases/download/v22/opencv-mobile-4.8.1.zip",
        ],
        patch_cmds = [
            "sed -i.bak 's/target_link_libraries(${target} ${ARGN})/target_link_libraries(${target} ${ARGN} -std=c++11 -static-libgcc -static-libstdc++ -Wl,-Bstatic -lstdc++ -lpthread )/g' cmake/OpenCVUtils.cmake",
            # "sed -i.bak 's/ocv_update(OPENCV_DLLVERSION \"${OPENCV_VERSION_MAJOR}${OPENCV_VERSION_MINOR}${OPENCV_VERSION_PATCH}\")/ocv_update(OPENCV_DLLVERSION \"\")/g' CMakeLists.txt",
            # "sed -i.bak 's/  if (defined(__ARM_NEON__) \\|\\| defined(__ARM_NEON)) / if defined(PNG_ARM_NEON) \\&\\& (defined(ARM_NEON) \\|\\| defined(__ARM_NEON)) /g' 3rdparty/libpng/pngpriv.h",
            "sed -i.bak 's/ int old_rounding_direction = std::fegetround();/ \\/\\/int old_rounding_direction = std::fegetround();/g' modules/dnn/src/layers/elementwise_layers.cpp",
            "sed -i.bak 's/ std::fesetround(FE_TONEAREST);/ \\/\\/std::fesetround(FE_TONEAREST);/g' modules/dnn/src/layers/elementwise_layers.cpp",
            "sed -i.bak 's/ std::fesetround(old_rounding_direction);/ \\/\\/std::fesetround(old_rounding_direction);/g' modules/dnn/src/layers/elementwise_layers.cpp",
        ],
        type = "zip",
        sha256 = "60625c3db1b00dd03ffc4094efef4c4ed97ff5ecb661ca31bb1f842c99f57a32",
        strip_prefix = "opencv-mobile-4.8.1",
    )
