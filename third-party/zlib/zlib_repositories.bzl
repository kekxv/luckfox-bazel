"""A module defining the third party dependency zlib"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

all_content = """
filegroup(name = "all", srcs = glob(["**"]), visibility = ["//visibility:public"])
"""

def zlib_repositories():
    maybe(
        http_archive,
        name = "zlib_patch",
        build_file_content = all_content,
        sha256 = "b3a24de97a8fdbc835b9833169501030b8977031bcb54b3b3ac13740f846ab30",
        strip_prefix = "zlib-1.2.13",
        patch_cmds = [
            #            "find . -name 'CMakeLists.txt' -exec sed -i.orig '186d' {} +",
            "find . -name 'CMakeLists.txt' -exec sed -i.orig '77d' {} +",
            "sed -i.bak 's/RUNTIME DESTINATION \"${INSTALL_BIN_DIR}\"/RUNTIME DESTINATION \"${INSTALL_BIN_DIR}\"\\n        RUNTIME DESTINATION \"${INSTALL_LIB_DIR}\"/g' CMakeLists.txt",
            "sed -i.bak 's/project(zlib C)/project(zlib C)\\nadd_definitions(-fPIC)/g' CMakeLists.txt",
            "sed -i.bak 's/install(TARGETS zlib zlibstatic/install(TARGETS zlibstatic/g' CMakeLists.txt",
            "sed -i.bak 's/#define NOUNCRYPT/ \\/\\/#define NOUNCRYPT/g' contrib/minizip/unzip.c",
        ],
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/zlib.net/zlib-1.2.13.tar.gz",
            "https://zlib.net/zlib-1.2.13.tar.gz",
        ],
    )
    maybe(
        http_archive,
        name = "zlib",
        build_file_content = all_content,
        sha256 = "b3a24de97a8fdbc835b9833169501030b8977031bcb54b3b3ac13740f846ab30",
        strip_prefix = "zlib-1.2.13",
        patch_cmds = [
            "sed -i.bak 's/#define NOUNCRYPT/ \\/\\/#define NOUNCRYPT/g' contrib/minizip/unzip.c",
        ],
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/zlib.net/zlib-1.2.13.tar.gz",
            "https://zlib.net/zlib-1.2.13.tar.gz",
        ],
    )
