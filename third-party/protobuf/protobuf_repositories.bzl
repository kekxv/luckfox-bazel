"""A module defining the third party dependency protobuf"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def protobuf_repositories():
    maybe(
        http_archive,
        name = "protobuf",
        build_file_content = """filegroup(name = "all", srcs = glob(["**"]), visibility = ["//visibility:public"])""",
        urls = [
            "https://github.com/protocolbuffers/protobuf/releases/download/v3.19.6/protobuf-cpp-3.19.6.tar.gz",
        ],
        patch_cmds = [
        ],
        type = "tar.gz",
        sha256 = "ce265155f21be19047df17f7220522ab38ffa8d77027e7baaf9bf7bbd726e802",
        strip_prefix = "protobuf-3.19.6",
    )
