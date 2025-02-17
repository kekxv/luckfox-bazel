load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
)

all_link_actions = [
    ACTION_NAMES.cpp_link_executable,
    ACTION_NAMES.cpp_link_dynamic_library,
    ACTION_NAMES.cpp_link_nodeps_dynamic_library,
]

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

def _impl(ctx):
    tool_paths = [
        tool_path(
            name = "ar",
            path = "wrappers/ar",
        ),
        tool_path(
            name = "cpp",
            path = "wrappers/g++",
        ),
        tool_path(
            name = "gcc",
            path = "wrappers/gcc",
        ),
        tool_path(
            name = "gcov",
            path = "wrappers/gcov",
        ),
        tool_path(
            name = "ld",
            path = "wrappers/ld",
        ),
        tool_path(
            name = "nm",
            path = "wrappers/nm",
        ),
        tool_path(
            name = "objdump",
            path = "wrappers/objdump",
        ),
        tool_path(
            name = "strip",
            path = "wrappers/strip",
        ),
    ]

    default_compiler_flags = feature(
        name = "default_compiler_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-no-canonical-prefixes",
                            "-fno-canonical-system-headers",
                            "-Wno-builtin-macro-redefined",
                            "-D__DATE__=\"redacted\"",
                            "-D__TIMESTAMP__=\"redacted\"",
                            "-D__TIME__=\"redacted\"",
                            "-fPIC",
                        ],
                    ),
                ],
            ),
        ],
    )

    default_cpp_compile_flags = feature(
        name = "default_cpp_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_cpp_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-no-canonical-prefixes",
                            "-fno-canonical-system-headers",
                            "-Wno-builtin-macro-redefined",
                            "-D__DATE__=\"redacted\"",
                            "-D__TIMESTAMP__=\"redacted\"",
                            "-D__TIME__=\"redacted\"",
                            "-fPIC",
                        ],
                    ),
                ],
            ),
        ],
    )

    default_linker_flags = feature(
        name = "default_linker_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_link_actions,
                flag_groups = ([
                    flag_group(
                        flags = [
                            "-lstdc++",
                        ],
                    ),
                ]),
            ),
        ],
    )

    features = [
        default_compiler_flags,
        default_cpp_compile_flags,
        default_linker_flags,
    ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        toolchain_identifier = "armv7l-luckfox-toolchain",
        host_system_name = "linux",
        target_system_name = "linux",
        target_cpu = "armv7",
        target_libc = "unknown",
        compiler = "unknown",
        abi_version = "unknown",
        abi_libc_version = "unknown",
        tool_paths = tool_paths,
    )

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {},
    provides = [CcToolchainConfigInfo],
)
