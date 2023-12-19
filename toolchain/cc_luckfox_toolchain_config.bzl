load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "artifact_name_pattern",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
)

all_compile_actions = [
    ACTION_NAMES.c_compile,
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.assemble,
    ACTION_NAMES.preprocess_assemble,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.clif_match,
    ACTION_NAMES.lto_backend,
]

all_cpp_compile_actions = [
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.clif_match,
]

preprocessor_compile_actions = [
    ACTION_NAMES.c_compile,
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.preprocess_assemble,
    ACTION_NAMES.cpp_header_parsing,
    ACTION_NAMES.cpp_module_compile,
    ACTION_NAMES.clif_match,
]

codegen_compile_actions = [
    ACTION_NAMES.c_compile,
    ACTION_NAMES.cpp_compile,
    ACTION_NAMES.linkstamp_compile,
    ACTION_NAMES.assemble,
    ACTION_NAMES.preprocess_assemble,
    ACTION_NAMES.cpp_module_codegen,
    ACTION_NAMES.lto_backend,
]

all_link_actions = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]

def _impl(ctx):
    gcc_path = ctx.attr.path + "bin/arm-rockchip830-linux-uclibcgnueabihf-"
    tool_paths = [
        tool_path(
            name = "gcc",
            path = gcc_path + "gcc",
        ),
        tool_path(
            name = "ranlib",
            path = gcc_path + "ranlib",
        ),
        tool_path(
            name = "ld",
            path = gcc_path + "ld",
        ),
        tool_path(
            name = "cpp",
            path = gcc_path + "g++",
        ),
        tool_path(
            name = "gcc",
            path = gcc_path + "gcc",
        ),
        tool_path(
            name = "dwp",
            path = gcc_path + "dwp",
        ),
        tool_path(
            name = "gcov",
            path = gcc_path + "gcov",
        ),
        tool_path(
            name = "nm",
            path = gcc_path + "nm",
        ),
        tool_path(
            name = "objdump",
            path = gcc_path + "objdump",
        ),
        tool_path(
            name = "objcopy",
            path = gcc_path + "objcopy",
        ),
        tool_path(
            name = "strip",
            path = gcc_path + "strip",
        ),
        tool_path(
            name = "ar",
            path = gcc_path + "ar",
        ),
    ]
    features = []
    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        cxx_builtin_include_directories = [
            "/opt/toolchain/luckfox/arm-rockchip830-linux-uclibcgnueabihf/share/licenses/gcc/include",
            "/opt/toolchain/luckfox/arm-rockchip830-linux-uclibcgnueabihf/share/licenses/binutils/include",
            "/opt/toolchain/luckfox/arm-rockchip830-linux-uclibcgnueabihf/share/licenses/gdb/include",
            "/opt/toolchain/luckfox/arm-rockchip830-linux-uclibcgnueabihf/arm-rockchip830-linux-uclibcgnueabihf/include",
            "/opt/toolchain/luckfox/arm-rockchip830-linux-uclibcgnueabihf/arm-rockchip830-linux-uclibcgnueabihf/debug-root/usr/include",
            "/opt/toolchain/luckfox/arm-rockchip830-linux-uclibcgnueabihf/arm-rockchip830-linux-uclibcgnueabihf/sysroot/usr/include",
            "/opt/toolchain/luckfox/arm-rockchip830-linux-uclibcgnueabihf/lib/gcc/arm-rockchip830-linux-uclibcgnueabihf/8.3.0/install-tools/include",
            "/opt/toolchain/luckfox/arm-rockchip830-linux-uclibcgnueabihf/lib/gcc/arm-rockchip830-linux-uclibcgnueabihf/8.3.0/include",
            "/opt/toolchain/luckfox/arm-rockchip830-linux-uclibcgnueabihf/lib/gcc/arm-rockchip830-linux-uclibcgnueabihf/8.3.0/include-fixed",
            "/opt/toolchain/luckfox/arm-rockchip830-linux-uclibcgnueabihf/lib/gcc/arm-rockchip830-linux-uclibcgnueabihf/8.3.0/plugin/include",
        ],
        toolchain_identifier = "luckfox-toolchain",
        host_system_name = "linux",
        target_system_name = "linux",
        target_cpu = "luckfox",
        target_libc = "unknown",
        compiler = "linux",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
    )

cc_luckfox_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "path": attr.string(),
    },
    provides = [CcToolchainConfigInfo],
)
