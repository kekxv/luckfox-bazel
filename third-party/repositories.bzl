"""A centralized module defining all repositories required for third party examples of rules_foreign_cc"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//third-party/ncnn:ncnn_repositories.bzl", "ncnn_repositories")
load("//third-party/opencv:opencv_repositories.bzl", "opencv_repositories")
load("//third-party/protobuf:protobuf_repositories.bzl", "protobuf_repositories")
load("//third-party/zlib:zlib_repositories.bzl", "zlib_repositories")
load("//third-party/zxing-cpp:zxing_repositories.bzl", "zxing_repositories")

# buildifier: disable=unnamed-macro
def repositories():
    """Load all repositories needed for the targets of rules_foreign_cc_examples_third_party"""
    ncnn_repositories()
    opencv_repositories()
    protobuf_repositories()
    zlib_repositories()
    zxing_repositories()
