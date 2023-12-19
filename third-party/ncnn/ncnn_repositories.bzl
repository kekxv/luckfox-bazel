"""A module defining the third party dependency ncnn"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "new_git_repository")

all_content = """filegroup(name = "all", srcs = glob(["**"]), visibility = ["//visibility:public"])"""

def ncnn_repositories():
    maybe(
        http_archive,
        name = "ncnn",
        build_file_content = all_content,
        patch_cmds = [
            "sed -i.bak 's/generate_export_header(ncnn)/generate_export_header(ncnn)\\ntarget_link_libraries(ncnn PRIVATE -lm -lstdc++)/g' src/CMakeLists.txt",
            "sed -i.bak 's/macro(ncnn_install_tool toolname)/macro(ncnn_install_tool toolname)\\n    target_link_libraries(\\${toolname} PRIVATE -lm -lstdc++)/g' tools/CMakeLists.txt",
            "sed -i.bak 's/target_link_libraries(benchncnn PRIVATE ncnn)/target_link_libraries(benchncnn PRIVATE ncnn)/g' benchmark/CMakeLists.txt",
            # "sed -i.bak 's/generate_export_header(ncnn)/generate_export_header(ncnn)\\ntarget_link_libraries(ncnn PRIVATE -static -lstdc++ -static-libgcc -static-libstdc++)/g' src/CMakeLists.txt",
        ],
        sha256 = "8d85896ed095d09f05fff32fc85d75eea0b971796ce0f48a9874d93d3d347674",
        strip_prefix = "ncnn-20231027",
        urls = [
            "https://github.com/Tencent/ncnn/archive/refs/tags/20231027.tar.gz",
        ],
    )
