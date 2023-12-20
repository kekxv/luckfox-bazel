"""A module defining the third party dependency zxing"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

all_content = """
filegroup(name = "all", srcs = glob(["**"]), visibility = ["//visibility:public"])
"""

def zxing_repositories():
    maybe(
        http_archive,
        name = "zxing",
        build_file_content = all_content,
        sha256 = "02078ae15f19f9d423a441f205b1d1bee32349ddda7467e2c84e8f08876f8635",
        strip_prefix = "zxing-cpp-2.2.1",
        patch_cmds = [],
        urls = [
            "https://github.com/zxing-cpp/zxing-cpp/archive/refs/tags/v2.2.1.tar.gz",
        ],
    )
